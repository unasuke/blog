---
title: XcodeでOpenCV始めると大変
date: '2013-05-26'
tags:
- howto
- mac
- programming
---

<a href="http://hamal0005975.blog.fc2.com/blog-entry-21.html" title="破魔矢の浜や OpenCV導入のススメ" target="_blank">破魔矢の浜や OpenCV導入のススメ</a>

じゃあこれXcodeでやるとどうなのって。
※画像はクリックで大きくなり、非常に重いかもしれない。

<h2>OpenCVのインストール</h2>

<a href="http://unasuke.com/howto/2013/install-git-using-macports/" title="Macで始めるGUIを使わないやさしくないGit" target="_blank">前回記事</a>でMacPortsを使ってGitをインストールした。その流れにのり、MacPortsでOpenCVをインストールする。

<pre class="lang:sh highlight:0 decode:true " >$ sudo port selfupdate
$ sudo port install opencv</pre>

長い時間掛かるかもしれないのでこれからの苦難を想像して身構えておくのが吉。

<h2>Xcodeの準備</h2>

まずはプロジェクトの作成から始める。
<a href="http://unasuke.com/wp/wp-content/uploads/2013/05/458c744e4ecf156718b6f7a5063d7d8d.png"><img src="http://unasuke.com/wp/wp-content/uploads/2013/05/458c744e4ecf156718b6f7a5063d7d8d-300x195.png" alt="プロジェクトの作成" width="300" height="195" class="alignnone size-medium wp-image-81" /></a>
"Create a new Xcode project"を選択し……
<a href="http://unasuke.com/wp/wp-content/uploads/2013/05/a6cf18fbe3d2768cacb89d97d1c7cab1.png"><img src="http://unasuke.com/wp/wp-content/uploads/2013/05/a6cf18fbe3d2768cacb89d97d1c7cab1-300x215.png" alt="プロジェクトの選択" width="300" height="215" class="alignnone size-medium wp-image-83" /></a>
"OS X"の"Application"の"Command Line Tool"を選択し……
<a href="http://unasuke.com/wp/wp-content/uploads/2013/05/62c479e02b5c323aeca5e494663a2737.png"><img src="http://unasuke.com/wp/wp-content/uploads/2013/05/62c479e02b5c323aeca5e494663a2737-300x202.png" alt="プロジェクトの作成2" width="300" height="202" class="alignnone size-medium wp-image-82" /></a>
各項目を記入し……
こんな画面になるかと思うので、囲ったところをクリックして下準備。
<a href="http://unasuke.com/wp/wp-content/uploads/2013/05/0b0941e6d9ce98fbf861fdfe8c62e46f.png"><img src="http://unasuke.com/wp/wp-content/uploads/2013/05/0b0941e6d9ce98fbf861fdfe8c62e46f-300x181.png" alt="プロジェクトを作成" width="300" height="181" class="alignnone size-medium wp-image-86" /></a>

<h2>下準備</h2>

まずはHeader Search PathとLiberty Search Pathを設定する。それぞれ　MacPortsからインストールした場合は、Header Search Pathが
<code>/opt/local/include</code>
Liberty Search Pathが
<code>/opt/local/include
/opt/local/lib</code>
と、それぞれnon-recursiveで設定する。recursiveにすると大量のエラーが出る。Liberty Search Pathは設定してない例もいくつか見つけたので不要かもしれない。
<a href="http://unasuke.com/wp/wp-content/uploads/2013/05/5c25372fb38e904198c8c19debcb9863.png"><img src="http://unasuke.com/wp/wp-content/uploads/2013/05/5c25372fb38e904198c8c19debcb9863-300x242.png" alt="Search Pathの設定" width="300" height="242" class="alignnone size-medium wp-image-88" /></a>
<a href="http://unasuke.com/wp/wp-content/uploads/2013/05/6afced7406f987489313970502b3982e.png"><img src="http://unasuke.com/wp/wp-content/uploads/2013/05/6afced7406f987489313970502b3982e-300x275.png" alt="Seach Path設定完了" width="300" height="275" class="alignnone size-medium wp-image-89" /></a>

次にLink Binary With Librariesを設定する。今回はウィンドウの表示、ガウシアンフィルタを利用するので、以下の4つのLibraryをリンクさせる。
<code>
libc++.dylib
libopencv_core.2.4.5.dylib
libopencv_highgui.dylib
libopencv_imgproc.dylib
</code>
OpenCVの.dylibは(MacPortsからのインストールなら)<code>/opt/local/lib</code>にあるので検索すると見つけやすい。追加は"Add Other"から行う。
<a href="http://unasuke.com/wp/wp-content/uploads/2013/05/3461dc8dd0432b34927688993943f985.png"><img src="http://unasuke.com/wp/wp-content/uploads/2013/05/3461dc8dd0432b34927688993943f985-300x274.png" alt="libc++.dylibのリンク" width="300" height="274" class="alignnone size-medium wp-image-91" /></a>
<a href="http://unasuke.com/wp/wp-content/uploads/2013/05/40ba8824090043094c4f5f43bbac9a18.png"><img src="http://unasuke.com/wp/wp-content/uploads/2013/05/40ba8824090043094c4f5f43bbac9a18-300x205.png" alt="libopencv_*.dylibのリンク" width="300" height="205" class="alignnone size-medium wp-image-92" /></a>
これで下準備は終わり。

<h2>テストプログラムを打ち込む</h2>

今回は<a href="http://hamal0005975.blog.fc2.com/blog-entry-21.html" title="破魔矢の浜や OpenCV導入のススメ" target="_blank">破魔矢の浜や OpenCV導入のススメ</a>に倣いある画像をガウシアンフィルタを適用しぼかす。

<pre class="lang:c++ decode:true " title="main.cpp" >//
//  main.cpp
//  OpenCV-test
//
//  Created by unasuke on 2013/05/26.
//  Copyright (c) 2013年 unasuke. All rights reserved.
//

#include &lt;iostream&gt;

#ifdef __cplusplus
#include &lt;opencv2/opencv.hpp&gt;
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
    IplImage* after_img = cvCreateImage(cvGetSize(before_img), before_img-&gt;depth, before_img-&gt;nChannels);
    
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
    cvReleaseImage(&amp;before_img);
    cvReleaseImage(&amp;after_img);
    
    return 0;
}</pre>

で、実行するとこうなる。
<a href="http://unasuke.com/wp/wp-content/uploads/2013/05/59fd5d43f42a331d92a9551e2b6a1b72.png"><img src="http://unasuke.com/wp/wp-content/uploads/2013/05/59fd5d43f42a331d92a9551e2b6a1b72-300x187.png" alt="サンプルコードの実行結果" width="300" height="187" class="alignnone size-medium wp-image-94" /></a>
疲れた。
