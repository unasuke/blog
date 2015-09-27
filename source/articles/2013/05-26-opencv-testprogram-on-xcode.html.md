---
title: XcodeでOpenCV始めると大変
date: '2013-05-26'
tags:
- howto
- mac
- programming
---

## OpenCVのインストール

[前回記事](2013/05-23-install-git-using-macports)でMacPortsを使ってGitをインストールした。その流れにのり、MacPortsでOpenCVをインストールする。

```shell
$ sudo port selfupdate
$ sudo port install opencv
```

長い時間掛かるかもしれないのでこれからの苦難を想像して身構えておくのが吉。

## Xcodeの準備

まずはプロジェクトの作成から始める。
![プロジェクトの作成](2013/opencv-setup-01.png)
Create a new Xcode project"を選択し……
![プロジェクトの選択](2013/opencv-setup-02.png)
OS X"の"Application"の"Command Line Tool"を選択し……
![プロジェクトの作成2](2013/opencv-setup-03.png)
各項目を記入し……
こんな画面になるかと思うので、囲ったところをクリックして下準備。
![プロジェクトを作成](2013/opencv-setup-04.png)

## 下準備

まずはHeader Search PathとLiberty Search Pathを設定する。それぞれ　MacPortsからインストールした場合は、Header Search Pathが
`/opt/local/include`
Liberty Search Pathが
`/opt/local/include`
`/opt/local/lib`
と、それぞれnon-recursiveで設定する。recursiveにすると大量のエラーが出る。Liberty Search Pathは設定してない例もいくつか見つけたので不要かもしれない。
![Search Pathの設定](2013/opencv-setup-05.png)
![Seach Path設定完了](2013/opencv-setup-06.png)

次にLink Binary With Librariesを設定する。今回はウィンドウの表示、ガウシアンフィルタを利用するので、以下の4つのLibraryをリンクさせる。
`libc++.dylib`
`libopencv_core.2.4.5.dylib`
`libopencv_highgui.dylib`
`libopencv_imgproc.dylib`

OpenCVの.dylibは(MacPortsからのインストールなら)`/opt/local/lib`にあるので検索すると見つけやすい。追加は"Add Other"から行う。
![libc++.dylibのリンク](2013/opencv-setup-07.png)
![libopencv_hoge.dylibのリンク](2013/opencv-setup-08.png)
これで下準備は終わり。

## テストプログラムを打ち込む

今回はある画像をガウシアンフィルタを適用しぼかす。

```cpp
//
//  main.cpp
//  OpenCV-test
//
//  Created by unasuke on 2013/05/26.
//  Copyright (c) 2013年 unasuke. All rights reserved.
//

#include <iostream>

#ifdef __cplusplus
#include <opencv2/opencv.hpp>
#endif

int main(int argc, const char * argv[])
{
  // insert code here...

  //画像を開く
  IplImage* before_img = cvLoadImage("/Users/yusuke/Desktop/lena.jpg", CV_LOAD_IMAGE_ANYDEPTH | CV_LOAD_IMAGE_ANYCOLOR );
  if( before_img == NULL )
  {
    return 0;
  }

  //ウィンドウの作成
  cvNamedWindow("test-before", CV_WINDOW_AUTOSIZE);
  cvNamedWindow("test-after" , CV_WINDOW_AUTOSIZE);

  //画像変換のためIplImage型で宣言
  IplImage* after_img = cvCreateImage(cvGetSize(before_img), before_img->depth, before_img->nChannels);

  //ガウシアンフィルタを使って画像をぼかす
  cvSmooth(before_img, after_img, CV_GAUSSIAN , 9);

  //画像をウィンドウに表示
  cvShowImage("test-before", before_img);
  cvShowImage("test-after", after_img);

  //キーの入力待ち
  cvWaitKey();

  //すべてのウィンドウを削除
  cvDestroyAllWindows();

  //画像データの開放
  cvReleaseImage(&before_img);
  cvReleaseImage(&after_img);

  return 0;
}
```

で、実行するとこうなる。
![サンプルコードの実行結果](2013/opencv-setup-09.png)
疲れた。
