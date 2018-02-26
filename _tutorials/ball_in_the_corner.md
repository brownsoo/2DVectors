---
layout: page
title: 8) 코너에 있는 공
englishTitle: Ball in the Corner
section: The ball
number: 3002
image: tut08.png
---

# 코너에 있는 공 (Ball in the Corner)

모든 장벽은 영원하지 않습니다. 적어도 벽들은 특정 지점에서 시작하고 끝납니다. 우린 이미 그 점들을 시작점과 끝점으로 부릅니다. 만약 공이 벽의 옆 이전에 모서리를 때리게 된다면 우리는 그 점들과의 충돌 그리고 새로운 벡터를 찾아야 합니다. 아래에서 공이 벽에 부딪힐 때와 모서리에 부딪힐 때를 구분해서 운동을 계산하는 방법을 설명하고자 합니다.

아래 예제에서 빨간선은 벽입니다. 회색선은 벽의 옆면 또는 모서리 점으로, 벽으로 직진하는 벡터입니다.

<canvas data-processing-sources="../data/ball_in_the_corner.pde"></canvas>
<small>(소스파일 [pde](../data/ball_in_the_corner.pde)를 다운받을 수 있습니다.)</small>

findIntersection 함수에서 어떤 부분이 공과 가장 가까운지 어떤 벡터가 교차 후 공을 움직이도록 사용할 것인지 구합니다.

벽은 w 이고, 공은 b 입니다. 먼저 벽의 사작점에서 공의 중심까지 벡터 v3를 구하세요.

{% highlight as3 %}  
Vector v3 = new Vector();
v3.vx = b.p1.x - w.p0.x;
v3.vy = b.p1.y - w.p0.y;
{% endhighlight %}

이제 이 새로운 벡터 v3와 벽의 내적을 구합니다.

{% highlight as3 %}  
float dp = v3.vx*w.dx + v3.vy*w.dy;
{% endhighlight %}

v3는 벽 벡터와 시작점이 같기 때문에, 만약 내적이 음수이면 공은 시작점에 더 가깝습니다. 그리고 공을 뒤로 움직여놓을 벡터는 벡터 v3 입니다.

{% highlight as3 %}  
if(dp < 0){
  return v3;
}
{% endhighlight %}

만약 내적이 0 또는 양수이면 공이 벽의 끝점과 가까운지 확인합니다. 그래서, 벽의 끝점에서 공의 중심까지 벡터를 찾습니다.

{% highlight as3 %}  
else{
  Vector v4 = new Vector();
  v4.vx = b.p1.x - w.p1.x;
  v4.vy = b.p1.y - w.p1.y;
{% endhighlight %}

그리고 첫번째 점처럼, 벽과 새 벡터 v4의 내적을 다시 계산합니다.

{% highlight as3 %}  
dp = v4.vx*w.dx + v4.vy*w.dy;
{% endhighlight %}

만약 내적이 양수이면 공이 끝점을 먼저 때리고 v4는 공을 떨어뜨려 놓는데 사용됩니다.

{% highlight as3 %}  
if(dp > 0){
  return v4;
}
{% endhighlight %}

그런데 이때 내적이 0 또는 음수라면 벽의 옆면이 공과 가장 가깝습니다. 그러면 시작점에서 공의 중심까지의 벡터(v3)를 벽의 노말에 투영시킵니다. 지난 단계에서 했던 방식대로 벽의 노말 방향으로 공은 뒤로 이동될 것입니다.

{% highlight as3 %}  
else{
  return projectVector(v3, w.ldx, w.ldy);//ldx, ldy -> unit sized normals
}
{% endhighlight %}

공을 반동시킨 벡터는 공을 벽에서 떨어뜨리는 데 사용한 벡터와 직교할 것임을 기억하세요. 공이 벽의 옆을 부딪히면 새로운 벡터를 구하기 위해 벽 벡터를 사용할 수 있습니다. 공이 모서리를 부딪히면 벽의 가까운 점에서 공의 중심점까지의 벡터의 노말이 사용될 것입니다.

> 공을 떨어뜨리는 벡터와 공을 반동시키게 만드는 벡터는 직교한다.

아래 예제에서 벽을 드래그해서 코너를 부딪히는 공을 보도록 하세요.

<canvas data-processing-sources="../data/ball_in_the_box.pde"></canvas>
<small>(소스파일 [pde](../data/ball_in_the_box.pde)를 다운받을 수 있습니다.)</small>


공의 끝 지점에 대해서만 검사하기 때문에 매우 큰 속도에서는 공을 보지 못한 채 공이 벽을 통과할 가능성이 있습니다. 이런 상황을 피하기 위해서는 공의 속도가 절대 공의 반경보다 크지 않도록 제한해 주어야 합니다.


<br>
<br>
다음 : [Ball vs ball]({{ "/ball_vs_ball/" | prepend: site.baseurl }})


