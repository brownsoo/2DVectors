/**
 * 2 Moving Balls
 * by hyonsoo han
 *
 * Shows how to find the collision position among two moving balls.
 * Checkout : brownsoo.github.io/Vectors-for-Animation
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

boolean dragging = false;
Dragger[] draggers;
Arrow[] arrows;

Ball ball1; 
Ball ball2;
Ball ball1a; // position of balls after moving/colliding
Ball ball2a; // position of balls after moving/colliding
Vector vc;
Vector vn;
Vector v3;
Vector v4;
//reset button
SimpleButton resetBt;

void setup() {
  size(320, 300);
  // Pulling the display's density dynamically
  try {
    pixelDensity(displayDensity());
  } catch(Exception e){}
  
  //create object
  ball1 = new Ball(new Point(100, 80), _RED, 40);
  ball1.p1 = new Point(250, 80);
  updateVector(ball1, true);
  ball2 = new Ball(new Point(200, 180), _BLUE, 40);
  ball2.p1 = new Point(240, 120);
  updateVector(ball2, true);
  //ball at collison
  ball1a = new Ball(_RED&0x54ffffff, 40);
  ball2a = new Ball(_BLUE&0x54ffffff, 40);
  
  vc = new Vector();
  vn = new Vector();
  v3 = new Vector();
  v4 = new Vector();
  
  //Dragging Handler
  draggers = new Dragger[4];
  for(int i=0; i<draggers.length; i++) {
    draggers[i] = new Dragger(12);
  }
  
  //Arrow graphics for vector
  arrows = new Arrow[6];
  arrows[0] = new Arrow(_RED);
  arrows[1] = new Arrow(_BLUE);
  arrows[2] = new Arrow(_GRAY);
  arrows[3] = new Arrow(_GRAY);
  arrows[4] = new Arrow(_GREEN&0x84ffffff);//v3
  arrows[5] = new Arrow(_GREEN&0x54ffffff);//v4
  
  resetBt = new SimpleButton("Reset");
  resetBt.x = 10;
  resetBt.y = height - 50;
  resetBt.setCallback(new OnButtonClick());
  
  runMe();
}

class OnButtonClick implements ButtonCallback {
  void onClick(SimpleButton b) {
    //println(b.label + " click");
    ball1 = new Ball(new Point(100, 80), _RED, 40);
    ball1.p1 = new Point(250, 80);
    updateVector(ball1, true);
    ball2 = new Ball(new Point(200, 180), _BLUE, 40);
    ball2.p1 = new Point(240, 120);
    updateVector(ball2, true);
  }
}

void draw() {
  resetBt.place();
  if(!mousePressed) return; //redraw only when interacting
  runMe();
}

void mousePressed() {
  boolean b = false;
  for(int i=0; i<draggers.length; i++) {
    if(draggers[i].contains(mouseX, mouseY)) {
      draggers[i].pressed = true;
      b = true;
    }
    else {
      draggers[i].pressed = false;
    }
  }
  dragging = b;
}

void mouseReleased() {
  dragging = false;
  for(int i=0; i<draggers.length; i++) {
    draggers[i].pressed = false;
  }
  runMe();
}

//main function
void runMe() {
  if(dragging) {
    for(int i=0; i<draggers.length; i++) {
      if(draggers[i].pressed) {
        draggers[i].x = mouseX;
        draggers[i].y = mouseY;
      }
    }
    
    ball1.p0.x = draggers[0].x;
    ball1.p0.y = draggers[0].y;
    ball1.p1.x = draggers[1].x;
    ball1.p1.y = draggers[1].y;
    updateVector(ball1, true);
    
    ball2.p0.x = draggers[2].x;
    ball2.p0.y = draggers[2].y;
    ball2.p1.x = draggers[3].x;
    ball2.p1.y = draggers[3].y;
    updateVector(ball2, true);
  }
  // start to calculate movement
  // Reduce movement vector from ball2 from movement vector of ball1
  v3.p0 = ball1.p0;
  v3.vx = ball1.vx - ball2.vx;
  v3.vy = ball1.vy - ball2.vy;
  updateVector(v3, false);
  // Use v3 as new movement vector for colliosion calculation
  // vector between center points of balls
  vc.p0 = ball1.p0;
  vc.p1 = ball2.p0;
  updateVector(vc, true);
  // projection of vc on v3
  Vector vp = projectVector(vc, v3.dx, v3.dy);
  // vector to center of ball2 in direction of movement vector's normal
  vn.p0 = new Point(ball1.p0.x + vp.vx, ball1.p0.y + vp.vy);
  vn.p1 = ball2.p0;
  updateVector(vn, true);
  //sum of radius
  float sumRadius = ball1.r + ball2.r;
  //check if vn is shorter then combined radiuses
  float diff = sumRadius - vn.length;
  boolean collision = false;
  if(diff > 0) {
    //collision
    //amount to move back moving ball
    float moveBack = sqrt(sumRadius*sumRadius - vn.length*vn.length);
    Point p4 = new Point();
    p4.x = vn.p0.x - moveBack * v3.dx;
    p4.y = vn.p0.y - moveBack * v3.dy;
    //Vector from ball1 starting point to its coordinates wehen collision happens
    v4.p0 = ball1.p0;
    v4.p1 = p4;
    updateVector(v4, true);
    //check if p3 is on the movement vector
    if(v4.length < v3.length && dotP(v4, ball1) > 0) {
      //collision
      float t = v4.length / v3.length;
      collision = true;
      ball1a.p0 = new Point(ball1.p0.x + t * ball1.vx, ball1.p0.y + t * ball1.vy);
      ball2a.p0 = new Point(ball2.p0.x + t * ball2.vx, ball2.p0.y + t * ball2.vy);
    } 
  }
  
  if(!collision) {
    //no collision
    ball1a.p0 = ball1.p1;
    ball2a.p0 = ball2.p1;
    v3.length = 0;
    v4.length = 0;
  }
  
  //draw it
  drawAll();
}

//function to draw the points, lines and show text
//this is only needed for the example to illustrate
void drawAll() {
  //clear all
  background(255);
  //Draw draggers
  draggers[0].x = ball1.p0.x;
  draggers[0].y = ball1.p0.y;
  draggers[1].x = ball1.p1.x;
  draggers[1].y = ball1.p1.y;
  draggers[2].x = ball2.p0.x;
  draggers[2].y = ball2.p0.y;
  draggers[3].x = ball2.p1.x;
  draggers[3].y = ball2.p1.y;
  for(int i=0; i<draggers.length; i++) {
    draggers[i].place();
  }
  
  //place balls at its 0 point
  ball1.placeAtP0();
  ball2.placeAtP0();
  ball1a.placeAtP0();
  ball2a.placeAtP0();
  
  noFill();
  strokeWeight(1);
  
  //movement vector of ball1
  stroke(arrows[0].c);
  line(ball1.p0.x, ball1.p0.y, ball1.p1.x, ball1.p1.y);
  arrows[0].x = ball1.p1.x;
  arrows[0].y = ball1.p1.y;
  arrows[0].rotation = atan2(ball1.vy, ball1.vx);
  arrows[0].place();
  
  //movement vector of ball2
  stroke(arrows[1].c);
  line(ball2.p0.x, ball2.p0.y, ball2.p1.x, ball2.p1.y);
  arrows[1].x = ball2.p1.x;
  arrows[1].y = ball2.p1.y;
  arrows[1].rotation = atan2(ball2.vy, ball2.vx);
  arrows[1].place();
  
  //vector between ball center points
  stroke(arrows[2].c);
  line(vc.p0.x, vc.p0.y, vc.p1.x, vc.p1.y);
  arrows[2].x = vc.p1.x;
  arrows[2].y = vc.p1.y;
  arrows[2].rotation = atan2(vc.vy, vc.vx);
  arrows[2].place();
  
  //vector to center of ball2 on the direction
  //of movement vector's normal
  stroke(arrows[3].c);
  line(vn.p0.x, vn.p0.y, vn.p1.x, vn.p1.y);
  arrows[3].x = vn.p1.x;
  arrows[3].y = vn.p1.y;
  arrows[3].rotation = atan2(vn.vy, vn.vx);
  arrows[3].place();
  
  //v3: reduce movement vector from ball2 from movement vector of ball1
  if(v3.length > 0) {
    stroke(arrows[4].c);
    strokeWeight(2);
    line(v3.p0.x, v3.p0.y, v3.p1.x, v3.p1.y);
    arrows[4].x = v3.p1.x;
    arrows[4].y = v3.p1.y;
    arrows[4].rotation = atan2(v3.vy,v3.vx);
    arrows[4].place();
  }
  
  //v4: vector to collision position 
  //on the direction of movement vector's normal
  if(v4.length > 0) {
    stroke(arrows[5].c);
    strokeWeight(2);
    line(v4.p0.x, v4.p0.y, v4.p1.x, v4.p1.y);
    arrows[5].x = v4.p1.x;
    arrows[5].y = v4.p1.y;
    arrows[5].rotation = atan2(v4.vy,v4.vx);
    arrows[5].place();
  }
  
  //text
  fill(0);
  textAlign(CENTER);
  text("ball1", ball1.p0.x, ball1.p0.y - ball1.r - 10);
  text("ball2", ball2.p0.x, ball2.p0.y + ball1.r + 20);
  text("vc", (vc.p0.x + vc.p1.x)/2, (vc.p0.y + vc.p1.y)/2);
  text("vn", (vn.p0.x + vn.p1.x)/2, (vn.p0.y + vn.p1.y)/2);
  
  
  
  textAlign(LEFT);
  fill(arrows[4].c);
  text("v3: v1-v2", 10, 20);
  
  if(v3.length > 0) {
    fill(arrows[4].c);
    text("v3", (v3.p0.x + v3.p1.x)/2, (v3.p0.y + v3.p1.y)/2);
  }
  if(v4.length > 0) {
    fill(arrows[5].c);
    text("v4", (v4.p0.x + v4.p1.x)/2, (v4.p0.y + v4.p1.y)/2);
    fill(0);
    textAlign(CENTER);
    text("p4", v4.p1.x, v4.p1.y - 10);
    noStroke();
    ellipse(v4.p1.x, v4.p1.y, 4, 4);
  }
}


//function to find all parameters for the vector
void updateVector(Vector v, boolean fromPoints) {
  //x and y components
  if(fromPoints) {
    v.vx = v.p1.x-v.p0.x;
    v.vy = v.p1.y-v.p0.y;
  }
  else {
    v.p1.x = v.p0.x + v.vx;
    v.p1.y = v.p0.y + v.vy;
  }
  //length of vector
  v.length = sqrt(v.vx*v.vx+v.vy*v.vy);
  //normalized unit-sized components
  if (v.length > 0) {
    v.dx = v.vx/v.length;
    v.dy = v.vy/v.length;
  }
  else {
    v.dx = 0;
    v.dy = 0;
  }
  
  //right hand normal
  v.rx = -v.vy;
  v.ry = v.vx;
  v.rdx = -v.dy;
  v.rdy = v.dx;
  //left hand normal
  v.lx = v.vy;
  v.ly = -v.vx;
  v.ldx = v.dy;
  v.ldy = -v.dx;
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


// ------------------------------------
// -------------- CLASS ---------------
// ------------------------------------

/** Ball Graphic */
class Ball extends Vector {
 public float r = 10; //radius
 public int c = 0;
 public int lastTime = 0;
 public float timeFrame = 0;
 
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

/** Handler to drag the points */
class Dragger {
  public float x;
  public float y;
  private int size;
  public boolean pressed = false;
  public Dragger(int size0) {
    this.size = int(size0 / 2);
  }
  public void place() {
    
    noStroke();
    fill(50, 76);
    rect(x -size -2, y -size -2, size + size + 4, size + size + 4);
    if(!pressed) fill(255, 50);
    else fill(204, 102, 45, 200);
    rect(x - size, y - size, size + size, size + size);
    
  }
  public boolean contains(float x0, float y0) {
    if(x0 < x - size || x0 > x + size 
      || y0 < y - size || y0 > y + size) {
      return false;
    }
    return true;
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