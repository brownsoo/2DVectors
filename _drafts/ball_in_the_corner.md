---
layout: page
title: Ball in the Corner
section: The ball
number: 3002
---

# 코너에 있는 공 (Ball in the corner)

모든 장벽은 영원하지 않습니다, 새하얀 눈으로 정상이 덮인 먼 산의 안개속으로 들어가서 외로운 설인들은 차가운 동굴 안에 숨어 있습니다. 가난한 설인은 그들의 사진을 찍거나 인터뷰를 하기 위해 무엇이든 할 준비가 되어있는 탐욕스런 사진가와 기자들로부터 숨어야 합니다. 물론 인터뷰가 이뤄진 후 생활은 설인에게 더 이상 이전 같지 않습니다, 셀 수 없는 관광객들이 그들의 동굴로 들어가고, 소리지르고, 보드카 병을 부술 것입니다.

>이 문단은 벽이 영원히 길지 않다는 의미를 문명의 벽으로 표현하려는 듯 하다. 갑자기 엉뚱한 이야기가 나와서 조금은 혼란스럽다 :)

그래서, 일부 벽들은 특정 지점에서 시작하고 끝납니다. 우린 이미 그 점들을 시작점과 끝점으로 부릅니다. 만약 공이 벽의 옆 이전에 모서리를 때리게 된다면 우리는 이제 그 점들과의 충돌 그리고 새로운 벡터를 찾습니다.

>공이 벽에 부딪힐 때와 모서리에 부딪힐 때를 구분해서 운동을 계산하는 방법을 설명할 것이다.

<div id="flashContent">
    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="300" height="200" id="vect8" align="middle">
        <param name="movie" value="vect8.swf" />
        <param name="quality" value="high" />
        <param name="bgcolor" value="#ffffff" />
        <param name="play" value="true" />
        <param name="loop" value="true" />
        <param name="wmode" value="opaque" />
        <param name="scale" value="noborder" />
        <param name="menu" value="false" />
        <param name="devicefont" value="false" />
        <param name="salign" value="" />
        <param name="allowScriptAccess" value="sameDomain" />
        <!--[if !IE]>-->
        <object type="application/x-shockwave-flash" data="vect8.swf" width="300" height="200">
            <param name="movie" value="vect8.swf" />
            <param name="quality" value="high" />
            <param name="bgcolor" value="#ffffff" />
            <param name="play" value="true" />
            <param name="loop" value="true" />
            <param name="wmode" value="opaque" />
            <param name="scale" value="noborder" />
            <param name="menu" value="false" />
            <param name="devicefont" value="false" />
            <param name="salign" value="" />
            <param name="allowScriptAccess" value="sameDomain" />
        <!--<![endif]-->
            <a href="http://www.adobe.com/go/getflash">
                <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" />
            </a>
        <!--[if !IE]>-->
        </object>
        <!--<![endif]-->
    </object>
</div>

빨간선은 벽입니다. 회색선은 벽의 옆면 또는 모서리 점으로, 벽으로 직진하는 벡터입니다. findIntersection 함수에서 어떤 것이 공과 가장 가까운지 어떤 벡터가 교차 후 공을 움직이도록 사용할 것인지 구합니다.

벽은 v2 이고, 공은  v1 입니다. 먼저 벽의 사작점에서 공의 중심까지 벡터를 구하세요:

{% highlight as3 %}  
var v3 = {};
v3.vx = v1.p1.x - v2.p0.x;
v3.vy = v1.p1.y - v2.p0.y;
{% endhighlight %}

이제 이 새로운 벡터 v3 와 벽의 내적을 구합니다.

{% highlight as3 %}  
var dp = v3.vx * v2.dx + v3.vy * v2.dy;
{% endhighlight %}

만약 내적이 음수이면 공은 시작점에 더 가깝습니다. 그리고 공을 뒤로 움직여놓을 벡터는 벡터 v3 입니다:

{% highlight as3 %}  
if(dp < 0){
  var v = v3;
}
{% endhighlight %}

만약 내적이 0 또는 양수이면 공이 벽의 끝점과 가까운지 확인합니다. 그래서, 벽의 끝점에서 공의 중심까지 벡터를 찾습니다:

{% highlight as3 %}  
else{
  var v4={};
  v4.vx=v1.p1.x-v2.p1.x;
  v4.vy=v1.p1.y-v2.p1.y;
{% endhighlight %}

그리고 첫번째 점처럼, 벽과 새 벡터 v4의 내적을 다시 계산합니다 :

{% highlight as3 %}  
var dp = v4.vx*v2.dx + v4.vy*v2.dy;
{% endhighlight %}

만약 내적이 양수이면 공이 끝점을 먼저 때리고 v4 는 공을 떨어뜨려 놓는데 사용됩니다:

{% highlight as3 %}  
if(dp > 0){
  var v = v4;
}
{% endhighlight %}

그런데 내적이 이때 0 또는 음수라면 벽의 옆면이 공과 가장 가깝습니다. 그러면 시작점에서 공의 중심까지의 벡터(v3)를 벽의 노말에 투영시킵니다. 지난 단계에서 했던 방식대로 벽의 노말 방향으로 공은 뒤로 이동될 것입니다:

{% highlight as3 %}  
else{
  var v=projectVector(v3, v2.lx, v2.ly);
}
{% endhighlight %}

마지막으로 올바른 벡터를 되돌려 줍니다.

{% highlight as3 %}  
return v;
{% endhighlight %}

공을 반동시킨 벡터는 공을 벽에서 떨어뜨리는 데 사용한 벡터와 직교할 것임을 기억하세요. 공이 벽의 옆을 부딪히면 새로운 벡터를 구하기 위해 벽 벡터를 사용할 수 있습니다. 공이 모서리를 부딪히면 벽의 끝점에서 공의 중심점까지의 벡터의 노말이 사용될 것입니다.

> 공을 떨어뜨리는 벡터와 공을 반동시키게 만드는 벡터는 직교한다.

아래 예제에서 벽을 드래그해서 코너를 부딪히는 공을 보도록 하세요.

<div id="flashContent">
    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="300" height="200" id="vect8a" align="middle">
        <param name="movie" value="vect8a.swf" />
        <param name="quality" value="high" />
        <param name="bgcolor" value="#ffffff" />
        <param name="play" value="true" />
        <param name="loop" value="true" />
        <param name="wmode" value="opaque" />
        <param name="scale" value="noborder" />
        <param name="menu" value="false" />
        <param name="devicefont" value="false" />
        <param name="salign" value="" />
        <param name="allowScriptAccess" value="sameDomain" />
        <!--[if !IE]>-->
        <object type="application/x-shockwave-flash" data="vect8a.swf" width="300" height="200">
            <param name="movie" value="vect8a.swf" />
            <param name="quality" value="high" />
            <param name="bgcolor" value="#ffffff" />
            <param name="play" value="true" />
            <param name="loop" value="true" />
            <param name="wmode" value="opaque" />
            <param name="scale" value="noborder" />
            <param name="menu" value="false" />
            <param name="devicefont" value="false" />
            <param name="salign" value="" />
            <param name="allowScriptAccess" value="sameDomain" />
        <!--<![endif]-->
            <a href="http://www.adobe.com/go/getflash">
                <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" />
            </a>
        <!--[if !IE]>-->
        </object>
        <!--<![endif]-->
    </object>
</div>


공의 끝 지점에 대해서만 검사하기 때문에 매우 큰 속도에서는 공을 보지 못한 채 공이 벽을 통과할 가능성이 있습니다. 이런 상황을 피하기 위해서는 공의 속도가 절대 공의 반경보다 크지 않도록 제한해 주어야 합니다.

<p><a href="vect8.fla">1개 벽</a>과 <a href="vect8a.fla">다수 벽</a>에 대한 예제 fla 소스를 다운로드할 수 있습니다.</p>


<br>
<br>
다음 : [Ball vs ball]({{ "/ball_vs_ball/" | prepend: site.baseurl }})


