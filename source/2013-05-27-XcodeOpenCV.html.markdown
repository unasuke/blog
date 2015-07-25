---
title: XcodeのOpenCVでカメラを使ってみる
date: '2013-05-27'
tags:
- howto
- mac
- programming
---

<a href="http://hamal0005975.blog.fc2.com/blog-entry-22.html" title="OpenCV Webカメラの画像を画面上に" target="_blank">破魔矢の浜や OpenCV Webカメラの画像を画面上に</a>のXcode版。

<h2>コード</h2>
[sourcecode lang="c"]
//
//  main.cpp
//  OpenCV-Cameratest
//
//  Created by unasuke on 2013/05/27.
//  Copyright (c) 2013年 unasuke. All rights reserved.
//  thanks to hama.
//

#include &lt;iostream&gt;

#ifdef __cplusplus
#include &lt;opencv2/opencv.hpp&gt;
//#include &lt;opencv2/highgui/highgui.hpp&gt;
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
    char windowName[] = &quot;camera&quot;;
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
    cvReleaseCapture( &amp;videoCapture );
    
    // ウィンドウを破棄する
    cvDestroyWindow( windowName );
    
    return 0;
}
[/sourcecode]

<h2>諸注意</h2>
リンクさせる.dylibは
<code>
libc++.dylib
libopencv_core.2.4.5.dylib
libopencv_highgui.dylib
</code>
の3つ(画像加工をしないので)
MacのiSight？内蔵カメラは最初に接続されてるのでcvCreateCameraCaptureに渡す引数は0。
C++の設定だけどC++要素全くない。
<a href="http://unasuke.com/wp/wp-content/uploads/2013/05/51e6d550dbb2e94d13d9917001bc16e6.png"><img src="http://unasuke.com/wp/wp-content/uploads/2013/05/51e6d550dbb2e94d13d9917001bc16e6-300x187.png" alt="カメラに写った" width="300" height="187" class="alignnone size-medium wp-image-106" /></a>
