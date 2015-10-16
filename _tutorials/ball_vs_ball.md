---
layout: page
title: Ball vs Ball
---

# 공 vs 공 (Ball vs ball)

우리는 지금까지 충분히 벽을 괴롭혔고, 벽은 공을 잘 반동시키고 있으며 아담한 휴식을 받을 만합니다, 우리가 두 공의 충돌을 다루는 동안 따뜻한 커피나 차(우유, 무설탕)을 조금 즐기고 싶을 것입니다. 주된 공은 계속 움직이고 있으며 그래서 운동벡터를 갖고 있지만, 다른 공은 움직이지 않습니다. 아마도 그 공은 바닥에 버젓이 놓여있거나, 아마도 천장에 붙어 있거나 너무 작고 아둔하여 아직 운동을 배우지 못했을 것입니다.

먼저 공들이 충돌하는지 알 수 있는 방법을 알아봅시다. 그런 다음 충돌 이후 움직이는 공으로 무엇을 할지 생각해봅시다.

![Alt 공과 공의 충돌](../img/tut09_1.gif)

그림에서 공1 (빨강)은 공2 (파랑)과 충돌합니다. 두 공의 중심점들 사이의 벡터는 v (녹색)입니다.  벡터 v의 길이가 두 공의 반경을 더한 것보다 작을 때만, 충돌이 일어납니다. 우리는 움직이는 공을 다른 공 바로 옆으로 놓아야 하고 다음 양만큼 v 의 방향으로 공1을 이동시키면서 그렇게 할 수 있습니다 :

{% highlight as3 %}  
pen = v.len-(b1.r+b2.r)
{% endhighlight %}

이제 공들이 훌륭하고 완벽하게 서로의 옆에 놓여졌으니 운동 벡터를 어떻게 변경해야 할지 알아내야 합니다. 보이지 않는 벽이 두 공 사이에 있다고 상상해보십시요. 그러면 그 벽의 방향은 정확히 공들의 중심점 사이의 벡터 노멀과 같습니다.

![Alt 공과 공의 충돌 후 벡터 변화](../img/tut09_2.gif)

그림에서 검은 벡터는 벡터 v 의 노멀이며 공 1의 운동벡터는 공이 벽에 반동하는 것처럼 계산되어 집니다.

제가 여러 개의 고정된 공들이 있는 스테이지를 한 개 공이 돌아다니는 예제를 하나 만들었습니다.


<div id="flashContent">
    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="300" height="200" id="vect9" align="middle">
        <param name="movie" value="vect9.swf" />
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
        <object type="application/x-shockwave-flash" data="vect9.swf" width="300" height="200">
            <param name="movie" value="vect9.swf" />
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


다른 공들을 드래그해 보세요.

<p>소스 <a href="vect9.fla">fla</a>를 다운받을 수 있습니다. </p>

<br>

-----

<br>

# 안에 가두기 (Keep it in)

여러분은 아마 다른 (분명히 더 큰) 공 안에 움직이는 공을 가두기도 원할 것입니다.

<div id="flashContent">
    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="300" height="200" id="vect9a" align="middle">
        <param name="movie" value="vect9a.swf" />
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
        <object type="application/x-shockwave-flash" data="vect9a.swf" width="300" height="200">
            <param name="movie" value="vect9a.swf" />
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

이 경우 큰 공은 b2 이고 작은 움직이는 공은 b1 입니다. 다음 조건에서 작은 공은 밖으로 움직입니다.

{% highlight as3 %}  
b2.r < (b1.r+v.len)
{% endhighlight %}

그런 일이 벌어진다면 우리는 공을 다음의 양만큼 뒤로 물려놓아야 합니다.

{% highlight as3 %}  
var pen = b2.r - (b1.r + v.len)
{% endhighlight %}

그리고, 반동에 사용되어질, 벡터 v 의 노말의 방향을 반전시키는 것을 잊지 말아야 합니다 :

{% highlight as3 %}  
var vbounce = {dx:-v.dy, dy:v.dx, lx:-v.dx, ly:-v.dy};
{% endhighlight %}

<p>여기 볼 안에 볼을 가두는 <a href="vect9a.fla">fla</a> 소스를 다운로드 할 수 있습니다. 이것은 Flash 8 버전 fla 임을 알아두세요.</p>
	


<br>
<br>
다음 : [Moving ball vs ball]({{ "/moving_ball_vs_ball/" | prepend: site.baseurl }})


