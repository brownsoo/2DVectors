---
layout: page
title: Ball vs Arc
---

# 공 vs 호(Ball vs arc)

이제 움직이는 공을 호 형태와 다뤄야 한다면 어떤 일이 벌어지는지 보도록 합시다. 호는 원의 부분이고, 원이 전체 360도인데, 호는 360 도를 미치지 못합니다. 공 대 공의 충돌로 우리는 오직 1 개의 가능한 충돌 점이 있었습니다. 공 대 아크에서는 하나만 있지 않고, 2 개, 4개의 가능한 충돌 점이 있습니다.

![Alt 공과 호가 충돌하는 경우의 수](../img/tut12_1.gif)

왼쪽편에 움직이는 공은 바깥 측면에서 호를 부딪히고, 가운데는 공이 안쪽 측면에서 호를 부딪히고, 오른쪽은 공이 호의 끝 점을 때리고 있습니다(호는 2개의 끝점이 있고 공은 둘다 부딪힐 수 있습니다).

원을 정의하기 위해서 우리는 그 중심점의 좌표와 반경이 필요합니다. 호를 정의하기 위해서는 중심점과 반경도 필요하지만 시작점의 각과 끝점의 각도 또한 필요합니다.

![Alt 호의 정의](../img/tut12_2.gif)

호를 정의한 예시

{% highlight as3 %}  
arc={p0:{x:170, y:90}, r:30, ang1:135, ang2:315};
{% endhighlight %}

호의 중심은 x=170, y=90 일 것이고, 반경은 30, 시작점의 각은 135 도 그리고 끝점의 각은 315 입니다. 위 정보를 알고 있으면, 시작점과 끝점의 좌표를 구할 수 있습니다:

{% highlight as3 %}  
ang1rad=ang1*Math.PI/180;
ang2rad=ang2*Math.PI/180;
v1.p0={
	x:p0.x+r*Math.cos(ang1rad),
	y:p0.y+r*Math.sin(ang1rad)
};
v1.p1={
	x:p0.x+r*Math.cos(ang2rad),
	y:p0.y+r*Math.sin(ang2rad)
};
{% endhighlight %}

벡터 v1 은 호의 시작과 끝 점 사이에 있습니다.


<br>

-----

<br>

# 충돌 (Collisions)

우리는 먼저 단계 10 에서 다룬 움직이는 공 대 공의 충돌을 이용해 바깥 측면에서 공이 호를 부딪히는지 검사합니다. 충돌이 일어나게 되면, 공이 원의 빈 부분이 아닌 호가 존재하는 부분에서 호를 부딪히는지도 또한 검사해야 합니다.

![Alt 공과 호의 충돌](../img/tut12_3.gif)

우리는 공과 호가 붙어있는 점 p3를 찾아야 합니다. 이미 충돌이 일어날 때 움직이는 공의 중심 좌표를 알고 있기 때문에 충돌하는 순간 호의 중심에서 원의 중심까지 벡터 v2 를 그릴 수 있습니다:

{% highlight as3 %}  
v2 = {p0:arc.p0, p1:ball.p3};
{% endhighlight %}

점 p3 는 이 벡터 상에 있고 호의 중심으로부터 호의 반경과 같은 떨어진 거리에 있습니다(또한 공의 중심에서 공의 반경 거리만큼 떨어져 있습니다).

{% highlight as3 %}  
p3 = {
	x : arc.p0.x+v2.dx*arc.r,
	y : arc.p0.y+v2.dy*arc.r
};
{% endhighlight %}

다음으로 호의 시작점에서 점 p3 까지 벡터를 그립니다:

{% highlight as3 %}  
v3 = {p0:v1.p0, p1:p3};
{% endhighlight %}

점 p3 는 v3 와 v1 의 왼쪽 노말의 내적이 0 보다 클 때 호 선상에 있습니다 :

{% highlight as3 %}  
if(dotP(v3, v1LeftNormal) >= 0){
  //collision
}else{
  //not on the arc
}
{% endhighlight %}

만약 충돌이 검출되고 공이 외부에서 호를 부딪히면 다른 3 개의 충돌 검사를 생략할 수 있습니다. 하지만 충돌 점이 호의 밖에 있었다면 우리는 공이 안쪽에서 호를 때리는지 호의 끝점을 때리는지 여부를 점검할 필요가 있습니다.

끝 점들에 대해서, 끝점의 좌표에 반경이 0 인 보이지 않는 공이 있다고 상상하고, 움직이는 공 대 공 시스템과 같은 것을 사용할 수 있습니다. 우리가 사용한 공 대 전체 호에 대한 경우 :

{% highlight as3 %}  
ballvsBall(ball, arc.p0, arc.r);
{% endhighlight %}

그러면 다음과 같이 충돌을 구할 수 있습니다 :

{% highlight as3 %}  
ballvsBall(ball, v1.p0, 0);
ballvsBall(ball, v1.p1, 0);
{% endhighlight %}

호 안에서 공의 충돌에 대해서는 약간 수정한 외부 충돌 시스템을 사용합니다. 우리가 사용 외부 충돌인 경우 :

{% highlight as3 %}  
r = arc.r+ball.r;
moveBack = Math.sqrt(r*r-vn.len*vn.len);
ball.p3 = {
	x : ball.p2.x-moveBack*v.dx,
	y : ball.p2.y-moveBack*v.dy
};
{% endhighlight %}


우리가 사용한 내부 충돌인 경우 :

{% highlight as3 %}  
r = arc.r - ball.r;
moveBack = Math.sqrt(r*r-vn.len*vn.len);
ball.p3 = {
	x : ball.p2.x+moveBack*v.dx,
	y : ball.p2.y+moveBack*v.dy
};
{% endhighlight %}


공이 점 보다 호에 더 충돌할 가능이 있기에 한번 모든 3 개 충돌이 발견된 후에는 공이 충돌로 가는 가장 짧은 길을 선택할 필요가 있습니다.

그리고 다음 공과 호의 예제에서 즐겨봅시다 :

<div id="flashContent">
    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="300" height="200" id="vect12" align="middle">
        <param name="movie" value="vect12.swf" />
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
        <object type="application/x-shockwave-flash" data="vect12.swf" width="300" height="200">
            <param name="movie" value="vect12.swf" />
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

<p>소스 <a href="vect12.fla">fla</a>를 다운받을 수 있습니다. </p>


