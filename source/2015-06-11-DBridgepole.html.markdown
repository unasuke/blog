---
title: 複数アプリケーションから参照されるDBをridgepoleで管理する
date: '2015-06-11'
tags:
- howto
- programming
- ruby
---

<a href="http://unasuke.com/wp/wp-content/uploads/2015/06/cb54bc017cda14619a93e81d148884a4.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/06/cb54bc017cda14619a93e81d148884a4-1024x293.png" alt="ridgepole" width="625" height="179" class="alignnone size-large wp-image-1171" /></a>
<h2>忙しい人のためのまとめ</h2>
<p>
  <ul>
    <li>Circle CIに、存在しないHostnameで秘密鍵を追加するのは諦めろ。</li>
    <li>データベースの変更はそれを独立で行えるようにした。具体的にはcap deployでridgepole applyできるようにした。</li>
</p>
<h2>tmixの現状</h2>
<p>
  最近の大規模なwebサービスが、1つのアプリケーションとして動いているというのは珍しいだろう。<a href="http://techlife.cookpad.com/entry/2014/09/08/093000">cookpad社がそうである</a>ように、<a href"http://tmix.jp">tmix</a>も裏ではいくつかのRails Applicationが同時に動作している。
  そしてそれらのRailsが見に行くデータベースはもちろん共通の1つである。
</p>
<p>
  Railsは、そのアプリケーション内でschema.rbを用いてデータベースの定義を行っている。そしてRailsアプリケーションの数だけschema.rbが存在し、各アプリケーションの開発者が各々でschema.rbを好きに編集すると、conflictは避けられない。実際、tmixでもschema.rbを別リポジトリからコピーしてくるなんて作業はしょっちゅう行われていた。
</p>
<p>
  この状況が好ましくないことは誰の目にも明らかであり、解決策としてのridgepoleの導入が必要だった。(参考 <a href="http://techlife.cookpad.com/entry/2014/08/28/194147">クックパッドにおける最近のActiveRecord運用事情</a>)
</p>
<h2>ridgepoleの導入</h2>
<h3>現状の把握</h3>
<p>
  ridgepoleを導入する前に、まずは現状を正しく把握する必要がある。
</p>
<p>
  tmixは、メイン、画像生成、発注管理で3つのRails Applicationが動作している。それぞれはCircle CIによってGitHub Pushのタイミングでテストされ、production deploy時にはCircle CIからcapistranoを用いて本番環境にdeployされるようになっている。
  環境は、development、staging、production、testの4つあり、それぞれにデータベースが存在する。
</p>
<h3>各リポジトリからschemaを適用させる(没案)</h3>
<p>
  まず僕は、schemaを管理するためのリポジトリを作成し、それぞれのリポジトリがdeploy taskのなかでgit cloneを行い、ridgepole applyをさせれば良いと考えた。ridgepoleでは冪等性が保証されているので、schemafileの適用は何度走ってもよい。各アプリケーションがdeployされるたびに、データベースは更新される。
</p>
<p>
  そのために、次のようなシェルスクリプトを作成し、circle.ymlで実行させるようにした。
   
<pre class="lang:sh decode:true " >cd ../
git clone git@github.com:spice-life/tmix-schema.git
cd tmix-schema
bundle install
bundle exec ridgepole -c ../tmix/config/database.yml --apply</pre> 

  当然のように、これはうまく動作しない。なぜなら、Circle CIでテストを行う環境は、その環境と結びついたリポジトリにしかアクセスできず、他のリポジトリをcloneする権限は持っていないからだ。(もちろんこの記事で出てくるリポジトリは大半がprivate)
</p>
<p>
  そこで、いい方法はないものかとCircle CIのchatで聞いてみたところ、user keyを追加しろとの返答があった。しかし、それでは僕がアクセスできる全リポジトリへの権限が渡ってしまう。それに、サービスの運用が属人性の高いものになってしまう。これは良くない。
  そのような返答をすると、今度はkey pairをCircle CIとGitHubに登録しろと言われた。これなら、権限が最小に抑えられて望ましい。
<a href="http://unasuke.com/wp/wp-content/uploads/2015/06/2305cc5a7feb773c49888cf67f011f15.png"><img src="http://unasuke.com/wp/wp-content/uploads/2015/06/2305cc5a7feb773c49888cf67f011f15-133x300.png" alt="circle ciでのchatの様子" width="133" height="300" class="alignnone size-medium wp-image-1115" /></a>
</p>
<p>
  さて、SSH keyを登録するにしても、hostnameがgithub.comではいろいろと都合が悪い。そこで、hostanemeを"ridgepole"として登録し、git cloneするときには明示的にその鍵を使うようにした。具体的には以下のようにした。
 
<pre class="lang:sh decode:true " >cd ../
GIT_SSH=tmix-web/bin/git-ssh.sh git clone git@github.com:spice-life/tmix-schema.git
cd tmix-schema
bundle install
bundle exec ridgepole -c ../tmix/config/database.yml --apply</pre> 

 
<pre class="lang:sh decode:true " >#!/bin/sh
exec ssh -oIdentityFile=~/.ssh/id_ridgepole "$@"</pre> 

  Circle CIで追加した鍵は、内部ではid_をhostnameの前に付与して保存されるのでこのようにしている。
</p>
<p>
  このようにしたことで、git cloneができるようになり、めでたしめでたし……と思っていると、おかしなことが起こり始めた。cap deploy時に次のようなエラーメッセージが表示されるようになったのである。
  <brockquote>
    ERROR: Repository not found.
    fatal: Could not read from remote repository.

    Please make sure you have the correct access rights
    and the repository exists.
  </brockquote>
  もちろん追加した鍵のhostnameはridgepoleなので使われるはずはないのだが、鍵を削除するとdeployができるようになったので、仕方なく鍵を削除した。どうすれば良かったのだろう……
</p>
<p>
  結局、user keyを追加するしか無い。そこで、chat deployを行うbotのuser keyを追加した。これで、git cloneができるようになり、ridgepole applyもできるようになった。
</p>
<p>
  だが、この方針では、本番サーバーそれぞれがschemaリポジトリを保持することになり無駄であること、データベースの変更を単体で行えないなど問題点も多い。
</p>
<h3>ridgepoleをcapistrano deployさせる</h3>
<p>
  なので、schemaが存在するリポジトリをcap deployできるようにした。ただ、このためにサーバーを持つのも無駄なので、deploy先は既存アプリケーションのサーバーを間借りする形にした。
</p>
<p>
  具体的には、以下の記述をdeploy.rbに追記した。
 
<pre class="lang:ruby decode:true " >namespace :deploy do
  after :published, :ridgepole do
    on roles(:db) do
      execute "cd #{fetch(:release_path)}; bundle exec ridgepole -E #{fetch(:stage)} -c database.yml --apply"
    end
  end
end</pre> 

  これでbundle exec cap hoge deployするとその環境のデータベースにridgepole applyができるようになった。
</p>
<h3>テストについて</h3>
<p>
  ridgepoleで読み込むschemafileについてsyatax errorがないか確認する簡単なテストを書いた。
 
<pre class="lang:ruby decode:true " >require "spec_helper"

describe "Schemafile" do
  it "should correct syntax" do
    `bundle exec ridgepole -c database.yml -E test --apply --dry-run`
    expect($?).to eq(0)
  end
end</pre> 

  schemafileについてはこれくらいでいいとして、問題は各アプリケーションのテストである。テスト時に、schema.rbを読み込んであれこれする動作をする場合、やめさせなければならない。Rspecを使用している場合、spec/rails_hepler.rbの
 
<pre class="lang:ruby decode:true " >ActiveRecord::Migration.maintain_test_schema!</pre> 

この記述を削除する必要がある。
</p>

<h2>業務フローがどうなったか</h2>
<p>
  ridgepoleの導入によって、業務の流れは次のようになった。
</p>
<p>
  <ol>
    <li>schemaリポジトリをcloneし、Schemafileをいじる。lacalのデータベースに適用して開発をする。</li>
    <li>変更内容が確定したらPullRequestを送り、test(syntax check)が通るか確認し、レビューしてもらう。</li>
    <li>masterにmergeされた段階でstagingのデータベースに自動でdeployされる。</li>
    <li>各アプリケーションの変更を行い、staging deployなどで動作確認をする。(testはCircle CI上でschemaリポジトリをcloneして行う)</li>
    <li>変更が確定したら、schemaをproduction deployした後、アプリケーションのproduction deployを行う</li>
  </ol>
</p>
<p>    
    例えば共用の開発用データベースが存在する場合は、それに対しては手動でridgepole applyする必要がある。
</p>
