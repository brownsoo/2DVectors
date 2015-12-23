/**
 * Intersection 
 * by hyonsoo han
 *
 * Shows two vector's intersection.
 * Checkout : brownsoo.github.io/vectors
 */

//dragging is true when the point is being dragged
boolean dragging = false;

Vector vector1;
Vector vector2;
Vector vector3;
Point ip;//intersection point
Dragger[] draggers;
Arrow arrow1;
Arrow arrow2;
Arrow arrow3;

void setup() {
  size(320, 300);
  // Pulling the display's density dynamically
  try {
    pixelDensity(displayDensity());
  } catch(Exception e){}
  //create first vector
  //point p0 is its starting point in the coordinates x/y
  //point p1 is its end point in the coordinates x/y
  vector1 = new Vector();
  vector1.p0 = new Point(150, 50);
  vector1.p1 = new Point(150, 100);
  //create second vector
  //point p0 is its starting point in the coordinates x/y
  //point p1 is its end point in the coordinates x/y
  vector2 = new Vector();
  vector2.p0 = new Point(100, 150);
  vector2.p1 = new Point(200, 150);
  
  //Dragging Handler
  draggers = new Dragger[4];
  for(int i=0; i<draggers.length; i++) {
    draggers[i] = new Dragger(12);
  }
  //Arrow graphics for vector
  arrow1 = new Arrow(0xff4CAF50);//green: v0 - object
  arrow2 = new Arrow(0xffFF5252);//red: v1 - wall
  arrow3 = new Arrow(0xff03A9F4);//blue : vector between v0.p0->v1.p0
  
  //calculate all parameters for the vector and draw it
  updateVector(vector1);
  updateVector(vector2);
  
  vector3 = new Vector();
  vector3.p0 = vector1.p0;
  vector3.p1 = vector2.p0;
  updateVector(vector3);
  findIntersection(vector1, vector2);
  
  drawAll();
}

void draw() {
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
  drawAll();
}

//main function
void runMe() {
  //check if point is dragged
  if (dragging) {
    
    for(int i=0; i<draggers.length; i++) {
      if(draggers[i].pressed) {
        draggers[i].x = mouseX;
        draggers[i].y = mouseY;
      }
    }
    
    //get the coordinates from draggers
    vector1.p0.x = draggers[0].x;
    vector1.p0.y = draggers[0].y;
    vector1.p1.x = draggers[1].x;
    vector1.p1.y = draggers[1].y;
    updateVector(vector1);
    
    vector2.p0.x = draggers[2].x;
    vector2.p0.y = draggers[2].y;
    vector2.p1.x = draggers[3].x;
    vector2.p1.y = draggers[3].y;
    updateVector(vector2);
    
    vector3 = new Vector();
    vector3.p0 = vector1.p0;
    vector3.p1 = vector2.p0;
    updateVector(vector3);
    findIntersection(vector1, vector2);
    
    drawAll();
  }
}

//function to draw the points, lines and show text
//this is only needed for the example to illustrate
void drawAll() {
  //clear all
  background(255);
  
  //Draw coordinte by vector 2
  pushMatrix();
  translate(vector2.p0.x, vector2.p0.y);
  rotate(atan2(vector2.vy, vector2.vx));
  stroke(0, 58);
  line(-1000, 0, 1000, 0);
  line(0, -1000, 0, 1000);
  popMatrix();
  
  //Draw Dragger
  draggers[0].x = vector1.p0.x;
  draggers[0].y = vector1.p0.y;
  draggers[0].place();
  draggers[1].x = vector1.p1.x;
  draggers[1].y = vector1.p1.y;
  draggers[1].place();
  draggers[2].x = vector2.p0.x;
  draggers[2].y = vector2.p0.y;
  draggers[2].place();
  draggers[3].x = vector2.p1.x;
  draggers[3].y = vector2.p1.y;
  draggers[3].place();
  
  // vector 1's line
  stroke(arrow1.c);
  line(vector1.p0.x, vector1.p0.y, vector1.p1.x, vector1.p1.y);
  // vector 2's line
  stroke(arrow2.c);
  line(vector2.p0.x, vector2.p0.y, vector2.p1.x, vector2.p1.y);
  // vector 3's line
  stroke(arrow3.c);
  line(vector1.p0.x, vector1.p0.y, 
        vector1.p0.x + vector3.vx, vector1.p0.y + vector3.vy);
  
  //Draw arrows
  arrow1.x = vector1.p1.x;
  arrow1.y = vector1.p1.y;
  arrow1.rotation = atan2(vector1.vy, vector1.vx);
  arrow1.place();
  arrow2.x = vector2.p1.x;
  arrow2.y = vector2.p1.y;
  arrow2.rotation = atan2(vector2.vy, vector2.vx);
  arrow2.place();
  arrow3.x = vector1.p0.x + round(vector3.vx);
  arrow3.y = vector1.p0.y + round(vector3.vy);
  arrow3.rotation = atan2(vector3.vy, vector3.vx);
  arrow3.place();
  
  //Draw intersection
  noStroke();
  fill(255, 0, 0, 178);
  ellipse(ip.x, ip.y, 6, 6);
  
  //text
  fill(arrow1.c);
  text("v1", vector1.p1.x + 5, vector1.p1.y + 10);
  fill(arrow2.c);
  text("v2", vector2.p1.x + 5, vector2.p1.y + 10);
  fill(arrow3.c);
  text("v3", (vector3.p0.x + vector3.p1.x)/2 + 5, (vector3.p0.y + vector3.p1.y)/2);
  fill(35);
  text("interaction point", (ip.x + ip.x)/2 + 5, (ip.y + ip.y)/2 - 5);
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

//find intersection point of 2 vectors
void findIntersection(Vector v0, Vector v1) {
  //vector between starting points
  Vector v = new Vector();
  v.vx = v1.p0.x - v0.p0.x;
  v.vy = v1.p0.y - v0.p0.y;
  float t;
  if((v0.dx == v1.dx && v0.dy == v1.dy) ||
    (v0.dx == -v1.dx && v0.dy == -v1.dy)) {
    t = 1000000;
  }
  else {
    t = perP(v, v1) / perP(v0, v1);
  }
  //intersection
  ip = new Point();
  ip.x = int(v0.p0.x + v0.vx*t);
  ip.y = int(v0.p0.y + v0.vy*t);
}

//calculate perp product of 2 vectors
float perP(Vector v0, Vector v1) {
  return v0.vx*v1.vy - v0.vy*v1.vx;
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