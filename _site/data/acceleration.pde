/**
 * Acceleration 
 * by hyonsoo han
 *
 * Shows how to use vector to move object with acceleration.
 * Checkout : brownsoo.github.io/2DVectors
 * Apache License 2.0 - http://www.apache.org/licenses/LICENSE-2.0
 */

//scale is to convert between stage coordinates
final int scale = 10;
final int maxV = 10; // speed limit
final int maxA = 1; // acceleration limit
//Object to move
Ball ball;
//reset button
SimpleButton resetBt;

void setup() {
  size(320, 300);
  // Pulling the display's density dynamically
  try {
    pixelDensity(displayDensity());
  } catch(Exception e){}
  background(255);
  //create object
  ball = new Ball(0xffff5252, 10);
  //point p0 is its starting point in the coordinates x/y
  ball.p0 = new Point(150, 100);
  //vector x/y components
  ball.vx = 0;
  ball.vy = 0;
  ball.ax = 0;
  ball.ay = 0;
  
  resetBt = new SimpleButton("Reset");
  resetBt.x = 10;
  resetBt.y = height - 50;
  resetBt.setCallback(new OnButtonClick());
  
}

void draw() {
  runMe();
  resetBt.place();
}

class OnButtonClick implements ButtonCallback {
  void onClick(SimpleButton b) {
    //println(b.label + " click");
    ball.p0.x = 150;
    ball.p0.y = 100;
    ball.vx = 0;
    ball.vy = 0;
    ball.ax = 0;
    ball.ay = 0;
  }
}


void keyPressed() {
  if (key == CODED) {
    if(keyCode == LEFT && ball.ax > -maxA) {
      //reduce x acceleration
      ball.ax -= 0.01f;
    }
    else if(keyCode == RIGHT && ball.ax < maxA) {
      //increase x acceleration
      ball.ax += 0.01f;
    }
    else if (keyCode == UP && ball.ay > -maxA) {
      //reduce y acceleration
      ball.ay -= 0.01f;
    } 
    else if (keyCode == DOWN && ball.ay < maxA) {
      //increase y acceleration
      ball.ay += 0.01f;
    } 
  }
}

//main function
void runMe() {
  
  //update the vector parameters
  updateBall(ball);
  
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
  
  //place object
  ball.place();
  //make end point equal to starting point for next cycle
  ball.p0 = ball.p1;
  //show the vectors components
  noStroke();
  fill(25);
  text("vx:"+roundMe(ball.vx) + " vy:" + roundMe(ball.vy), 10, 20);
  text("ax:"+roundMe(ball.ax) + " ay:" + roundMe(ball.ay), 10, 35);
}

//function to find all parameters for the ball vector 
//with using start point and vx/vy, time
void updateBall(Ball v) {
  //update the speed vector with acceleration
  if(abs(v.vx+v.ax) < maxV) {
    v.vx = v.vx + v.ax;
  }
  if(abs(v.vy+v.ay) < maxV) {
    v.vy = v.vy + v.ay;
  }
  
  //find time passed from last update
  int thisTime = millis();
  float time = (thisTime - v.lastTime)/1000f*scale;
  //find end point coordinates
  v.p1 = new Point();//new creation for changing point.
  v.p1.x = v.p0.x + v.vx * time;
  v.p1.y = v.p0.y + v.vy * time;
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
}


//function to round up numbers to x.xx format
//has nothing to do with vectors, only to show nice numbers in the example
String roundMe(float num) {
  if(abs(num) < 0.001f) {
    return "0";
  }
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
 
 Ball(int color0, float size0){
   super();
   this.c = color0;
   this.size = size0 / 2;
 }
 
 public void place() {
   fill(c);
   noStroke();
   ellipse(p1.x, p1.y, size, size);
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
  public float ax;
  public float ay;
  public float vx;
  public float vy;
  public float rx;
  public float ry;
  public float lx;
  public float ly;
  public float dx;
  public float dy;
  public float length;  
   
  public Vector() {
    p0 = new Point();
    p1 = new Point();
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