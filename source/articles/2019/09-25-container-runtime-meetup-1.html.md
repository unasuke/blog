---

title: "Container Runtime Meetup #1でNOTIFY\_SOCKETについて話してきました"
date: 2019-09-25 02:37 JST
tags:
- programming
- runc
- docker
- golang
- diary

---

![git grep NOTIFY_SOCKET](2019/container-runtime-meetup-1-git-grep.png)

[Container Runtime Meetup #1 - connpass](https://runtime.connpass.com/event/145088/) に参加して `NOTIFY_SOCKET` について調べたことを話してきました。

この記事ではその内容の書き起こしと、その場で行われた会話についてのメモについて書きます。

## 参加するきっかけ
@udzuraさんにそそのかされたことがきっかけです。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">⁦<a href="https://twitter.com/yu_suke1994?ref_src=twsrc%5Etfw">@yu_suke1994</a>⁩ 情報です <a href="https://t.co/U5zsvUlz30">https://t.co/U5zsvUlz30</a></p>&mdash; Uchio KONDO 🔫 (@udzura) <a href="https://twitter.com/udzura/status/1166345876769394689?ref_src=twsrc%5Etfw">August 27, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

あまりよくないExecuteをすると、普段はRails APIを運用していてRubyしか書いておらず、Goも数年前にCLI toolを作った程度で、GoやLinuxのコンテナ回りに詳しいという訳ではありません。

## 読む対象について
connpassのイベント概要に

> 少人数の輪読形式です。「参加枠1」の方々にはあらかじめ「runc run」周辺のコードをざっと読んできてもらい、当日、それに関連するトピックをそれぞれ発表して頂きます。「聴講のみ」の方々は、発表の必要はありません。

とあったので、その時点での最新リリースである v1.0.0-rc8 を対象に読むことにしました。

<https://github.com/opencontainers/runc/releases/tag/v1.0.0-rc8>

`runc run` が実行されたとき、呼び出される実体は run.go だろうとアタリをつけ、周辺を読んでいきます。

```go
		status, err := startContainer(context, spec, CT_ACT_RUN, nil)
		if err == nil {
			// exit with the container's exit status so any external supervisor is
			// notified of the exit with the correct exit status.
			os.Exit(status)
		}
```

<https://github.com/opencontainers/runc/blob/v1.0.0-rc8/run.go#L76>

まずここで `startContainer` によりContainerがstartするものと思われます。中を見ていきます。

```go
func startContainer(context *cli.Context, spec *specs.Spec, action CtAct, criuOpts *libcontainer.CriuOpts) (int, error) {
	id := context.Args().First()
	if id == "" {
		return -1, errEmptyID
	}

	notifySocket := newNotifySocket(context, os.Getenv("NOTIFY_SOCKET"), id)
	if notifySocket != nil {
		notifySocket.setupSpec(context, spec)
	}
```
<https://github.com/opencontainers/runc/blob/v1.0.0-rc8/utils_linux.go#L405-L414>

`startContainer` 内部、 411行目にて `os.Getenv("NOTIFY_SOCKET")` としている部分があります。この環境変数は何でしょう？気になったので、ここを掘っていきました。

この時点で僕の `NOTIFY_SOCKET` に対する認識は、

> 「環境変数がある状態で起動させると色々な通知が飛んでくるのだろうか？」

くらいのものでした。

## Dive into code
では、 `newNotifySocket` で何が行われているかを見ていきます。

```go
func newNotifySocket(context *cli.Context, notifySocketHost string, id string) *notifySocket {
	if notifySocketHost == "" {
		return nil
	}

	root := filepath.Join(context.GlobalString("root"), id)
	path := filepath.Join(root, "notify.sock")

	notifySocket := &notifySocket{
		socket:     nil,
		host:       notifySocketHost,
		socketPath: path,
	}

	return notifySocket
}
```

<https://github.com/opencontainers/runc/blob/v1.0.0-rc8/notify_socket.go#L23-L38>

この関数の返り値として、 `notifySocket` 構造体のインスタンス(のポインタ？)が得られます。

ちなみに `notifySocket` 構造体はこのように定義されています。

```go
type notifySocket struct {
	socket     *net.UnixConn
	host       string
	socketPath string
}
```
<https://github.com/opencontainers/runc/blob/v1.0.0-rc8/notify_socket.go#L17-L21>

ところで `newNotifySocket` 関数の引数として渡される `context *cli.Context` は何でしょうか。

これはruncが採用しているCLIツール用パッケージ <https://github.com/urfave/cli> で定義されている Context 構造体を指しています

<https://godoc.org/github.com/urfave/cli#Context>

`startContainer` では、 `newNotifySocket` を呼んだ直後に、返ってきた `notifySocket` に対して `setupSpec` を呼んでいます。これも見ていきます。

```go
// If systemd is supporting sd_notify protocol, this function will add support
// for sd_notify protocol from within the container.
func (s *notifySocket) setupSpec(context *cli.Context, spec *specs.Spec) {
	mount := specs.Mount{Destination: s.host, Source: s.socketPath, Options: []string{"bind"}}
	spec.Mounts = append(spec.Mounts, mount)
	spec.Process.Env = append(spec.Process.Env, fmt.Sprintf("NOTIFY_SOCKET=%s", s.host))
}
```
<https://github.com/opencontainers/runc/blob/v1.0.0-rc8/notify_socket.go#L44-L50>

この関数のコメントにもあるように、systemdが何か関係していそうだということがわかりました。

ここでの処理は runtime-spec を読むとわかりそうです。とりあえず、`Process.Env` に対して `NOTIFY_SOCKET` 環境変数を追加しているようです。

`startContainer` に戻ると、 `createContainer` を呼んだあとに `notifySocket.setupSocket()` を呼んでいます。これを見ていきます。

```go
func (s *notifySocket) setupSocket() error {
	addr := net.UnixAddr{
		Name: s.socketPath,
		Net:  "unixgram",
	}

	socket, err := net.ListenUnixgram("unixgram", &addr)
	if err != nil {
		return err
	}

	s.socket = socket
	return nil
}
```
<https://github.com/opencontainers/runc/blob/v1.0.0-rc8/notify_socket.go#L52-L65>

`net.UnixAddr` とは何でしょうか。これの実体は <https://golang.org/pkg/net/#UnixAddr> にあります。

```go
type UnixAddr struct {
    Name string
    Net  string
}
```

ここでの `unixgram` は datagram socketを指すようで、UDPのような送りっぱなしのプロトコルのようです。
( <https://github.com/golang/go/blob/master/src/net/unixsock_posix.go#L16-L27> の `syscall.SOCK_DGRAM` を参照 )

`net.ListenUnixgram` によってconnectionを張り、それを `notifySocket.socket` に格納したものを、 `runner` 構造体の `notifySocket` フィールドに入れています。

```go
type runner struct {
	init            bool
	enableSubreaper bool
	shouldDestroy   bool
	detach          bool
	listenFDs       []*os.File
	preserveFDs     int
	pidFile         string
	consoleSocket   string
	container       libcontainer.Container
	action          CtAct
	notifySocket    *notifySocket
	criuOpts        *libcontainer.CriuOpts
}
```
<https://github.com/opencontainers/runc/blob/v1.0.0-rc8/utils_linux.go#L254-L267>

この後に、 `notifySocket` に対して行われている操作は、`runner.run` 内部で以下のコードを呼んでいる部分があります。

```go
// Setting up IO is a two stage process. We need to modify process to deal
// with detaching containers, and then we get a tty after the container has
// started.
handler := newSignalHandler(r.enableSubreaper, r.notifySocket)
```
<https://github.com/opencontainers/runc/blob/v1.0.0-rc8/utils_linux.go#L305-L308>

### 一旦まとめ
一旦ここまでをまとめると、

- `NOTIFY_SOCKET` という環境変数をもとにsoket通信をしている？
- これは `unixgram` によって通信するもの
- systemd が何か関係しているようだ

といったところでしょうか。

## NOTIFY_SOCKET を調べる
何やらsystemdが関係していそうなことはわかっているので、単純に `NOTIFY_SOCKET` でググってみると、いくつか記事が見付かりました。

- <https://www.freedesktop.org/software/systemd/man/sd_notify.html#Notes>
- [sd_notifyの通信方法 - Qiita](https://qiita.com/ozaki-r/items/ced43d5e32af67c7ae04)
- [systemd(1) — Arch Linux マニュアルページ](https://man.kusakata.com/man/systemd.1.html)

freedesktop.orgでは

> These functions send a single datagram with the state string as payload to the AF_UNIX socket referenced in the \$NOTIFY_SOCKET environment variable. If the first character of \$NOTIFY_SOCKET is "@", the string is understood as Linux abstract namespace socket.

<https://www.freedesktop.org/software/systemd/man/sd_notify.html#Notes>

「sd_notifyの通信方法 - Qiita」では

> systemdのマネージャ(デーモンプロセス)は、起動プロセスの最後の方でsd_notifyという関数を用いて、起動が完了したことをsystemd本体(PID=1)に通知する。(注：sd_notifyは実際にはもっと汎用的なステータス通知に使える。)

<https://qiita.com/ozaki-r/items/ced43d5e32af67c7ae04>

ざっくりとした理解でいくと、プロセスが起動した、などのステータスの通知に使用されているんだろうということがわかりました。

## Dockerの場合
ここで、「ではDockerの場合はどうなのだろう」と思い、 <https://github.com/docker/cli> 内をgrepしましたが、見当りません。いや、Dockerはmobyに移行したのでした。 案の定、 <https://github.com/moby/moby> 内をgrepすると見付かりました。

```shell
$ git grep NOTIFY_SOCKET
libcontainerd/supervisor/remote_daemon.go:200:  // clear the NOTIFY_SOCKET from the env when starting containerd
libcontainerd/supervisor/remote_daemon.go:203:          if !strings.HasPrefix(e, "NOTIFY_SOCKET") {
vendor/github.com/coreos/go-systemd/daemon/sdnotify.go:49:// If `unsetEnvironment` is true, the environment variable `NOTIFY_SOCKET`
vendor/github.com/coreos/go-systemd/daemon/sdnotify.go:53:// (false, nil) - notification not supported (i.e. NOTIFY_SOCKET is unset)
vendor/github.com/coreos/go-systemd/daemon/sdnotify.go:54:// (false, err) - notification supported, but failure happened (e.g. error connecting to NOTIFY_SOCKET or while sending data)
vendor/github.com/coreos/go-systemd/daemon/sdnotify.go:58:              Name: os.Getenv("NOTIFY_SOCKET"),
vendor/github.com/coreos/go-systemd/daemon/sdnotify.go:62:      // NOTIFY_SOCKET not set
vendor/github.com/coreos/go-systemd/daemon/sdnotify.go:68:              if err := os.Unsetenv("NOTIFY_SOCKET"); err != nil {
vendor/github.com/coreos/go-systemd/daemon/sdnotify.go:74:      // Error connecting to NOTIFY_SOCKET
```
<https://github.com/moby/moby/search?q=NOTIFY_SOCKET&unscoped_q=NOTIFY_SOCKET>

ということは、Dockerを使っているだけでそのようなsocketが作成されているのではないでしょうか。調べてみましょう。

Docker daemonが動作しているマシン上で、systemdが関係していそうなunixドメインソケットの数を出してみました。

```shell
$ ss --family=unix | grep systemd | wc -l
110
```

けっこうな数ありますね。grepする単語を変えてみます。

```shell
$ ss --family=unix | grep container
u_str    ESTAB   0  0     /var/snap/microk8s/common/run/containerd.sock 21833469  * 21836828
u_str    ESTAB   0  0     /var/snap/microk8s/common/run/containerd.sock 21836830  * 21836829
u_str    ESTAB   0  0        /var/run/docker/containerd/containerd.sock 23108     * 23106   
u_str    ESTAB   0  0        /var/run/docker/containerd/containerd.sock 23114     * 23113   
u_str    ESTAB   0  0        /var/run/docker/containerd/containerd.sock 23110     * 25748   
```

それらしきものが存在しています。

もっと見ていきましょう。dockerdのpidを調べます。

```shell
$ ps aux --forest # 抜粋
root  601  /usr/bin/dockerd -H fd://
root  769   \_ containerd --config /var/run/docker/containerd/containerd.toml --log-level info
root 1213       \_ containerd-shim -namespace moby -workdir /var/lib/docker/containerd/daemon/io.containerd.runtime.v1.linux/moby/61f9489e17355a4f00594feb5c
root 1230           \_ bash
```

pid `601` の環境変数を見てみます。

```shell
$ sudo cat /proc/601/environ # 改行を入れています
LANG=ja_JP.UTF-8
PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/var/lib/snapd/snap/bin
NOTIFY_SOCKET=/run/systemd/notify
LISTEN_PID=601
LISTEN_FDS=1
LISTEN_FDNAMES=docker.socket
INVOCATION_ID=e65738cc4b8f461e968d23c6740a557e
JOURNAL_STREAM=9:22835
```

確かに `NOTIFY_SOCKET` がありますね。

## ここまでのまとめと今後の目標
- `NOTIFY_SOCKET` でsystemdとやりとりしているようだ
- `dockerd` には `NOTIFY_SOCKET` が与えられていることが確認できた
- `runc run` を実行したときにもこれは与えられるのか？
- 実際にどのようなデータがどのようなタイミングで送られるのか？
  - dockerでは？ runcでは？他では？

ここまでがMeetupでの発表内容になります。

## 当日の議論
ここからは、当日の発表のあと、その場で行われた議論の簡単な書き起しになります。

- `NOTIFY_SOCKET` が与えられるのは、systemd経由で起動した場合だけで、bashなどから直接 `$ runc run` など実行してもこの環境変数が自動的に作成されるということはない。
    - そもそもこの環境変数はDockerやruncに特有なものではなくどのようなプロセスにおいても汎用的に使用できるもの。
- systemd に対して自身の状態がどうなったのか、を通知するために使われる
- もし `NOTIFY_SOCKET` を活用できるのであれば、docker-composeにおける `pg_isready` などのhackが不要になるんじゃないか？
    - docker-composeはcontainerの起動までは面倒みてくれるけどprocessがreadyになったかどうかまでは見てくれない
    - <https://github.com/containers/libpod/issues/746#issuecomment-388959969> が何か関係している？
    - 現時点でもただ `return` しているだけなので改善の余地はありそう
        - <https://github.com/opencontainers/runc/blob/v1.0.0-rc8/notify_socket.go#L69-L109>
    - <https://github.com/containers/podman-compose> なんてあったのか
    - 活用するためにはミドルウェアが `sd_notify` を使用して自身の状態を通知しないといけないからそれもハードルになるのではないか
        - <https://www.freedesktop.org/software/systemd/man/systemd.service.html#Options>
            - この `Type=notify` がそれらしい
        - MariaDB (MySQLも？)はできていそう
            - [Ubuntuでmysql-serverをmariadb-serverで置き換えるとsystemd経由でmariadbが起動できない - NaruseJunのメモ帳](https://narusejun.com/archives/24/)
