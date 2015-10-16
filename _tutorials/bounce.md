---
layout: page
title: Bounce
---

# 반동 (Bounce)


충돌이 일어나면, 대상으로부터 튕겨나는 것이 일반적입니다. 머리로 벽을 쳤다면, 그런 일은 분명하게 보이지 않을 수 있습니다(이 방법을 추천하지 않습니다, 당신의 머리만 아플 뿐입니다), 그러나 공과 같은 물체를 보면, 공이 방해물을 뚫고 움직임을 계속하거나 바로 그 앞에 멈추는 일이 얼마나 드문일인지 쉽게 알 수 있습니다.

충돌이 일어난 후에 새로운 운동 벡터를 구하는 방법을 살펴봅시다.

![Alt Bounce on Wall vector](../img/tut06_1.gif)

그림에서 빨간 선은 운동벡터, 녹색은 벽(벡터), 검정은 벽의 노말이며, 파란색은 충돌 후 새로운 운동벡터입니다. 굵은 선들은 벽과 벽의 노말에 대한 운동 벡터의 투영들입니다.

원래의 움직임 벡터와 새로운 움직임 벡터가 어떻게 다른지 매우 분명합니다. 보이지 않나요? 자, 그들의 투영들을 보십시요. 벽에 대한 투영은 정확히 같은데, 벽의 노말에 대한 투영은 반대 방향을 갖습니다. 이로써 우리는 벽에 튕기면서 움직이는 객체를 위한 시스템을 쉽게 만들 수 있습니다.


+ 교차점을 찾는다
+ 운동 벡터의 투영을 구한다.
+ 노말에 대한 투영의 방향을 반전시킨다.
+ 투영들을 더한다.

투영이 무엇이고 어떻게 구하는지 잊어버렸다면, chapter 3 를 살펴보십시요.
v1 은 운동 벡터입니다. v2 는 벽(방해물) 벡터입니다. v2의 왼쪽 노말은 :

{% highlight as3 %}  
v2.lx = v2.vy;
v2.ly = -v2.vx;

{% endhighlight %}


v1 과 v2 의 내적은 :

{% highlight as3 %}  
dp1 = v1.vx*v2.vx + v1.vy*v2.vy;

{% endhighlight %}


v2 에 대한 운동 벡터의 투영은 :

{% highlight as3 %}  
proj1.vx = dp1*v2.dx;
proj1.vy = dp1*v2.dy;

{% endhighlight %}


v1 과 v2 노말 사이의 내적은 :

{% highlight as3 %}  
dp2 = v1.vx*v2.lx + v1.vy*v2.ly;

{% endhighlight %}

v2 노말에 대한 운동 벡터의 투영은(단위벡터를 이용하기 위해 왼쪽 노말을 길이로 나눈 점을 유념하세요) :

{% highlight as3 %}  
proj2.vx = dp*(v2.lx/v2.len);
proj2.vy = dp*(v2.ly/v2.len);
{% endhighlight %}

노말에 대한 투영을 반전시킵니다 :

{% highlight as3 %}  
proj2.vx *= -1;
proj2.vy *= -1;
{% endhighlight %}

투영들을 더해서 새로운 운동벡터 구하기 :

{% highlight as3 %}  
v1.vx = proj1.vx+proj2.vx;
v1.vy = proj1.vy+proj2.vy;
{% endhighlight %}

이 예제에서 점들을 움직여 보고, 운동벡터가 어떻게 변하는지 봅시다 :

<div id="flashContent">
    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="300" height="200" id="vect6" align="middle">
        <param name="movie" value="vect6.swf" />
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
        <object type="application/x-shockwave-flash" data="vect6.swf" width="300" height="200">
            <param name="movie" value="vect6.swf" />
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

<p>소스 <a href="vect6.fla">fla</a>를 다운받을 수 있습니다. </p>

<br>

----

<br>

# 실제 반동과 마찰 (Real bounce and friction)

실생활에서도 마찰과 에너지 감소 때문에 오브젝트가 끝없이 움직일 수 없으며, 같은 방식으로 반동 또한 실제 완전하지 않습니다. 완전한 반동은 충돌 후 운동 벡터의 길이가 충돌 이전의 것과 정확히 같을 때 일어납니다. 반동력, 마찰력 이란 두 개 변수를 각 객체에 적용함으로써 반동에서 에너지 감소를 계산해 낼 수 있습니다.

{% highlight as3 %}  
ob.b = 0.99;
ob.f = 0.99;
{% endhighlight %}

새로운 운동 벡터를 구할 때 이제 우리는 두 물체의 b 와 f 를 각 투영에 곱할 것입니다. 반동력은 벽의 노말에 대한 투영에 영향을 주며, 마찰력은 벽 벡터의 투영에 영향을 줍니다.

{% highlight as3 %}  
v1.vx = v1.f*v2.f*proj1.vx + v1.b*v2.b*proj2.vx;
v1.vy = v1.f*v2.f*proj1.vy + v1.b*v2.b*proj2.vy;
{% endhighlight %}

물체의 b 와 f 가 1 이라면 어떨까? 그러면 완전한 반동이 일어납니다 - 충돌에서 아무것도 잃지 않고 운동은 같은 세기로 계속 유지됩니다. 예로 움직이는 물체나 벽이 반동력이 없다면(b=0) 충돌 후 운동 벡터는 벽과 평행하고 물체는 벽에 붙게 됩니다. 늪 또는 풀로 날아가는 공을 상상해 보십시요.

물론 1 보다 큰 반동도 갖을 수 있는데, 이런 경우 충돌은 운동의 속도를 높이게 될 것입니다. 이에 대한 좋은 예시로 핀볼의 범퍼를 들 수 있습니다. 볼이 범퍼와 부딪히면 볼의 속도를 증가 시킵니다.

다음 예제에는 중력과 많은 벽이 존재하는 스테이지 위에 움직이는 점이 있습니다. 벽의 끝점을 움직여 볼 수 있습니다.

<div id="flashContent">
    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="300" height="200" id="vect6a" align="middle">
        <param name="movie" value="vect6a.swf" />
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
        <object type="application/x-shockwave-flash" data="vect6a.swf" width="300" height="200">
            <param name="movie" value="vect6a.swf" />
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

움직이는 점은 모든 벽을 통과하여 계속 반복되며, 마지막 체크 이후 지난 시간동안 다른 것들과 부딪히는지 검사합니다. 점이 여러 벽에 충돌 할 경우, 그러면 가장 가까운 교차점있는 벽이 선택됩니다. 그런 다음, 객체의 끝점을 교차점으로 놓고 새로운 운동 벡터를 계산합니다. 그리고 끝점은 그 원래의 시작점에서 교차점까지의 값을 빼므로써 교차점에서 새로운 벡터의 방향으로 이동합니다.

>이부분은 영어해석을 잘못한 것인지 원문에 오류가 있는 건지 이해하기 어렵다. 시작점이 아니라 원래의 끝점에서 교차점까지의 값을 더하거나 빼야 한다. 그림에서 운동벡터(빨강)의 원래 끝점을 E 라고 본다면, p1은 이렇다.
>
>`p1 = {x: ip.x + (E.x - ip.x), y: ip.y - (E.y - ip.y)}`

![Alt Real Bounce on Wall vector](../img/tut06_2.gif)

여러분은 적어도 두 가지 방법으로 시스템을 더 향상시킬 수 있습니다 :

1. 물체가 지난 타임에 스크린 상 시작점 p0 위치에 그려지고, 다음 타임에 끝점 p1 에 그려지기 때문에 사람의 눈은 물체가 벽 근처 교차점 ip 에 절대로 접근할 수 없음을 볼 수 없습니다. 아마도 p0 에서 p1으로 바로 이동하는 물체를 보게 될 것입니다. 이런 상황이 틀렸음에도, 때때로 물체가 교차지점에 놓이게 되고 전체화면이 업데이트 되면서 눈으로 물체가 벽을 치는 것을 볼 수 있습니다.

2. 물체가 처음 벽 이후 다른 벽에 부딪힐 가능성이 있습니다. 현재로써 가장 가까운 벽에서 반동합니다. 확신하기 위해, 새로운 벡터가 구해진 후 모든 벽과 충돌 확인을 시작해야 할 것입니다. 그런 다음 교차점에서 p1 으로 생긴 새로운 벡터(그림에서 파랑)에 대해서만 확인해야 합니다.

<p>소스 <a href="vect6a.fla">fla</a>를 다운받을 수 있습니다. </p>


<br>
<br>
다음 : [Ball vs line]({{ "/ball_vs_line/" | prepend: site.baseurl }})



