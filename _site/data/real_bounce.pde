/**
 * Real Bounce 
 * by hyonsoo han
 *
 * Shows vector's real bounce.
 * Checkout : brownsoo.github.io/2DVectors
 * Apache License 2.0 - http://www.apache.org/licenses/LICENSE-2.0
 */

//scale is to convert between stage coordinates
final int scale = 10;
//max velocity
final int maxV = 10;

boolean dragging = false;
Vector[] vectors;
Point ip;//intersection point
Dragger[] draggers;
Arrow[] arrows;
float gravity = 0.5;
float t2b = 1000000;//time to collide something big
// Object to move
Ball ball;
//reset button
SimpleButton resetBt;

void setup() {
  size(320, 300);
  // Pulling the display's density dynamically
  try {
    pixelDensity(displayDensity());
  } catch(Exception e){}
  
  //create object
  ball = new Ball(0xffFF5252, 12);
  ball.p0 = new Point(150, 100);
  ball.vx = 1;
  ball.vy = 0;
  ball.airf = 0.99;
  ball.b = 0.8;
  ball.f = 0.8;
  
  //create wall vectors
  vectors = new Vector[4];
  vectors[0] = new Vector(new Point(50, 50), new Point(250, 50), 1, 1);
  vectors[1] = new Vector(new Point(250, 50), new Point(250, 200), 1, 1);
  vectors[2] = new Vector(new Point(250, 200), new Point(50, 200), 1, 1);
  vectors[3] = new Vector(new Point(50, 200), new Point(50, 50), 1, 1);
  
  //calculate all parameters for the vector and draw it
  for(int i=0; i<vectors.length; i++) {
    updateVector(vectors[i]);
  }
  
  //Dragging Handler
  draggers = new Dragger[4];
  for(int i=0; i<draggers.length; i++) {
    draggers[i] = new Dragger();
  }
  //Arrow graphics for vector
  arrows = new Arrow[4];
  for(int i=0; i<arrows.length; i++) {
    arrows[i] = new Arrow(0xff4CAF50);
  }
  
  resetBt = new SimpleButton("Reset");
  resetBt.x = 10;
  resetBt.y = height - 50;
  resetBt.setCallback(new OnButtonClick());
  
}

class OnButtonClick implements ButtonCallback {
  void onClick(SimpleButton b) {
    //println(b.label + " click");
    ball.p0.x = 150;
    ball.p0.y = 100;
    ball.vx = 1;
    ball.vy = 0;
    vectors[0] = new Vector(new Point(50, 50), new Point(250, 50), 1, 1);
    vectors[1] = new Vector(new Point(250, 50), new Point(250, 200), 1, 1);
    vectors[2] = new Vector(new Point(250, 200), new Point(50, 200), 1, 1);
    vectors[3] = new Vector(new Point(50, 200), new Point(50, 50), 1, 1);
    //calculate all parameters for the vector and draw it
    for(int i=0; i<vectors.length; i++) {
      updateVector(vectors[i]);
    }
  }
}

void draw() {
  runMe();
  resetBt.place();
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
  drawAll();
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
    
    //get the coordinates from draggers
    for(int i=0; i<vectors.length; i++) {
      vectors[i].p0.x = draggers[i].x;
      vectors[i].p0.y = draggers[i].y;
      vectors[i].p1.x = draggers[(i+1)%4].x;
      vectors[i].p1.y = draggers[(i+1)%4].y;
      updateVector(vectors[i]);
    }
  }
  // start to calculate movement
  // add air resistance
  ball.vx *= ball.airf;
  ball.vy *= ball.airf;
  //Dont let it go over max speed
  ball.vx = min(maxV, max(-maxV, ball.vx));
  ball.vy = min(maxV, max(-maxV, ball.vy));
  //update the ball vector parameters
  updateBall(ball);
  //time to collide something big
  t2b = 1000000;
  //no collision yet
  Vector bouncedWall = null;
  //find collisions with walls
  for(int i=0; i<4; i++) {
    float t = findIntersection(ball, vectors[i]);
    //if this has collision, save it
    if(t < t2b) {
      //which wall to collide with
      bouncedWall = vectors[i];
      //save time
      t2b = t;
    }
  }
  //we have colliosion
  if(bouncedWall != null) {
    //set end point to intersection point
    ball.p1.x = ball.p0.x + ball.vx * t2b;
    ball.p1.y = ball.p0.y + ball.vy * t2b;
    //bounce
    Vector newV = bouncingVector(ball, bouncedWall);
    ball.vx = newV.vx;
    ball.vy = newV.vy;
    //add new direction to end point
    ball.p1.x += ball.vx * (1 - t2b);
    ball.p1.y += ball.vy * (1 - t2b);
    //save the time
    t2b = 1 - t2b;
  }
  //reset object to other side if gone out of stage
  if (ball.p1.x > width) {
    ball.p1.x -= width;
  } else if (ball.p1.x < 0) {
    ball.p1.x += width;
  }
  if (ball.p1.y > height) {
    ball.p1.y -= height;
  } else if (ball.p1.y < 0) {
    ball.p1.y += height;
  }
  //draw it
  drawAll();
  //make end point equal to starting point for next cycle
  ball.p0 = ball.p1;
  //save the movement witout time(reset vx/vy based on 1 sec)
  ball.vx /= ball.timeFrame;
  ball.vy /= ball.timeFrame;
}

//function to draw the points, lines and show text
//this is only needed for the example to illustrate
void drawAll() {
  //clear all
  background(255);
  
  //draw grid
  stroke(208);
  noFill();
  for(int i=0; i<width; i+=scale) {
    if(i%(10*scale)==0 && i>0) strokeWeight(2);
    else strokeWeight(1);
    line(i, 0, i, height);
  }
  for(int j=0; j<height; j+=scale) {
    if(j%(10*scale)==0 && j>0) strokeWeight(2);
    else strokeWeight(1);
    line(0, j, width, j);  
  }
  
  //place ball
  ball.place();
  
  //Draw Dragger
  draggers[0].x = vectors[0].p0.x;
  draggers[0].y = vectors[0].p0.y;
  draggers[0].place();
  draggers[1].x = vectors[0].p1.x;
  draggers[1].y = vectors[0].p1.y;
  draggers[1].place();
  draggers[2].x = vectors[2].p0.x;
  draggers[2].y = vectors[2].p0.y;
  draggers[2].place();
  draggers[3].x = vectors[2].p1.x;
  draggers[3].y = vectors[2].p1.y;
  draggers[3].place();
  
  // wall line
  for(int i=0; i<vectors.length; i++) {
    stroke(arrows[i].c);
    line(vectors[i].p0.x, vectors[i].p0.y, vectors[i].p1.x, vectors[i].p1.y);
    //Draw arrows
    arrows[i].x = vectors[i].p1.x;
    arrows[i].y = vectors[i].p1.y;
    arrows[i].rotation = atan2(vectors[i].vy, vectors[i].vx);
    arrows[i].place();
  }
  
}

//function to find all parameters for the vector
void updateVector(Vector v) {
  //x and y components
  //end point coordinate - start point coordinate
  v.vx = v.p1.x-v.p0.x;
  v.vy = v.p1.y-v.p0.y;
  //length of vector
  v.length = sqrt(v.vx*v.vx+v.vy*v.vy);
  //normalized unit-sized components
  if (v.length > 0) {
    v.dx = v.vx/v.length;
    v.dy = v.vy/v.length;
  } else {
    v.dx = 0;
    v.dy = 0;
  }
  //right hand normal
  v.rx = -v.vy;
  v.ry = v.vx;
  //left hand normal
  v.lx = v.vy;
  v.ly = -v.vx;
}

//function to find all parameters for the ball vector 
//with using start point and vx/vy, time
void updateBall(Ball v) {
  //find time passed from last update
  int thisTime = millis();
  float time = (thisTime - v.lastTime)/1000f*scale;
  //we use time, not frames to move so multiply movement vector with time passed
  v.vx *= time;
  v.vy *= time;
  //add gravity, also based on time
  v.vy = v.vy + gravity * time;
  //find end point coordinates
  v.p1 = new Point();//new creation for changing point.
  v.p1.x = v.p0.x + v.vx;
  v.p1.y = v.p0.y + v.vy;
  //length of vector
  v.length = sqrt(v.vx*v.vx+v.vy*v.vy);
  //normalized unit-sized components
  if (v.length > 0) {
    v.dx = v.vx/v.length;
    v.dy = v.vy/v.length;
  } else {
    v.dx = 0;
    v.dy = 0;
  }
  //right hand normal
  v.rx = -v.vy;
  v.ry = v.vx;
  //left hand normal
  v.lx = v.vy;
  v.ly = -v.vx;
  //save the current time
  v.lastTime = thisTime;
  //save time passed
  v.timeFrame = time;
}


//project vector v1 on unit-sized vector dx/dy
Vector projectVector(Vector v1, float dx, float dy) {
  //find dot product
  float dp = v1.vx*dx+v1.vy*dy;
  Vector proj = new Vector();
  //projection components
  proj.vx = dp*dx;
  proj.vy = dp*dy;
  return proj;
}

//find intersection point of 2 vectors
float findIntersection(Vector v0, Vector v1) {
  //vector between starting points
  Vector v = new Vector();
  v.vx = v1.p0.x - v0.p0.x;
  v.vy = v1.p0.y - v0.p0.y;
  Vector v_ = new Vector();
  v_.vx = v0.p0.x - v1.p0.x;
  v_.vy = v0.p0.y - v1.p0.y;
  
  float t, t_;
  if((v0.dx == v1.dx && v0.dy == v1.dy) ||
    (v0.dx == -v1.dx && v0.dy == -v1.dy)) {
    return 1000000;
  }
  else {
    t = perP(v, v1) / perP(v0, v1);
    t_ = perP(v_, v0) / perP(v1, v0);
  }
  
  if(t>=0 && t<=1 && t_>=0 && t_<=1) {
    return t;
  }
  else {
    return 1000000;
  }
}

//calculate perp  product of 2 vectors
float perP(Vector v0, Vector v1) {
  return v0.vx*v1.vy - v0.vy*v1.vx;
}

Vector bouncingVector(Vector v0, Vector v1) {
  //projection of v0 on v1
  Vector proj1 = projectVector(v0, v1.dx, v1.dy);
  //projection of v0 on v1 normal
  Vector proj2 = projectVector(v0, v1.lx/v1.length, v1.ly/v1.length);
  //reverse projecton on v1 normal
  proj2.vx *= -1;
  proj2.vy *= -1;
  //add the projections
  Vector proj = new Vector();
  proj.vx = v0.f*v1.f*proj1.vx + v0.b*v1.b*proj2.vx;
  proj.vy = v0.f*v1.f*proj1.vy + v0.b*v1.b*proj2.vy;
  
  return proj;
}


//function to round up numbers to x.xx format
//has nothing to do with vectors, only to show nice numbers in the example
String roundMe(float num) {
  String rnum = str(num);
  String[] nums = split(rnum, ".");
  if (nums[1] == null) {
    nums[1] = "00";
  }
  return nums[0]+"." + nums[1].substring(0, min(nums[1].length(), 2));
  
}



/** Ball Graphic */
class Ball extends Vector {
 public float size = 10;//radian
 public int c = 0;
 public int lastTime = 0;
 public float timeFrame = 0;
 
 Ball(int color0, float size0){
   super();
   this.c = color0;
   this.size = size0;
 }
 
 public void place() {
   fill(c);
   noStroke();
   ellipse(p1.x, p1.y, size, size);
 }
}

/** Handler to drag the points */
class Dragger {
  public float x;
  public float y;
  public boolean pressed = false;
  private float size;
  private float degree = 0;
  private float expend = 0;
  private float maxExpend = 6;

  public Dragger() {
    this(20);
  }
  public Dragger(int size0) {
    this.size = size0;
  }
  public void place() {
    degree = degree > 180 ? 0 : degree + 5;
    noStroke();
    fill(50, 76);
    expend = sin(radians(degree)) * maxExpend;
    ellipse(x, y, size + expend, size + expend);
    if(pressed) {
      fill(135, 181, 255, 200);
      ellipse(x, y, size + maxExpend * 6, size + maxExpend * 6);
    }
  }
  public boolean contains(float x0, float y0) {
    if(x0 < x - size/2 - maxExpend || x0 > x + size/2 + maxExpend 
      || y0 < y - size/2 - maxExpend || y0 > y + size/2 + maxExpend) {
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
  public float vx;
  public float vy;
  public float rx;
  public float ry;
  public float lx;
  public float ly;
  public float dx;
  public float dy;
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