---
title: XcodeとOpenCVで特徴点検出
date: '2013-07-31'
tags:
- howto
- mac
- programming
---

## ソースコード
```cpp
#include <iostream>

#ifdef __cplusplus
#include <opencv2/opencv.hpp>
#include <opencv2/nonfree/nonfree.hpp>
#endif

/*****************************************************
 参考URL
 http://opencv.jp/opencv2-x-samples/surf_extraction
 *****************************************************/

int main(int argc, const char * argv[])
{
  /*****カメラからのビデオキャプチャを初期化する*****/
  //デフォルトカメラをオープン
  cv::VideoCapture cap(0);
  
  //カメラがオープンできない場合終了
  if( !cap.isOpened() )
    return -1;

  //キャプチャ画像を1280*720で取得
  cap.set( CV_CAP_PROP_FRAME_HEIGHT, 720 );
  cap.set( CV_CAP_PROP_FRAME_WIDTH, 1280 );
  

  /*****ウィンドウを作成する*****/
  char windowName[] = "SURF-TEST";
  cv::namedWindow( windowName, CV_WINDOW_AUTOSIZE );
  
  
  //何かキーが押下されるまで、ループをくり返す
  while( cvWaitKey( 1 ) == -1 )
  {
    cv::Mat gray , frame;
    cap >> frame;   //カメラからキャプチャ
    cv::cvtColor( frame , gray , CV_RGB2GRAY ); //キャプチャ画像を処理用にグレースケール変換

    /*****SURFクラスの初期化*****/
    cv::SURF calc_surf = cv::SURF(500,4,2,true);    //拡張ディスクリプタを用い128次元で取得

    /*****SURF特徴をグレースケール画像から抽出*****/
    std::vector<cv::KeyPoint> kp_vec;   //C++の可変長配列(cv::Keypoint型)のベクトル配列を宣言
    std::vector<float> desc_vec;    //C++の可変長配列(float型)のベクトル配列を宣言
    calc_surf( gray , cv::Mat(), kp_vec, desc_vec); //SURFディスクリプタ計算

    /*****抽出したSURF特徴の位置とスケールを描画*****/
    std::cout << "Image Keypoints: " << kp_vec.size() << std::endl; //標準出力に出力

#if 1
    //この辺りちょっとよくわからない
    //イテレータを使って？？？
    std::vector<cv::KeyPoint>::iterator it = kp_vec.begin(), it_end = kp_vec.end();
    for( ; it!=it_end; it++)
    {
      //円を描画
      cv::circle( frame ,                             /*描画先画像*/
                 cv::Point(it->pt.x, it->pt.y) ,      /*中心座標*/
                 cv::saturate_cast<int>(it->size*0.25) ,  /*半径*/
                 cvScalar(255,255,0)                      /*色*/
                 );
    }

#else
    for( int i = 0; i < kp_vec.size(); i++ )
    {
      KeyPoint* point = &(kp_vec[i]);
      Point center;  // Key Point's Center
      int radius;      // Radius of Key Point
      center.x = cvRound(point->pt.x);
      center.y = cvRound(point->pt.y);
      radius = cvRound(point->size*0.25);
      circle(colorImage, center, radius, Scalar(255,255,0), 1, 8, 0);
    }

#endif


    /*****適応的閾値処理による二値化*****/
    /*
     Mat adaptive_img;
    //adaptiveThreshold(gray_img, adaptive_img, 255, ADAPTIVE_THRESH_GAUSSIAN_C, THRESH_BINARY, 7, 8);
    adaptiveThreshold(gray, adaptive_img, 255, ADAPTIVE_THRESH_GAUSSIAN_C, THRESH_BINARY, 7, 6);
     */

    //変換画像をウィンドウに表示
    imshow( windowName, frame );

  }
  
  // ウィンドウを破棄する
  cvDestroyWindow( windowName );
  
  return 0;
}
```

## 実行結果
![特徴点抽出結果](opencv-feature-point-detection.png)
