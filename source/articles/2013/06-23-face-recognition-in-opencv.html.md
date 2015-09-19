---
title: OpenCVで顔認識
date: '2013-06-23'
tags:
- howto
- mac
- programming
---

もしやMacPortsからOpenCVを導入したのは間違いだったのではと感じた。

## 必要なもの

- カメラもしくは人の顔が写った画像
- 顔認識に必要なデータ(後述)
- イケメン(後述)

## 顔認識に必要なデータとは

OpenCVのインストールフォルダにdataフォルダがあって、その中のhaarcascadesフォルダに顔認識に必要なファイルがあるが、MacPortsからOpenCVをインストールするとそんなのはない。
Githubで落としてくるとかして手に入れなければならない。[Itseez/opencv・GitHub](https://github.com/Itseez/opencv)

## イケメンとは

顔認識するときカメラ起動するとキモい顔が映って死ぬ。

## ソースコード
```cpp
#include <iostream>
#ifdef __cplusplus
#include <opencv2/opencv.hpp>
#endif

int main(int argc, char *argv[])
{
  cv::Mat img , gray;
  // カメラからのビデオキャプチャを初期化する
  cv::VideoCapture cap(0);

  //キャプチャ画像をRGBで取得
  cap.set( CV_CAP_PROP_FRAME_HEIGHT, 720 );
  cap.set( CV_CAP_PROP_FRAME_WIDTH, 1280 );

  //カメラがオープンできない場合終了
  if( !cap.isOpened() )
  {
    return -1;
  }

  // ウィンドウを作成する
  char windowName[] = "camera";
  cv::namedWindow( windowName, CV_WINDOW_AUTOSIZE );

  // 分類器の読み込み(2種類あるから好きな方を)
  std::string cascadeName = "/Users/yusuke/Desktop/data/haarcascades/haarcascade_frontalface_alt.xml";
  //std::string cascadeName = "/Users/yusuke/Desktop/data/lbpcascades/lbpcascade_frontalface.xml";
  cv::CascadeClassifier cascade;
  if(!cascade.load(cascadeName))
  return -1;

  //画像を使う場合はこれ
  /*const char *imagename = "example.jpg";
  img = cv::imread(imagename, 1);
  if(img.empty()) return -1;
  */

  //scaleの値を用いて元画像を縮小、符号なし8ビット整数型，1チャンネル(モノクロ)の画像を格納する配列を作成
  double scale = 4.0;


  // 何かキーが押下されるまで、ループをくり返す
  while( cvWaitKey( 1 ) == -1 )
  {
    cap >> img;

    // グレースケール画像に変換
    cv::cvtColor(img, gray, CV_BGR2GRAY);
    cv::Mat smallImg(cv::saturate_cast<int>(img.rows/scale), cv::saturate_cast<int>(img.cols/scale), CV_8UC1);
    // 処理時間短縮のために画像を縮小
    cv::resize(gray, smallImg, smallImg.size(), 0, 0, cv::INTER_LINEAR);
    cv::equalizeHist( smallImg, smallImg);

    std::vector<cv::Rect> faces;
    /// マルチスケール（顔）探索xo
    // 画像，出力矩形，縮小スケール，最低矩形数，（フラグ），最小矩形
    cascade.detectMultiScale(smallImg, faces, 1.1, 2, CV_HAAR_SCALE_IMAGE, cv::Size(30, 30));
    //cascade.detectMultiScale(smallImg, faces);

    // 結果の描画
    std::vector<cv::Rect>::const_iterator r = faces.begin();
    for(; r != faces.end(); ++r)
    {
      cv::Point center;
      int radius;
      center.x = cv::saturate_cast<int>((r->x + r->width*0.5)*scale);
      center.y = cv::saturate_cast<int>((r->y + r->height*0.5)*scale);
      radius = cv::saturate_cast<int>((r->width + r->height)*0.25*scale);
      cv::circle( img, center, radius, cv::Scalar(80,80,255), 3, 8, 0 );
    }

    //cv::namedWindow("result", CV_WINDOW_AUTOSIZE|CV_WINDOW_FREERATIO);
    cv::imshow( windowName, img );
    //cv::waitKey(0);
  }
}
```

リンクさせるライブラリは
`libopencv_core.2.4.5.dylib`
`libopencv_highgui.2.4.5.dylib`
`libopencv_imgproc.2.4.5.dylib`
`libopencv_objdetect.2.4.5.dylib`
`libstdc++.dylib`

Build Setting→Apple LLVM compiler 4.2 - Language
から、C++ Standard Library を ibstdc++(GNU C++ standard library)
に設定する。
![リンクさせるライブラリ](2013/opencv-face-recognition-01.png)

## 実行結果
![顔認識結果](2013/opencv-face-recognition-02.png)

## 参考
[顔を検出する](http://opencv.jp/cookbook/opencv_img.html#id40)
