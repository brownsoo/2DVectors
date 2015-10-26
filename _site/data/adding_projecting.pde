/**
 * Adding, Projecting 
 * by hyonsoo han
 *
 * Descripe vector's addtion and projection.
 * Checkout : brownsoo.github.io/vectors
 */

//dragging is true when the point is being dragged
boolean dragging = false;

Vector vector1;
Vector vector2;
Vector proj1;
Vector proj2;
Dragger dragger1;
Dragger dragger2;
Dragger dragger3;
Arrow arrow1;//vector 1
Arrow arrow2;//vector 2
Arrow arrow3;//projection
Arrow arrow4;//projection

void setup() {
  size(320, 300);
  // Pulling the display's density dynamically
  try {
    pixelDensity(displayDensity());
  } catch(Exception e){}
  background(255);
  
  //create first vector
  //point p0 is its starting point in the coordinates x/y
  //point p1 is its end point in the coordinates x/y
  vector1 = new Vector();
  vector1.p0 = new Point(150, 100);
  vector1.p1 = new Point(200, 150);
  //create second vector
  vector2 = new Vector();
  vector2.p0 = new Point(150, 100);
  vector2.p1 = new Point(150, 50);
  
  //Dragging Handler
  dragger1 = new Dragger(12);
  dragger2 = new Dragger(12);
  dragger3 = new Dragger(12);
  
  //Arrow graphics for vector
  arrow1 = new Arrow(0xff212121);//black: vector 1
  arrow2 = new Arrow(0xff9f9f9f);//gray: vector 2
  arrow3 = new Arrow(0xff4caf50);//green: perp vector of vector1 on vector2
  arrow4 = new Arrow(0xffff5252);//red : perp vector of voector1 on vector2's normal
  
  //calculate all parameters for the vector and draw it
  updateVector(vector1);
  updateVector(vector2);
  //find projections
  proj1 = projectVector(vector1, vector2.dx, vector2.dy);
  proj2 = projectVector(vector1, vector2.lx/vector2.length, vector2.ly/vector2.length);
  
  drawAll();
}

void draw() {
  runMe();
}

void mousePressed() {
  if(dragger1.contains(mouseX, mouseY)) {
    dragging = true;
    dragger1.pressed = true;
    dragger2.pressed = false;
    dragger3.pressed = false;
  }
  else if(dragger2.contains(mouseX, mouseY)) {    
    dragging = true;
    dragger1.pressed = false;
    dragger2.pressed = true;
    dragger3.pressed = false;
  }
  else if(dragger3.contains(mouseX, mouseY)) {    
    dragging = true;
    dragger1.pressed = false;
    dragger2.pressed = false;
    dragger3.pressed = true;
  }
  else {
    dragging = false;
  }
}
void mouseReleased() {
  dragging = false;
  dragger1.pressed = false;
  dragger2.pressed = false;
  dragger3.pressed = false;
  drawAll();
}

//main function
void runMe() {
  //check if point is dragged
  if (dragging) {
    //get the coordinates from draggers
    if(dragger1.pressed) {
      vector1.p0.x = mouseX;
      vector1.p0.y = mouseY;
      vector2.p0.x = mouseX;
      vector2.p0.y = mouseY;
    }
    if(dragger2.pressed) {
      vector1.p1.x = mouseX;
      vector1.p1.y = mouseY;
    }
    
    if(dragger3.pressed) {
      vector2.p1.x = mouseX;
      vector2.p1.y = mouseY;
    }
    
    updateVector(vector1);
    updateVector(vector2);
    
    //find projections
    proj1 = projectVector(vector1, vector2.dx, vector2.dy);
    proj2 = projectVector(vector1, vector2.lx/vector2.length, vector2.ly/vector2.length);
    drawAll();
    
  }
}

//function to draw the points, lines and show text
//this is only needed for the example to illustrate
void drawAll() {
  //clear all
  background(255);
  
  //Draw coordinte by vector 1
  pushMatrix();
  translate(vector2.p0.x, vector2.p0.y);
  rotate(atan2(vector2.vy, vector2.vx));
  stroke(0, 204, 255, 128);
  line(-1000, 0, 1000, 0);
  line(0, -1000, 0, 1000);
  popMatrix();
  
  //Draw Dragger
  dragger1.x = vector1.p0.x;
  dragger1.y = vector1.p0.y;
  dragger1.place();
  dragger2.x = vector1.p1.x;
  dragger2.y = vector1.p1.y;
  dragger2.place();
  dragger3.x = vector2.p1.x;
  dragger3.y = vector2.p1.y;
  dragger3.place();
  
  // vector 0's line
  stroke(arrow1.c);
  line(vector1.p0.x, vector1.p0.y, vector1.p1.x, vector1.p1.y);
  // vector 1's line
  stroke(arrow2.c);
  line(vector2.p0.x, vector2.p0.y, vector2.p1.x, vector2.p1.y);
  // project vector's line of vector1 on vector 1
  stroke(arrow3.c);
  line(vector1.p0.x, vector1.p0.y, 
        vector1.p0.x + proj1.vx, vector1.p0.y + proj1.vy);
  // project vector's line of vector1 on vector 1's normal
  stroke(arrow4.c);
  line(vector1.p0.x, vector1.p0.y, 
        vector1.p0.x + proj2.vx, vector1.p0.y + proj2.vy);
  
  //Draw arrows
  arrow1.x = vector1.p1.x;
  arrow1.y = vector1.p1.y;
  arrow1.rotation = atan2(vector1.vy, vector1.vx);
  arrow1.place();
  arrow2.x = vector2.p1.x;
  arrow2.y = vector2.p1.y;
  arrow2.rotation = atan2(vector2.vy, vector2.vx);
  arrow2.place();
  arrow3.x = vector1.p0.x + round(proj1.vx);
  arrow3.y = vector1.p0.y + round(proj1.vy);
  arrow3.rotation = atan2(proj1.vy, proj1.vx);
  arrow3.place();
  arrow4.x = vector1.p0.x + round(proj2.vx);
  arrow4.y = vector1.p0.y + round(proj2.vy);
  arrow4.rotation = atan2(proj2.vy, proj2.vx);
  arrow4.place();
  
  //text
  fill(arrow1.c);
  text("v1", arrow1.x + 5, arrow1.y);
  fill(arrow2.c);
  text("v2", arrow2.x + 5, arrow2.y);
  fill(arrow3.c);
  text("Proj on v2", arrow3.x + 5, arrow3.y);
  fill(arrow4.c);
  text("Proj on v2's normal", arrow4.x + 5, arrow4.y);
  
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