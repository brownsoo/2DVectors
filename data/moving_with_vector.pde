/**
 * Moving with Vector 
 * by hyonsoo han
 *
 * Show how to use vector to move object.
 * Checkout : brownsoo.github.io/2DVectors
 * Apache License 2.0 - http://www.apache.org/licenses/LICENSE-2.0
 */

//scale is to convert between stage coordinates
final int scale = 10;
final int maxV = 10;
Ball ball;

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
  ball.vx = 3;
  ball.vy = 1;
}

void draw() {
  runMe();
}

void keyPressed() {
  if (key == CODED) {
    if(keyCode == LEFT && ball.vx > -maxV) {
      //reduce x velocity
      ball.vx--;
    }
    else if(keyCode == RIGHT && ball.vx < maxV) {
      //increase x velocity
      ball.vx++;
    }
    else if (keyCode == UP && ball.vy > -maxV) {
      //reduce y velocity
      ball.vy--;
    } 
    else if (keyCode == DOWN && ball.vy < maxV) {
      //increase y velocity
      ball.vy++;
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
  text("vx:"+ball.vx + " vy:" + ball.vy, 10, 20);
}

//function to find all parameters for the ball vector 
//with using start point and vx/vy, time
void updateBall(Ball v) {
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