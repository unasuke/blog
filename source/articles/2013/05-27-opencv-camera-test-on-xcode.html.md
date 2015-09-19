---
title: XcodeのOpenCVでカメラを使ってみる
date: '2013-05-27'
tags:
- howto
- mac
- programming
---

## コード
```cpp
//
//  main.cpp
//  OpenCV-Cameratest
//
//  Created by unasuke on 2013/05/27.
//  Copyright (c) 2013年 unasuke. All rights reserved.
//

#include <iostream>

#ifdef __cplusplus
#include <opencv2/opencv.hpp>
//#include <opencv2/highgui/highgui.hpp>
#endif

int main(int argc, const char * argv[])
{
  // insert code here...
  // カメラからのビデオキャプチャを初期化する
  //macではカメラの順序が最初なのでcvCreateCameraCaptureに渡す引数は0
  CvCapture *videoCapture = cvCreateCameraCapture( 0 );
  if( videoCapture == NULL )
  {
    return -1;
  }

  // ウィンドウを作成する
  char windowName[] = "camera";
  cvNamedWindow( windowName, CV_WINDOW_AUTOSIZE );


  // 何かキーが押下されるまで、ループをくり返す
  while( cvWaitKey( 1 ) == -1 )
  {
    // カメラから1フレーム取得する
    IplImage *image = cvQueryFrame( videoCapture );

    // ウィンドウに画像を表示する
    cvShowImage( windowName, image );
  }


  // ビデオキャプチャを解放する
  cvReleaseCapture( &videoCapture );

  // ウィンドウを破棄する
  cvDestroyWindow( windowName );

  return 0;
}
```

## 諸注意
リンクさせる.dylibは
`libc++.dylib`
`libopencv_core.2.4.5.dylib`
`libopencv_highgui.dylib`
の3つ(画像加工をしないので)
MacのiSight？内蔵カメラは最初に接続されてるのでcvCreateCameraCaptureに渡す引数は0。
C++の設定だけどC++要素全くない。
![カメラに写った](2013/opencv-camera-test.png)
