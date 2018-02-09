/**
 * Bouncing 2 moving balls
 * by hyonsoo han
 *
 * Illustrate how to find the collision of moving balls.
 * Checkout : brownsoo.github.io/2DVectors
 * Apache License 2.0 - http://www.apache.org/licenses/LICENSE-2.0
 * 
 */

final int _GREEN = 0xff4CAF50;
final int _RED = 0xffFF5252;
final int _BLUE = 0xff03A9F4;
final int _GRAY = 0xff757575;
final int _BLACK = 0xff212121;

final int maxV = 10;
final int scale = 10;
final float gravity = 0;

Arrow[] arrows;

//vectors to support
Ball vc;
Ball vn;
Ball v3;
Ball v4;

Ball[] balls;

//reset button
SimpleButton resetBt;

void setup() {
  size(320, 300);
  // Pulling the display's density dynamically
  try {
    pixelDensity(displayDensity());
  } catch(Exception e){}
  
  balls = new Ball[4];
  for(int i=0; i<4; i++) {
    balls[i] = new Ball(_BLACK, 5+random(4)*5);
    float x = (i+1) * 45;
    float y = 80;
    balls[i].p0.x = x;
    balls[i].p0.y = y;
    balls[i].p1.x = x + (i+1);
    balls[i].p1.y = y + random(3)-1;
    updateBall(balls[i], true);
  }
  
  vc = new Ball(0,0);
  vn = new Ball(0,0);
  v3 = new Ball(0,0);
  v4 = new Ball(0,0);
  
  //Arrow graphics for vector
  arrows = new Arrow[4];
  arrows[0] = new Arrow(_GRAY);
  arrows[1] = new Arrow(_GRAY);
  arrows[2] = new Arrow(_GRAY);
  arrows[3] = new Arrow(_GRAY);
  
  resetBt = new SimpleButton("Reset");
  resetBt.x = 10;
  resetBt.y = height - 40;
  resetBt.setCallback(new OnButtonClick());
  
  runMe();
}

class OnButtonClick implements ButtonCallback {
  void onClick(SimpleButton b) {
    //println(b.label + " click");
    for(int i=0; i<4; i++) {
      balls[i] = new Ball(_BLACK, 5+random(4)*5);
      float x = (i+1) * 45;
      float y = 80;
      balls[i].p0.x = x;
      balls[i].p0.y = y;
      balls[i].p1.x = x + (i+1);
      balls[i].p1.y = y + random(3)-1;
      updateBall(balls[i], true);
    }
  }
}

void draw() {
  runMe();
  resetBt.place();
}

//main function
void runMe() {
  Ball ball1;
  Ball ball2;
  for(int i=0; i<balls.length; i++) {
    ball1 = balls[i];
    updateBall(ball1, false);
    
    for(int j=0; j<balls.length; j++) {
      if(i == j) {continue;}
      ball2 = balls[j];
      
      //vector between center points of ball
      vc.p0 = ball1.p0;
      vc.p1 = ball2.p0;
      updateBall(vc, true);
      
      //sum of radius
      float sumRadius = ball1.r + ball2.r;
      float pen = sumRadius - vc.length;
      //check if balls collide at start
      if(pen >=0) {
       //move object away from the ball
       ball1.p1.x -= vc.dx * pen;
       ball1.p1.y -= vc.dy * pen;
       //change movement, bounce off from the normal of v
       Vector newv = bounceBalls(ball1, ball2, vc);
       ball1.vx = newv.vx1;
       ball1.vy = newv.vy1;
       ball2.vx = newv.vx2;
       ball2.vy = newv.vy2;
      }
      else {
       //reduce movement vector from ball2 from movement vector of ball1
       v3.p0 = ball1.p0;
       v3.vx = ball1.vx - ball2.vx;
       v3.vy = ball1.vy - ball2.vy;
       updateBall(v3, false);
       //use v3 as new movement vector for collision calculation
       //projection of vc on v3
       Vector vp = projectVector(vc, v3.dx, v3.dy);
       //vector to center of ball2 in direction of movement vector's normal
       vn.p0 = new Point(ball1.p0.x+vp.vx, ball1.p0.y+vp.vy);
       vn.p1 = ball2.p0;
       updateBall(vn, true);
       //check if vn is shorter then combined radiuses
       float diff = sumRadius - vn.length;
       boolean collision = false;
       if(diff > 0) {
         //collision
         //amount to move back moving ball
         float moveBack = sqrt(sumRadius*sumRadius - vn.length*vn.length);
         Point p3 = new Point();
         p3.x = vn.p0.x - moveBack*v3.dx;
         p3.y = vn.p0.y - moveBack*v3.dy;
         //vector from ball staring point to its coordinates when collision happens
         v4.p0 = ball1.p0;
         v4.p1 = p3;
         updateBall(v4, true);
         //check if p3 is on the movement vector
         if(v4.length<=v3.length && dotP(v4, ball1)>0) {
           //collision
           float t = v4.length / v3.length;
           collision = true;
           ball1.p1 = new Point(ball1.p0.x + t*ball1.vx, ball1.p0.y + t*ball1.vy);
           ball2.p1 = new Point(ball2.p0.x + t*ball2.vx, ball2.p0.y + t*ball2.vy);
           //vector between centers of ball in the moment of colliosion
           vc.p0 = ball1.p1;
           vc.p1 = ball2.p1;
           updateBall(vc, true);
           Vector newv = bounceBalls(ball1, ball2, vc);
           ball1.vx = newv.vx1;
           ball1.vy = newv.vy1;
           ball2.vx = newv.vx2;
           ball2.vy = newv.vy2;
           makeVector(ball1);
           makeVector(ball2);
         }
       }
      }
    }
  }
  
  //draw it
  drawAll();
}

//function to draw the points, lines and show text
//this is only needed for the example to illustrate
void drawAll() {
  //clear all
  background(255);
  
  //place balls
  for(int i=0; i<balls.length; i++) {
    balls[i].place();
    balls[i].p0 = balls[i].p1;
    updateBall(balls[i], false);
  }
  
  
  noFill();
  strokeWeight(1);
  
  //movement vector of balls
  for(int i=0; i<balls.length; i++) {
    stroke(arrows[i].c);
    float tx = balls[i].p0.x + balls[i].vx * 10;// multiply x10 to see
    float ty = balls[i].p0.y + balls[i].vy * 10;
    line(balls[i].p0.x, balls[i].p0.y, tx, ty);
    arrows[i].x = tx;
    arrows[i].y = ty;
    arrows[i].rotation = atan2(balls[i].vy, balls[i].vx);
    arrows[i].place();
  }
  
}


//function to find all parameters for the vector
void updateBall(Ball b, boolean fromPoints) {
  //x and y components
  if(fromPoints) {
    b.vx = b.p1.x - b.p0.x;
    b.vy = b.p1.y - b.p0.y;
  }
  else {
    b.p1.x = b.p0.x + b.vx;
    b.p1.y = b.p0.y + b.vy;
  }
  //reset object to other side if gone out of stage
  holdBall(b);
  makeVector(b);
}

//function to hold balls inside stage
void holdBall(Ball b){
  //reset object to other side if gone out of stage
  if(b.p1.x > width - b.r){
    b.p1.x = width - b.r;
    b.vx = -abs(b.vx);
  } 
  else if(b.p1.x < b.r){
    b.p1.x = b.r;
    b.vx = abs(b.vx);
  }
  if(b.p1.y > height - b.r){
    b.p1.y = height - b.r;
    b.vy = -abs(b.vy);
  }
  else if(b.p1.y < b.r){
    b.p1.y = b.r;
    b.vy = abs(b.vy);
  }
}

void makeVector(Vector v){
  //length of vector
  v.length = sqrt(v.vx*v.vx+v.vy*v.vy);
  //normalized unti-sized components
  if(v.length > 0){
    v.dx=v.vx / v.length;
    v.dy=v.vy / v.length;
  } else {
    v.dx=0;
    v.dy=0;
  }
  //right hand normal
  v.rx = -v.dy;
  v.ry = v.dx;
  //left hand normal
  v.lx = v.dy;
  v.ly = -v.dx;
}

//calculate dot product of 2 vectors
float dotP(Vector v1, Vector v2) {
 return v1.vx*v2.vx + v1.vy*v2.vy; 
}

//project vector of v1 on unit-sized vector dx/dy
Vector projectVector(Vector v1, float dx, float dy) {
  //find dot product
  float dp = v1.vx*dx+v1.vy*dy;
  Vector proj = new Vector();
  //projection components
  proj.vx = dp*dx;
  proj.vy = dp*dy;
  
  return proj;
}

//find new movement vector bouncing from v
Vector bounceBalls(Ball v1, Ball v2, Vector v){
  //projection of v1 on v
  Vector proj11 = projectVector(v1, v.dx, v.dy);
  //projection of v1 on v normal
  Vector proj12 = projectVector(v1, v.lx, v.ly);
  //projection of v2 on v
  Vector proj21 = projectVector(v2, v.dx, v.dy);
  //projection of v2 on v normal
  Vector proj22 = projectVector(v2, v.lx, v.ly);

  float P = v1.m*proj11.vx + v2.m*proj21.vx;
  float V = proj11.vx - proj21.vx;
  float v2fx = (P+V*v1.m)/(v1.m+v2.m);
  float v1fx = v2fx-V;

  P = v1.m*proj11.vy+v2.m*proj21.vy;
  V = proj11.vy - proj21.vy;
  float v2fy = (P+V*v1.m)/(v1.m+v2.m);
  float v1fy = v2fy-V;

  Vector proj = new Vector();
  //add the projections for v1
  proj.vx1 = proj12.vx+v1fx;
  proj.vy1 = proj12.vy+v1fy;
  //add the projections for v2
  proj.vx2 = proj22.vx+v2fx;
  proj.vy2 = proj22.vy+v2fy;
  return proj;
}


// ------------------------------------
// -------------- CLASS ---------------
// ------------------------------------

/** Ball Graphic */
class Ball extends Vector {
 public float r = 10; //radius
 public int c = 0;
 public int lastTime = 0;
 public float timeFrame = 0;
 public float m = 1;
 
 Ball(int color0, float radius0){
   super();
   this.c = color0;
   this.r = radius0;
 }
 
 Ball(Point p0, int color0, float radius0){
   super();
   this.p0 = p0;
   this.c = color0;
   this.r = radius0;
 }
 
 public void place() {
   fill(c, 30);
   strokeWeight(1);
   stroke(c);
   ellipse(p1.x, p1.y, r*2, r*2);
   
   fill(c);
   noStroke();
   ellipse(p1.x, p1.y, 4, 4);
 }
 
 public void placeAtP0() {
   strokeWeight(1);
   fill(c, 30);
   stroke(c);
   ellipse(p0.x, p0.y, r*2, r*2);
   
   fill(c);
   noStroke();
   ellipse(p0.x, p0.y, 4, 4);
 }
 
}


/** Arrow Graphic definition */
class Arrow {
 public float x;
 public float y;
 public float rotation = 0;//radian
 public int c = 0;
 
 Arrow(int color0){
   c = color0;
 }
 
 public void place() {
   stroke(c);
   noFill();
   pushMatrix();
   translate(x, y);
   rotate(rotation + QUARTER_PI); //Arrow is leaned by QUARTER_PI 
   line(0, 0, -9, 2);
   line(0, 0, -2, 9);
   popMatrix();
 }
}

/** Point definition */
class Point {
 public float x;
 public float y;
 Point(){}
 Point(float x0, float y0) {
   this.x = x0;
   this.y = y0;
 }
}

/** Vector definition */
class Vector {
  public Point p0;
  public Point p1;
  public float vx = 0;
  public float vy = 0;
  public float rx = 0;
  public float ry = 0;
  public float lx = 0;
  public float ly = 0;
  public float dx = 0;
  public float dy = 0;
  public float rdx = 0;//right unit normal
  public float rdy = 0;
  public float ldx = 0;//left unit normal
  public float ldy = 0;
  public float length;
  public float airf = 1;//air friction
  public float b = 1;//bounce
  public float f = 1;//friction
  public float vx1 = 0;
  public float vy1 = 0;
  public float vx2 = 0;
  public float vy2 = 0;
  
  public Vector() {
    p0 = new Point();
    p1 = new Point();
  }
  
  public Vector(Point p0, Point p1) {
    this.p0 = p0;
    this.p1 = p1;
  }
  
  public Vector(Point p0, Point p1, float b, float f) {
    this.p0 = p0;
    this.p1 = p1;
    this.b = b;
    this.f = f;
  }
}



//----------------------------------

/** 
* Simple Button 
* by hyonsoo han
* 
To make button;

1. create new SimpleButton instance.
  btn = new SimpleButton("OK"); 
  btn.x = 10;
  btn.y = 50;

2. create new class of ButtonCallback.
  class ClickImpl implements ButtonCallback {
    void onClick() {
      println("onclick");
    }
  }

3. Connect listener instance with the button.
  btn.setCallback(new ClickImpl());

4. Call the place-function of SimpleButton in every time to draw 

*/
public class SimpleButton {
  public int x;
  public int y;
  public boolean pressed = false;
  public int c = 0xFFFFC107;
  private String label;
  private float tw;
  private float th;
  private int mx=0, my=0;
  private int mTime = 0;
  private int mState = 0;
  
  private ButtonCallback callback;
  public SimpleButton(String label0){
    this(label0, 0xFFFFC107);
  }
  public SimpleButton(String label0, int color0) {
    label = label0;
    textSize(12);
    tw = textWidth(label0) + 10;
    th = 24;
    c = color0;
  }
  
  public void place() {
    
    noStroke();
    
    if(!pressed) {
      fill(c);
      rect(x, y, tw, th);
      fill(255);
      textAlign(CENTER, CENTER);
      text(label, x + tw/2, y + th/2);
    }
    else {
      fill(200, 156);
      rect(x, y, tw, th);
      fill(0);
      textAlign(CENTER, CENTER);
      text(label, x + tw/2, y + th/2);
    }
    textAlign(LEFT, BASELINE);
    
    if(mState == 0 && mousePressed) {
      mPressed();
    }
    else if(mState == 1 && !mousePressed) {
      mReleased();
    }
  }
  
  
  public void mPressed() {
    mx = mouseX;
    my = mouseY;
    mTime = millis();
    pressed = contains(mouseX, mouseY);
    mState = (pressed?1:0);
  }
  
  public void mReleased() {
    pressed = false;
    mState = 0;
    if(!contains(mouseX, mouseY)) return;
    if(abs(mx - mouseX) > 10) return;
    if(abs(my - mouseY) > 10) return;
    if(millis() - mTime > 200) return;
    if(callback != null) callback.onClick(this);
  }
  
  public boolean contains(float x0, float y0) {
    if(x0 < x || x0 > x + tw 
      || y0 < y || y0 > y + th) {
      return false;
    }
    return true;
  }
  
  public void setCallback(ButtonCallback callback0) {
    callback = callback0;
  }
}

/** Listener for Simple Button */
public interface ButtonCallback {
  void onClick(SimpleButton button);
}