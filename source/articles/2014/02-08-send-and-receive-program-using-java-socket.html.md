---
title: JavaのSocketを用いたテキスト、ファイルの送受信
date: '2014-02-08'
tags:
- howto
- java
- programming
---

[ソケット通信でファイル転送その２](http://d.hatena.ne.jp/rintaromasuda/20060327/1143412352)を参考に、JavaのSocketを用いてテキストの送受信、ファイルの送受信を行うプログラムを作成した。
Java初心者なので「これはおかしい」「これはいくらなんでも変だ」「こんな書き方は許せない」などがあるのは許してほしい。


## サーバ側プログラム(FileSendServer.java)

### コード

```java
import java.io.*;	//入出力ストリーム
import java.net.*;	//socket

public class FileSendServer{

  /************************定数宣言***********************/
  public static final int INPUT_STREAM_BUFFER = 512;	//入力ストリーム格納バッファサイズ
  public static final int FILE_READ_BUFFER = 512;	//ファイル読み込みバッファサイズ

  //引数は使用しない
  public static void main(String[] args){

    ServerSocket servSock = null;
    Socket sock;    //socket通信

    OutputStream outStream;	//送信用ストリーム
    InputStream inStream;	//受信用ストリーム
    FileInputStream fileInStream; //ファイルを読むためのストリーム
    byte[] inputBuff = new byte[INPUT_STREAM_BUFFER];	//クライアントからのコマンド入力を受け取る
    byte[] fileBuff = new byte[FILE_READ_BUFFER];	//ファイルから読み込むバッファ

    String absolutePath = new File(&quot;&quot;).getAbsolutePath();
    File file = new File(absolutePath);	//カレントディレクトリでインスタンス作成
    String[] 	fileList = file.list();	//カレントディレクトリのファイル名取得
    Boolean hiddenFileFlag;	//隠しファイルフラグ
    Boolean lsFlag;
    int recvByteLength;

    //大きすぎるtryは身を滅ぼす
    try
    {

      //6001番ポート
      servSock = new ServerSocket(6001);

      //ソケットに対する接続要求を待機
      sock = servSock.accept();

      //入出力ストリーム設定
      outStream = sock.getOutputStream();
      inStream = sock.getInputStream();

      //コマンドの入力があった場合に行う処理(1文字以上読みこんだとする)
      while( (recvByteLength = inStream.read(inputBuff))  != -1 )
      {
        //受け取ったbyte列をStringに変換(構文解析のため)
        String buff = new String(inputBuff , 0 , recvByteLength);

        //スペースで区切り格納し直す(sscanfのような)
        String[] getArgs = buff.split(&quot;\\s&quot;);


        /************************コマンド解析*********************/
        //lsの場合
        if( getArgs[0].equals(&quot;ls&quot;) )
        {
          //ファイル(フォルダ)数繰り返す
          for( int i = 0;  i < fileList.length; i++)
          {
            //String→byteに変換して送信
            outStream.write( fileList[i].getBytes() );
            outStream.write( &quot;\n&quot;.getBytes() );
          }
        }

        //getの場合
        if( getArgs[0].equals(&quot;get&quot;) )
        {				
          //受け取ったファイル名のファイルを読み込むストリーム作成
          fileInStream = new FileInputStream(getArgs[1]);
          int fileLength = 0;
          //System.out.println(&quot;Create stream &quot; + getArgs[1] );

          //最大data長まで読み込む(終端に達し読み込むものがないとき-1を返す)
          while( (fileLength = fileInStream.read(fileBuff)) != -1 )
          {
            //出力ストリームに書き込み
            outStream.write( fileBuff , 0 , fileLength );
          }

          //ファイルの読み込みを終える
          //System.out.println(&quot;Close stream &quot; + getArgs[1] );
          fileInStream.close();
        }

        //exitの場合
        if( getArgs[0].equals(&quot;exit&quot;) )
        {
          //ストリームを閉じる
          outStream.close();
          System.out.println(&quot;close server&quot;);
          break;
        }
      }

      //ソケットやストリームのクローズ
      //outStream.close();
      inStream.close();

      sock.close();
      servSock.close();

    }

    //例外処理
    catch( Exception e )
    {
      System.err.println(e);
      System.exit(1);
    }
  }
}
```

[gist](https://gist.github.com/unasuke/8837169)

### 動作説明

サーバ側は6001ポートで接続を待機する。接続確認後はクライアントからのコマンド送信まで待機。
コマンドを受信すると、スペースごとに区切り、引数として格納。
コマンドがlsの場合、実行されているフォルダのファイルの一覧をクライアント側に送信。
コマンドがgetの場合、2つ目の引数に格納されているファイルをクライアント側に送信。
コマンドがexitの場合、クライアントからの入力待ちループを抜ける。
ループを抜けたらsocketを閉じて終了する。


## クライアント側プログラム(FileRecvCiant.java)

### コード

```java
import java.io.*;
import java.net.*;

public class FileRecvCliant{

  /***************************定数宣言***************************/
  public static final int INPUT_STREAM_BUFFER = 512;
  public static final int FILE_WRITE_BUFFER = 512;

  //引数として、サーバのIPアドレスとポート番号を要求する
  public static void main(String[] args){

    //引数エラー
    if( args.length != 2 ){
      System.err.println(&quot;argument error&quot;);
      System.exit(1);
    }

    OutputStream outStream;	//送信用ストリーム
    InputStream inStream;	//受信用ストリーム
    FileOutputStream fileOutStream;	//ファイルの書き込むためのストリーム

    byte[] inputBuff = new byte[INPUT_STREAM_BUFFER];	//サーバからのls出力を受け取る
    byte[] fileBuff = new byte[FILE_WRITE_BUFFER];	    //サーバからのファイル出力を受け取る

    String command;	        //キーボードからの入力を格納
    int recvFileSize;	    //InputStreamから受け取ったファイルのサイズ
    int recvByteLength = 0; //受信したファイルのバイト数格納
    int waitCount = 0;      //タイムアウト用


    //キーボードからの入力受付
    BufferedReader keyInputReader = new BufferedReader( new InputStreamReader(System.in) );

    //tryが大きすぎる。訴訟も辞さない。
    try
    {
      //ソケットのコンストラクト
      Socket sock = new Socket( args[0] , Integer.parseInt(args[1]) );

      //ソケットが生成できたらストリームを開く
      outStream = sock.getOutputStream();
      inStream = sock.getInputStream();

      //ここからループ
      while(true)
      {
        //コマンド入力を促す
        System.out.print(&quot;cmd:&quot;);

        //キーボードからのコマンド入力
        command = keyInputReader.readLine();

        //スペースごとにコマンドを区切る
        String[] getArgs = command.split(&quot; &quot;);

        //キーボードからの入力をそのまま送信
        outStream.write( command.getBytes() , 0 , command.length() );


        /************************コマンド解析***********************/
        //lsの場合
        if( getArgs[0].equals(&quot;ls&quot;) )
        {
          waitCount = 0;
          //入力を文字列として表示
          while( true )
          {
            //ストリームから読み込める時
            if( inStream.available() > 0 )
            {
              //byte→Stringに変換して標準出力
              recvByteLength = inStream.read(inputBuff);
              String buff = new String( inputBuff );
              System.out.print( buff );
            }
            //タイムアウト処理
            else
            {
              waitCount++;
              Thread.sleep(100);
              if( waitCount > 10 )break;
            }
          }
        }

        //getの場合
        if( getArgs[0].equals(&quot;get&quot;) )
        {
          //引数で指定されたファイルを保存するためのストリーム
          fileOutStream = new FileOutputStream( getArgs[1] );
          waitCount = 0;

          //ストリームからの入力をファイルとして書き込む
          while( true )
          {
            //ストリームから読み込める時
            if( inStream.available() > 0 )
            {
              //受け取ったbyteをファイルに書き込み
              recvFileSize = inStream.read(fileBuff);
              fileOutStream.write( fileBuff , 0 , recvFileSize );
            }

            //タイムアウト処理
            else
            {
              waitCount++;
              Thread.sleep(100);
              if (waitCount > 10)break;
            }
          }

          //ファイルの書き込みを閉じる
          fileOutStream.close();

          //書き込み完了表示
          System.out.println( &quot;Download &quot;+ getArgs[1] + &quot; done&quot; );
        }

        //exitコマンド入力でwhileループを抜ける
        if( getArgs[0].equals(&quot;exit&quot;) )
          break;
      }

      //ストリームのクローズ
      outStream.close();
      inStream.close();
    }
    catch(Exception e)
    {
      //例外表示
      System.err.println(e);
      System.exit(1);
    }
  }
}
```

[gist](https://gist.github.com/unasuke/8837211)

### 動作説明

クライアント側は引数として受け取ったIPアドレスとポート番号に対して接続要求をかける。
接続が確認されると、ユーザからのコマンド入力を待ち、スペースごとに区切り、引数として格納。
コマンドがlsの場合、受け取ったデータをStringとして標準出力に表示する。
コマンドがgetの場合、2つ目の引数に格納されているファイル名で受け取ったデータを保存する。
コマンドがexitの場合、ループを抜ける。
ループを抜けたらsocketを閉じて終了する。
入力はタイムアウト制とする。(InputStreamのreadメソッドの返り値として-1が吐かれるのはストリームが閉じた時であるため)

## ライセンス

こんなしょぼいコードにライセンスもクソもあったもんじゃないがあえて言うならMITで。
