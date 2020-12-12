---
title: "サーバーサイドエンジニアとして2020年に使った技術"
date: 2020-12-12 21:59 JST
tags: 
- programming
- dialy
---


![使用したプログラミング言語統計](2020/programming-language-stats.png)

[2020年のフロントエンドエンジニアの技術スタックの一例 | potato4d D(iary)](https://d.potato4d.me/entry/20201129-frontend-2020/)

この記事と、TLで「これのバックエンド版が見たい」という発言に触発されたので書いてみます。口語体と文語体が入り乱れてるのは許してください。

冒頭のグラフはwakatimeで生成した今年1年間のプログラミング言語使用率です。2位はTypeScript、3位はTerraform、4位はYAMLでした。

## 立場
フリーランスで、主にRailsやAWSを使用しているサービスの運用、開発に関わっています。いくつもの会社を見てきた訳ではなく、数社に深く関わっている[^company]都合上、視野が狭いかもしれません。

公開している成果としては [クラウドゲーミング最新開発事例 - #CEDEC2020 - Speaker Deck](https://speakerdeck.com/oliver_diary/kuraudogeminguzui-xin-kai-fa-shi-li-number-cedec2020) があります。

長年RubyとRailsを書いてきたので、技術スタックがそのあたりに偏っています。

## 利用した技術一覧
太字は特記事項があるものです。また、挙げている技術は「ある程度触った」くらいで記載しており、全てに習熟している訳ではありません[^strong]。

各項目について、上のほうがよく使っているものという傾向がありますが、厳密ではないです。

- Language
    - **Ruby**
        - 後述するRailsの他にも、業務改善のためのbotの作成など「今すぐ必要なちょっとしたscpit」の実装言語としても
    - **TypeScript**
    - Python
        - API serverの実装として
    - Go
        - 書いたものの、本番投入まで行えていない
- Framework
    - **Rails**
        - Slim/RSpec/RuboCop/Devise etc...
    - **React/Vue**
        - Jest
- Middleware/Infrastructure
    - **Docker**
    - PostgreSQL
    - MySQL
    - AWS
        - DynamoDB
        - Aurora
        - SQS
        - **Fargate/ECS**
        - EC2
        - Lambda
        - S3
        - CloudWatch
    - GCP
        - BigQuery
        - Cloud Run
            - ちょっとしたBotを動かすのにCloud Runが非常に便利、Postgresが不要であればHerokuより手軽なんじゃないでしょうか。Cloud Buildと組合せた自動deployの体験が最高
        -  Cloud Monitoring
        - Compute Engine
    - Terraform
        - IaCはAWS、GCP両方使ってる場合でも片方しか使っていなくてもTerraformで書くのが普通という雰囲気。Terraform Cloudも便利
- CI
    - Travis CI
        - Matrix buildの記法が簡単なのもあって、OSSでは結構使っている。が、今後はCircleCIやGitHub Actionsに移っていくだろう
    - CircleCI
        - 業務でCIっていうとCircleClが多い印象。少しずつGitHub ActionsにCI jobを切り出しているところもあり。
    - GitHub Actions
        - やはりGitHubとの連携機能が強い。CircleCIもそうだけど記法を手に馴染ませるのが少し手間
- Monitoring
    - Datadog
        - 見るだけ
    - Sentry
        - ほぼ見るだけ
    - RollBar
        - 見て、コメントしたりする
- OS
    - Linux
        - 本番環境は余程のことがない限りはLinux。基本的な操作はできるつもり、常用はUbuntu。
    - macOS
        - メイン現場での貸与PCがmacOSだったけど、Windows(にしてLinuxを入れる)を選択できると知っていたら選ばなかったかも。まだCatalina。
    - Windows
        - WSL2での開発は、仕事では使わなかったが常用できるレベルだと感じた。検証とか通話とかで使う。
- Editor
    - **IntelliJ Idea系**
        - RubyMine
        - WebStorm
        - Goland
        - DataGrip
    - Vim
    - VS Code
- 概念的なもの
    - WebRTC
        - 軽くどういうものなのかの理解、利用については提供されているライブラリを使用する、程度
    - microservices
    - REST API
        - GraphQLもgRPCも使わなかったなあ。
- その他
    - OBS
        - 割と使用する。COVID-19の影響で画面や映像を配信するというタスクの重要性が増し、OBSなどの配信ツールの基本的な操作は必要性が増してきているんじゃないでしょうか？
    - Illustrator
        - 発表資料の作成で、PowerPointもKeynoteもないがイラレはあるという状況。冒頭の発表資料、インフラサイドの図は大体イラレで作成されています

主軸としてはRuby/Rails/AWSの主要コンポーネント というところでした。

## 特記事項
### Ruby
今年も僕の主戦場はRubyでした。あと数年はRuby以外を軸に仕事をしていくことになるんじゃないかな……？ただ2020年らしいことは全くしていなくて、例えばRuby 2.7で導入された機能、Pattern matchingやnumberd parameterは使った記憶がないです。(Pattern matchingは使おうとしたが、愚直に書いたほうが短かくなったので断念)

### TypeScript
今年はJavaScriptをBrowser console以外で書いた記憶がありません。

### Rails
キャリアがRailsから始まっているので、思い入れがあります。また、新しい現場でもすぐにコードを書けるところは助かっています。とは言えコードが肥大化してくると何がどうやって動いているのか把握するのには時間がかかりますが、これはまあどんなものでもそうでしょう。
業界においてRailsが優位にあるとすれば、その実装速度の早さと、コードやデータ量、ビジネスロジックがある程度成長しても耐えられるRubyの表現力及びActiveRecordの底力があるように思います。あと数年は新規実装としてのRailsの立場は残っていると思います。それ以降はまた状況が変わっていると思うのでわかりません。

### React/Vue.js
これを1つにまとめたのは、主にRails appに組み込まれたものを書いていたためです。TypeScriptもそうなのですが、JavaScriptに関しては既存のコードベースに手を入れるということはできても、設計を含めた0から書き始めるということができていない、できないのが自分の弱みだと感じているので、プライベートの時間ではキャッチアップをしています。

### Docker
コンテナ技術はもう前提条件と言えるくらいには利用が広がっていますね。ECSやKubernetesをはじめとしたエコシステムの発展もあり、開発環境から本番環境までDockerで環境が統一されていることの便利さ、docker-compose一発で開発環境が準備できる手軽さは一度体験するともう戻れないと言っていいです。

Docker for Macが遅い遅いと言われ続けている昨今ですが、僕の環境においては許容範囲というか、あまりそこで困らなかった印象があります。大分改善されているのではないでしょうか。それとも僕が鈍いのか。

### Fargate/ECS
業務としては一切Kubernetesを使用しませんでした。関わっている範囲だとこの2つで十分要求を満たすことができていました。

### IntelliJ Idea系
これは、今年春から JetBrains All Products Pack を契約して使い始めました。これについては1本ブログ記事を書くつもりで下書きを温めていたのですが、この際ですからそれから引用する形にします。

> Rubyを第一言語としていますが、PythonやGoなどで書かれたAPI serverの開発を素早く完了させる必然性が増えました。
> これまでは腰を据えてプロダクトの全容をあらかた把握した上で開発を進めることが多かったのですが、とにかく素早く問題点を発見して修正する、それもあまり習熟していない言語で、という状況に置かれることが増えてきました。
それに、習熟しているつもりのRubyですら、今までにない大規模なアプリケーションの機能開発においては全容を把握しておくということが困難です。

また、DB clientとしてのDataGripが非常に便利なのは嬉しい誤算でした。

## おわりに
あまりRails界隈でこういう記事をみかけない気がするので、他の皆さんはどうなのか知りたいので書いてほしかったり……年の瀬に1年を振り返ってみるのは楽しかったです。

[^strong]: インターネット・強・パーソンの皆さまは、あれがないこれがないこいつはショボいとお叩きになられるのでは……とビクビクしています。
[^company]: おおっぴらに言わないだけで探せばわかります