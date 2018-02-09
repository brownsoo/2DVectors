/**
 * Ball in the corner 
 * by hyonsoo han
 *
 * Shows how to interact ball in the corner
 * Checkout : brownsoo.github.io/2DVectors
 * Apache License 2.0 - http://www.apache.org/licenses/LICENSE-2.0
 */

final int _GREEN = 0xff4CAF50;
final int _RED = 0xffFF5252;
final int _BLUE = 0xff03A9F4;
final int _GRAY = 0xff757575;
final int _BLACK = 0xff212121;

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
  ball = new Ball(_BLACK, 60);
  ball.p1 = new Point(150, 120);
  
  //create wall vectors
  vectors = new Vector[3];
  vectors[0] = new Vector(new Point(50, 170), new Point(250, 170));//wall
  vectors[1] = new Vector();//Backward vector
  vectors[2] = new Vector();//closest line from ball to wall
  
  //calculate all parameters for the vector and draw it
  updateVector(vectors[0], true);
  
  //Dragging Handler
  draggers = new Dragger[3];
  for(int i=0; i<draggers.length; i++) {
    draggers[i] = new Dragger();
  }
  //Arrow graphics for vector
  arrows = new Arrow[3];
  arrows[0] = new Arrow(_RED);//wall
  arrows[1] = new Arrow(_GRAY);//closest line
  arrows[2] = new Arrow(_BLUE);//backward line
  
  
  resetBt = new SimpleButton("Reset");
  resetBt.x = 10;
  resetBt.y = height - 50;
  resetBt.setCallback(new OnButtonClick());
  
}

class OnButtonClick implements ButtonCallback {
  void onClick(SimpleButton b) {
    //println(b.label + " click");
    ball.p1.x = 150;
    ball.p1.y = 80;
    vectors[0] = new Vector(new Point(50, 170), new Point(250, 170));//wall
    //calculate all parameters for the vector and draw it
    updateVector(vectors[0], true);
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
    ball.p1.x = draggers[0].x;
    ball.p1.y = draggers[0].y;
    vectors[0].p0.x = draggers[1].x;
    vectors[0].p0.y = draggers[1].y;
    vectors[0].p1.x = draggers[2].x;
    vectors[0].p1.y = draggers[2].y;
    updateVector(vectors[0], true);
  }
  // start to calculate movement
  // check the wall form colliosions
  Vector wall = vectors[0];
  Vector v = findBackwardVector(ball, wall);
  updateVector(v, false);//to get length, dx, dy 
  float pen = ball.r - v.length;
  //if we have hit the wall
  if(pen >= 0) {
    //move object away from colliosion point
    vectors[2].vx = v.dx * pen;
    vectors[2].vy = v.dy * pen;
  }
  else {
    //hide this vector so the example look nicer
    vectors[2].vx = 0;
    vectors[2].vy = 0;
  }
  
  vectors[2].p0.x = ball.p1.x;
  vectors[2].p0.y = ball.p1.y;
  updateVector(vectors[2], false);
  
  //drawing the line which shows closest distance to the wall
  v.p0.x = ball.p1.x - v.vx;
  v.p0.y = ball.p1.y - v.vy;
  updateVector(v, false);//to get correct p1
  vectors[1] = v;
  
  //draw it
  drawAll();
}

//function to draw the points, lines and show text
//this is only needed for the example to illustrate
void drawAll() {
  //clear all
  background(255);
  
  //place ball
  ball.place();
  
  //Draw Dragger
  draggers[0].x = ball.p1.x;
  draggers[0].y = ball.p1.y;
  draggers[0].place();
  draggers[1].x = vectors[0].p0.x;
  draggers[1].y = vectors[0].p0.y;
  draggers[1].place();
  draggers[2].x = vectors[0].p1.x;
  draggers[2].y = vectors[0].p1.y;
  draggers[2].place();
  
  // vector line
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
  } else {
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