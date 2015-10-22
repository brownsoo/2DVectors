---
layout: page
title: Move, Accelerate
section: Using vectors
number: 2001
---

# 벡터로 움직이기 (Moving with Vector)

기본 단계를 넘기고, 이제 포인트가 무엇인지, 벡터가 무엇인지, 어떻게 벡터들의 다른 속성들을 계산해야 하는지 알게 되었습니다. 
그리고 실제 작업에서 벡터를 사용하면서 손이 바빠지기를 꽤나 기다리셨을 것입니다. 물체를 움직이기 위해 어떻게 벡터를 사용하는지 보도록 합시다.

이 예제에서 빨간 점이 우리의 오브젝트입니다. 예제 블럭을 선택하고, 방향키를 이용해 운동 벡터의 vx, vy 요소를 바꿀 수 있습니다.

<canvas data-processing-sources="../data/moving_with_vector.pde"></canvas>
<small>(소스파일 [pde](../data/moving_with_vector.pde)를 다운받을 수 있습니다.)</small>

먼저 오브젝트를 선언합니다. 참고로 오브젝트는 벡터의 속성을 갖고 있습니다.

{% highlight as3 %}  
myOb = {};
myOb.p0 = {x:100, y:150};
myOb.vx = 3;
myOb.vy = 1;
{% endhighlight %}

이 벡터의 시작점은 x=100, y=150 이고, 운동요소는 vx=3, vy=1 의 값을 가지고 있습니다. 오브젝트의 새로운 위치는 벡터의 끝점(p1)이며, 이는 예제 코드의 undateVector 함수에서 계산됩니다. 만약에 p1의 값을 어떻게 아는지 기억나지 않는다면, Point. Vector 페이지를 살펴보기 바랍니다. 
오브젝트를 p1 위치에 놓은 다음, drawAll 함수에서 다음 계산을 위해 끝점 p1을 시작점으로 지정할 것입니다.

방향키를 누를 때마다, vx 또는 vy 속성이 증가하거나 줄어듭니다. keyPressed 함수에서 이를 다룹니다. 주요 함수 runMe 는 매 프레임마다 실행되며, 새로운 위치를 알아내고 오브젝트를 놓기위해  updateVector 와 drawAll 함수들을 호출합니다. 예제에서는 오브젝트가 화면 영역 밖으로 나갔는지도 검사하고, 정말 나갔다면, 오브젝트를 반대편으로 옮겨놓습니다.

<br>

----

<br>

# 프레임 또는 시간 (Frame or Time)

updateVector 함수를 다시 살펴보면, 새로운 좌표로 끝점 p1을 찾는 방법을 볼 수 있습니다 :

{% highlight as3 %}  
var thisTime = millis();
var time = (thisTime-v.lastTime)/1000f*scale;
v.p1 = new Point();
v.p1.x = v.p0.x+v.vx*time;
v.p1.y = v.p0.y+v.vy*time;
v.lastTime = thisTime;
{% endhighlight %}

플래시는 프레임 기반 프로그램입니다. 무비 프레임 레이트에 정해 놓은 만큼 모든 애니메이션과 액션스크립트 코드를 1초에 여러번 실행하려고 합니다. 모든 계산을 다루기 위해 enterFrame clipEvent를 사용하는 것이 보통인데, 이는 정말 좋은 방법은 아닙니다. 여러분이 매 프레임마다 오브젝트의 x 좌표를 1 씩 증가하도록 코드를 작성했다고 가정해 봅시다. 만약 프레임 레이트를 20으로 설정하였다면, 코드가 초당 20번씩 실행되어 오브젝트가 초당 20픽셀을 이동하는 결과를 낳습니다.

또는 여러분이 알고 있는 일이 벌어질 것입니다. 실제 플래시는 정확하게 똑같은 프레임 레이트로 작동하지 않습니다. 프레임 레이트는 단지 최대값이고 플래시 플레이어가 그 값에 맞추려고 노력하지만, 보통 실패합니다. 브라우저에 보여지는 플래시 무비들은 고생스럽습니다. 브라우저는 어느정도 CPU 자원을 필요로 하고, 어떤 컴퓨터들은 상대적을 느리며, 사람들은 다른 프로그램들도 돌리고 있을 것이기 때문입니다. 이 모든 것들은 프레임 레이트를 보통 20-25% 떨어뜨리는 요인이 됩니다.

"그게 어떻다는 거지?" 궁금할 것입니다. 여전히 작동되고, 좌표들도 계산되어 지고, 무비클립들 역시 움직입니다. 그래요. 그러나 여러분은 더이상 게임을 지배할 수 없습니다. 일정시간 후에 무비클립이 어디에 있는지, 정확히 어떤 속도로 움직이는지 여러분은 결코 확신할 수 없습니다. 만약 플래시 게임에 대한 사람들의 반응을 살펴보고자 할 때, 프레임 레이트가 50% 떨어져 낮은 프레임 속도에서 재생한 사람들은 (거의) 올바른 프레임 속도에서 재생한 사람들보다 큰 잇점을 갖습니다. 이것은 플래시 게임에서 일반적인 부정 방법으로, 여러분은 쉽게 무비를 느리게 할 수 있어서 어떤 식으로든 게임에서 쉽게 이길 수 있습니다.

이 과정의 해결책은 계산을 프레임 수를 기준으로 하지 말고, 실제 시간을 기준으로 하는 것입니다. 프레임 기반 게임에서 속도 vx=3을 선언하는 것은 플래시 플레이어가 무비를 실행할 수 있는 기회를 얻는 매시간마다 무비클립이  3 픽셀씩 움직일 것임을 의미합니다. 시간 기반 게임에서 vx=3을 선언하는 것은 무비클립이 매초마다 3픽셀씩 움직일 것임을 의미합니다. 시간 기반 게임에서 프레임 레이트가 떨어지는 것은 알 수 없는 결과를 만들지 않습니다. 1초 뒤에, 10초 뒤에 또는 1시간 뒤에 무비클립이 어디에 있을지 정확히 알 수 있습니다. 시간 기반 무비에서 낮은 프레임 레이트는 움직임의 부드러움에 영향을 줍니다. 오브젝트는 매초마다 적은 횟수로 스테이지에 그려지고, 움직임은 '건너뛰듯이' 보일 것입니다. 그렇지만 오브젝트는 매번 그려지고, 또한 매우 정확한 위치에 그려집니다.

우리는 getTimer 함수를 이용해 시간을 알아 낼 수 있습니다:

{% highlight cpp %}  
var thisTime = getTimer();
var time = (thisTime-v.lastTime)/100;
{% endhighlight %}

getTimer 함수는 플래시 무비가 시작한 시점으로부터 밀리 초의 숫자를 반환합니다. 움직임 연산에서 우리는 마지막 계산한 시간을 저장해서 현재시간에서 그 시간을 빼줍니다. 그리고 시간이 밀리초로 계산되었기 때문에 초 단위의 시간을 얻기위해 우리는 <s>100</s>으로 나눠야 합니다. 물론 pixel/millisecond 단위로 속도를 벡터에 사용할 수 있습니다. 다만 그렇게 하면 실질적으로 값이 매우 작아질 것임을 주의해야 합니다.

> 원문에서 100으로 나누도록 되어 있어서 그대로 썼지만, 1000으로 나누는 것이 맞다. 밀리세컨드는 1000 분의 1 초를 의미하기 때문이다. getTimer 함수는 AS3를 실행하는 경우와 AS2, AS1 을 실행하는 경우 의미가 조금 다르다. AS2 이하를 실행할 때는 플래시 런타임이 시작한 시점부터 계산하고, AS3 의 경우 플래시 런타임 버추얼 머신(AVM2)이 시작한 시점부터 계산한다. [여기서](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/utils/package.html#getTimer()) 확인할 수 있다.

그러면 끝점의 새로운 좌표는 소요된 시간을 이용해 계산되어 집니다 :

{% highlight as3 %}  
v.p1.x = v.p0.x+v.vx*time;
{% endhighlight %}

실제로 잘 작동하는지 살펴봅시다. 무비클립이 x=150, y=100 에 있고, vx 가 1 이라고 가정합니다. 프레임 레이트를 20으로 놓으면, 상황에 따라 변수 time은 5에서 50 ms 사이 일 것입니다. 시간이 5 ms 이라고 고정해보면, v.p1.x = v.p0.x + 0.05 식을 얻게 됩니다. 1초 동안 20번 움직임을 한 오브젝트는 20\*0.05=1 픽셀 이동합니다. 이것이 정확하게 우리가 원하는 속도 vx 입니다. 이제 time이 50이면, 무비클립은 1초에 단지 두번 새 좌표가 계산되고 그려집니다. 그렇지만 최종 위치는 역시 2\*0.5=1 픽셀입니다.

>이 계산 또한 밀리세컨드를 1000 분의 1 초로 다시 생각해야 한다. 안내서는 100 분의 1 초로 인식하고 있음을 알아야 한다. 프레임 레이트를 20으로 설정하면, time 은 50ms 또는 그 이상 일 것이다.

소스 <a href="vect4.fla">fla</a>를 다운받을 수 있습니다.

<br>

----

<br>

# 가속 (Acceleration)

속도 벡터가 오브젝트의 위치를 변경하듯이, 가속도 벡터는 오브젝트의 시간 단위 속도를 변경합니다.

<div id="flashContent">
    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="300" height="200" id="vect4a" align="middle">
        <param name="movie" value="vect4a.swf" />
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
        <object type="application/x-shockwave-flash" data="vect4a.swf" width="300" height="200">
            <param name="movie" value="vect4a.swf" />
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

그래서 시작 시점에서 오브젝트의 가속도 벡터를 0으로 설정합니다 :

{% highlight as3 %}  
myOb.ax = 0;
myOb.ay = 0;
{% endhighlight %}

이제 방향키가 눌러질 때마다, 가속도 벡터의 x 나 y 성분을 변경합니다. update 함수에서 가속도 벡터를 속도 벡터에 더합니다. 가속도 벡터를 사용할 때는 주의해야 하는데, 여러분이 속도를 제한하지 않으면 시간이 흘러 속력이 계속 계속 커질 것입니다.

{% highlight as3 %}  
v.vx = v.vx + v.ax;
v.vy = v.vy + v.ay;
{% endhighlight %}

게다가 완전히 오브젝트를 멈추고자 한다면 속도 벡터를 0으로 선정하는 것으로는 부족함을 알아야 합니다. 가속도 벡터 또한 0 으로 설정해야 합니다. 그렇지 않으면 오브젝트는 움직임을 유지합니다.

소스 <a href="vect4a.fla">fla</a>를 다운받을 수 있습니다.


<br>
<br>
다음 : [Intersection]({{ "/intersection/" | prepend: site.baseurl }})
