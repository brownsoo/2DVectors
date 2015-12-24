/**
 * Ball in the box 
 * by hyonsoo han
 *
 * Shows how to interact ball in the box
 * Checkout : brownsoo.github.io/2DVectors
 * Apache License 2.0 - http://www.apache.org/licenses/LICENSE-2.0
 */

final int _GREEN = 0xff4CAF50;
final int _RED = 0xffFF5252;
final int _BLUE = 0xff03A9F4;
final int _GRAY = 0xff757575;
final int _BLACK = 0xff212121;

final int maxV = 10;
final float gravity = 0.5;
final int scale = 10;
boolean dragging = false;
Vector[] vectors;
Dragger[] draggers;
Arrow[] arrows;
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
  ball = new Ball(_BLACK, 20);
  ball.p0 = new Point(150, 30);
  ball.airf = 0.99;
  ball.b = 1;
  ball.f = 1;
  ball.lastTime = millis();
  ball.vx = 2;
  ball.vy = -5;
  
  //create wall vectors
  vectors = new Vector[4];
  vectors[0] = new Vector(new Point(250, 100), new Point(50, 100), 1, 1);
  vectors[1] = new Vector(new Point(50, 100), new Point(50, 200), 1, 1);
  vectors[2] = new Vector(new Point(50, 200), new Point(250, 200), 1, 1);
  vectors[3] = new Vector(new Point(250, 200), new Point(250, 100), 1, 1);
  
  //calculate all parameters for the vector and draw it
  for(int i=0; i<vectors.length; i++) {
    updateVector(vectors[i], true);
  }
  
  //Dragging Handler
  draggers = new Dragger[4];
  for(int i=0; i<draggers.length; i++) {
    draggers[i] = new Dragger(12);
  }
  //Arrow graphics for vector
  arrows = new Arrow[4];
  for(int i=0; i<arrows.length; i++) {
    arrows[i] = new Arrow(_RED);
  }
  
  resetBt = new SimpleButton("Reset");
  resetBt.x = 10;
  resetBt.y = height - 50;
  resetBt.setCallback(new OnButtonClick());
  
}

class OnButtonClick implements ButtonCallback {
  void onClick(SimpleButton b) {
    ball.p0 = new Point(150, 30);
    ball.vx = 5;
    ball.vy = -5;
    vectors[0] = new Vector(new Point(250, 100), new Point(50, 100), 1, 1);
    vectors[1] = new Vector(new Point(50, 100), new Point(50, 200), 1, 1);
    vectors[2] = new Vector(new Point(50, 200), new Point(250, 200), 1, 1);
    vectors[3] = new Vector(new Point(250, 200), new Point(250, 100), 1, 1);
    //calculate all parameters for the vector and draw it
    for(int i=0; i<vectors.length; i++) {
      updateVector(vectors[i], true);
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
      updateVector(vectors[i], true);
    }
  }
  // start to calculate movement
  //add air resistance
  ball.vx *= ball.airf;
  ball.vy *= ball.airf;
  //Dont let it go over max speed
  ball.vx = min(maxV, max(-maxV, ball.vx));
  ball.vy = min(maxV, max(-maxV, ball.vy));
  
  //update the ball vector parameters
  updateBall(ball);
  
  //check the walls for collisions
  for(int i=0; i<4; i++) {
    Vector wall = vectors[i];
    Vector v = findBackwardVector(ball, wall);
    updateVector(v, false);//to get length, dx, dy 
    float pen = ball.r - v.length;
    //if we have hit the wall
    if(pen >= 0) {
      //move object away from colliosion point
      ball.p1.x += v.dx * pen;
      ball.p1.y += v.dy * pen;
      //change movement, bounce off from the normal of v
      Vector vbounce = new Vector();
      vbounce.dx = v.ldx;
      vbounce.dy = v.ldy;
      vbounce.ldx = v.dx;
      vbounce.ldy = v.dy;
      Vector vb = findBounceVector(ball, vbounce);
      ball.vx = vb.vx;
      ball.vy = vb.vy;
    }
  }
  
  //reset object to other side if gone out of stage
  if (ball.p1.x > width + ball.r) {
    ball.p1.x = -ball.r;
  } else if (ball.p1.x < -ball.r) {
    ball.p1.x = width + ball.r;
  }
  if (ball.p1.y > height + ball.r) {
    ball.p1.y = -ball.r;
  } else if (ball.p1.y < -ball.r) {
    ball.p1.y = height + ball.r;
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
    if(vectors[i].vx == 0 && vectors[i].vy == 0) continue;
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

//function to find all parameters for the ball vector 
//with using start point and vx/vy, time
void updateBall(Ball b) {
  //find time passed from last update
  int thisTime = millis();
  float time = (thisTime - b.lastTime)/1000f*scale;
  //we use time, not frames to move 
  //so multiply movement vector with time passed
  b.vx *= time;
  b.vy *= time;
  //add gravity, also based on time
  b.vy = b.vy + gravity * time;
  //find end point coordinates
  b.p1 = new Point();//new creation for changing point.
  b.p1.x = b.p0.x + b.vx;
  b.p1.y = b.p0.y + b.vy;
  //length of vector
  b.length = sqrt(b.vx*b.vx + b.vy*b.vy);
  //normalized unit-sized components
  if(b.length > 0) {
    b.dx = b.vx/b.length;
    b.dy = b.vy/b.length;
  }
  else {
    b.dx = 0;
    b.dy = 0;
  }
  //right hand normal
  b.rx = -b.vy;
  b.ry = b.vx;
  b.rdx = -b.dy;
  b.rdy = b.dx;
  //left hand normal
  b.lx = b.vy;
  b.ly = -b.vx;
  b.ldx = b.dy;
  b.ldy = -b.dx;
  //save the current time
  b.lastTime = thisTime;
  //save time passed
  b.timeFrame = time;
}



//find new vector of ball to move backward from v0
Vector findBackwardVector(Vector b, Vector w) {
  //vector between center of ball and starting point of wall
  Vector v3 = new Vector();
  v3.vx = b.p1.x - w.p0.x;
  v3.vy = b.p1.y - w.p0.y;
  //check if we have hit starting point
  float dp = v3.vx*w.dx + v3.vy*w.dy;
  if(dp < 0) {
    return v3;
  }
  else {
    Vector v4 = new Vector();
    v4.vx = b.p1.x - w.p1.x;
    v4.vy = b.p1.y - w.p1.y;
    //check if we have hit side or endpoint
    dp = v4.vx*w.dx + v4.vy*w.dy;
    if(dp > 0) {
      //hits ending point
      return v4;
    }
    else {
      //it hits the wall
      //project this vector on the normal of the wall
      return projectVector(v3, w.ldx, w.ldy);
    }
  }
}


// find new vector of v0 bouncing from v1
Vector findBounceVector(Vector v0, Vector v1) {
  //projection of v0 on v1
  Vector proj1 = projectVector(v0, v1.dx, v1.dy);
  //projection of v0 on v1 normal
  Vector proj2 = projectVector(v0, v1.ldx, v1.ldy);//use unit vector's normal
  //reverse projecton on v1 normal
  proj2.length = sqrt(proj2.vx*proj2.vx + proj2.vy*proj2.vy);
  proj2.vx = v1.ldx * proj2.length;
  proj2.vy = v1.ldy * proj2.length;
  //add the projections
  Vector proj = new Vector();
  proj.vx = v0.f*v1.f*proj1.vx + v0.b*v1.b*proj2.vx;
  proj.vy = v0.f*v1.f*proj1.vy + v0.b*v1.b*proj2.vy;
  
  return proj;
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
 
 public void place() {
   fill(0);
   noStroke();
   ellipse(p1.x, p1.y, 4, 4);
   noFill();
   stroke(c);
   ellipse(p1.x, p1.y, r*2, r*2);
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
 public float x = 0;
 public float y = 0;
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
  public float length = 0;
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