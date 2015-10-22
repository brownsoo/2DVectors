/**
 * Moving with Vector 
 * by hyonsoo han
 *
 * Show how to use vector to move object.
 * Checkout : brownsoo.github.io/vectors
 */

//dragging is true when the point is being dragged
boolean dragging = false;

Vector vector0;
Vector vector1;
Vector proj0;
Vector proj1;
Dragger dragger0;
Dragger dragger1;
Dragger dragger2;
Arrow arrow0;//vector 0
Arrow arrow1;//vector 1
Arrow arrow2;//projection
Arrow arrow3;//projection

void setup() {
  size(320, 300);
  background(255);
  
  //create first vector
  //point p0 is its starting point in the coordinates x/y
  //point p1 is its end point in the coordinates x/y
  vector0 = new Vector();
  vector0.p0 = new Point(150, 100);
  vector0.p1 = new Point(200, 150);
  //create second vector
  vector1 = new Vector();
  vector1.p0 = new Point(150, 100);
  vector1.p1 = new Point(150, 50);
  
  //Dragging Handler
  dragger0 = new Dragger(12);
  dragger1 = new Dragger(12);
  dragger2 = new Dragger(12);
  
  //Arrow graphics for vector
  arrow0 = new Arrow(0xff212121);//black: vector 0
  arrow1 = new Arrow(0xff9f9f9f);//gray: vector 1
  arrow2 = new Arrow(0xff4caf50);//green: perp vector of vector0 on vector1
  arrow3 = new Arrow(0xffff5252);//red : perp vector of voector0 on vector1's normal
  
  //calculate all parameters for the vector and draw it
  updateVector(vector0);
  updateVector(vector1);
  //find projections
  proj0 = projectVector(vector0, vector1.dx, vector1.dy);
  proj1 = projectVector(vector0, vector1.lx/vector1.length, vector1.ly/vector1.length);
  
  drawAll();
}

void draw() {
  runMe();
}

void mousePressed() {
  if(dragger0.contains(mouseX, mouseY)) {
    dragging = true;
    dragger0.pressed = true;
    dragger1.pressed = false;
    dragger2.pressed = false;
  }
  else if(dragger1.contains(mouseX, mouseY)) {    
    dragging = true;
    dragger0.pressed = false;
    dragger1.pressed = true;
    dragger2.pressed = false;
  }
  else if(dragger2.contains(mouseX, mouseY)) {    
    dragging = true;
    dragger0.pressed = false;
    dragger1.pressed = false;
    dragger2.pressed = true;
  }
  else {
    dragging = false;
  }
}
void mouseMoved() {
  mouseMove = true;
}
void mouseReleased() {
  dragging = false;
  dragger0.pressed = false;
  dragger1.pressed = false;
  dragger2.pressed = false;
  mouseMove = false;
  drawAll();
}
boolean mouseMove = false;

//main function
void runMe() {
  //check if point is dragged
  if (dragging || mouseMove) {
    //get the coordinates from draggers
    if(dragger0.pressed) {
      vector0.p0.x = mouseX;
      vector0.p0.y = mouseY;
      vector1.p0.x = mouseX;
      vector1.p0.y = mouseY;
    }
    if(dragger1.pressed) {
      vector0.p1.x = mouseX;
      vector0.p1.y = mouseY;
    }
    
    if(dragger2.pressed) {
      vector1.p1.x = mouseX;
      vector1.p1.y = mouseY;
    }
    
    updateVector(vector0);
    updateVector(vector1);
    
    //find projections
    proj0 = projectVector(vector0, vector1.dx, vector1.dy);
    proj1 = projectVector(vector0, vector1.lx/vector1.length, vector1.ly/vector1.length);
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
  translate(vector1.p0.x, vector1.p0.y);
  rotate(atan2(vector1.vy, vector1.vx));
  stroke(0, 204, 255, 128);
  line(-1000, 0, 1000, 0);
  stroke(0, 102, 255, 128);
  line(0, -1000, 0, 1000);
  popMatrix();
  
  //Draw Dragger
  dragger0.x = vector0.p0.x;
  dragger0.y = vector0.p0.y;
  dragger0.place();
  dragger1.x = vector0.p1.x;
  dragger1.y = vector0.p1.y;
  dragger1.place();
  dragger2.x = vector1.p1.x;
  dragger2.y = vector1.p1.y;
  dragger2.place();
  
  // vector 0's line
  stroke(arrow0.c);
  line(vector0.p0.x, vector0.p0.y, vector0.p1.x, vector0.p1.y);
  // vector 1's line
  stroke(arrow1.c);
  line(vector1.p0.x, vector1.p0.y, vector1.p1.x, vector1.p1.y);
  // project vector's line of vector0 on vector 1
  stroke(arrow2.c);
  line(vector0.p0.x, vector0.p0.y, 
        vector0.p0.x + proj0.vx, vector0.p0.y + proj0.vy);
  // project vector's line of vector0 on vector 1's normal
  stroke(arrow3.c);
  line(vector0.p0.x, vector0.p0.y, 
        vector0.p0.x + proj1.vx, vector0.p0.y + proj1.vy);
  
  //Draw arrows
  arrow0.x = vector0.p1.x;
  arrow0.y = vector0.p1.y;
  arrow0.rotation = atan2(vector0.vy, vector0.vx);
  arrow0.place();
  arrow1.x = vector1.p1.x;
  arrow1.y = vector1.p1.y;
  arrow1.rotation = atan2(vector1.vy, vector1.vx);
  arrow1.place();
  arrow2.x = vector0.p0.x + round(proj0.vx);
  arrow2.y = vector0.p0.y + round(proj0.vy);
  arrow2.rotation = atan2(proj0.vy, proj0.vx);
  arrow2.place();
  arrow3.x = vector0.p0.x + round(proj1.vx);
  arrow3.y = vector0.p0.y + round(proj1.vy);
  arrow3.rotation = atan2(proj1.vy, proj1.vx);
  arrow3.place();
  
  //text
  fill(arrow0.c);
  text("v1", arrow0.x + 5, arrow0.y);
  fill(arrow1.c);
  text("v2", arrow1.x + 5, arrow1.y);
  fill(arrow2.c);
  text("Proj on v2", arrow2.x + 5, arrow2.y);
  fill(arrow3.c);
  text("Proj on v2's normal", arrow3.x + 5, arrow3.y);
  
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
  public int x;
  public int y;
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
 public int x;
 public int y;
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
 public int x;
 public int y;
 Point(){}
 Point(int x0, int y0) {
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