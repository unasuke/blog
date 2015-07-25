---
title: OpenCVで顔認識
date: '2013-06-23'
tags:
- howto
- mac
- programming
---

もしやMacPortsからOpenCVを導入したのは間違いだったのではと感じた。

<h2>必要なもの</h2>

<ul>
<li>カメラもしくは人の顔が写った画像</li>
<li>顔認識に必要なデータ(後述)</li>
<li>イケメン(後述)</li>
</ul>

<h2>顔認識に必要なデータとは</h2>

OpenCVのインストールフォルダにdataフォルダがあって、その中のhaarcascadesフォルダに顔認識に必要なファイルがあるが、MacPortsからOpenCVをインストールするとそんなのはない。
Githubで落としてくるとかして手に入れなければならない。<a href="https://github.com/Itseez/opencv" title="Itseez/opencv · GitHub" target="_blank">Itseez/opencv・GitHub</a>

<h2>イケメンとは</h2>

顔認識するときカメラ起動するとキモい顔が映って死ぬ。

<h2>ソースコード</h2>

<pre class="lang:c++ decode:true " >
#include &lt;iostream&gt;
#ifdef __cplusplus
#include &lt;opencv2/opencv.hpp&gt;
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
cap &gt;&gt; img;
    
// グレースケール画像に変換
cv::cvtColor(img, gray, CV_BGR2GRAY);
cv::Mat smallImg(cv::saturate_cast&lt;int&gt;(img.rows/scale), cv::saturate_cast&lt;int&gt;(img.cols/scale), CV_8UC1);
// 処理時間短縮のために画像を縮小
cv::resize(gray, smallImg, smallImg.size(), 0, 0, cv::INTER_LINEAR);
cv::equalizeHist( smallImg, smallImg);

std::vector&lt;cv::Rect&gt; faces;
/// マルチスケール（顔）探索xo
// 画像，出力矩形，縮小スケール，最低矩形数，（フラグ），最小矩形
cascade.detectMultiScale(smallImg, faces, 1.1, 2, CV_HAAR_SCALE_IMAGE, cv::Size(30, 30));
//cascade.detectMultiScale(smallImg, faces);

// 結果の描画
std::vector&lt;cv::Rect&gt;::const_iterator r = faces.begin();
for(; r != faces.end(); ++r)
{
    cv::Point center;
    int radius;
    center.x = cv::saturate_cast&lt;int&gt;((r-&gt;x + r-&gt;width*0.5)*scale);
    center.y = cv::saturate_cast&lt;int&gt;((r-&gt;y + r-&gt;height*0.5)*scale);
    radius = cv::saturate_cast&lt;int&gt;((r-&gt;width + r-&gt;height)*0.25*scale);
    cv::circle( img, center, radius, cv::Scalar(80,80,255), 3, 8, 0 );
}
    
//cv::namedWindow("result", CV_WINDOW_AUTOSIZE|CV_WINDOW_FREERATIO);
cv::imshow( windowName, img );
//cv::waitKey(0);
    }
}</pre>

リンクさせるライブラリは
<code>
libopencv_core.2.4.5.dylib
libopencv_highgui.2.4.5.dylib
libopencv_imgproc.2.4.5.dylib
libopencv_objdetect.2.4.5.dylib
libstdc++.dylib
</code>

Build Setting→Apple LLVM compiler 4.2 - Language
から、C++ Standard Library を ibstdc++(GNU C++ standard library)
に設定する。
<a href="http://unasuke.com/wp/wp-content/uploads/2013/06/ppp.png"><img src="http://unasuke.com/wp/wp-content/uploads/2013/06/ppp.png" alt="ppp" width="762" height="548" class="alignnone size-full wp-image-157" /></a>

<h2>実行結果</h2>

<a href="http://unasuke.com/wp/wp-content/uploads/2013/06/face.png"><img src="http://unasuke.com/wp/wp-content/uploads/2013/06/face.png" alt="face" width="704" height="758" class="alignnone size-full wp-image-153" /></a>

<h2>参考</h2>

<a href="http://opencv.jp/cookbook/opencv_img.html#id40">顔を検出する</a>
