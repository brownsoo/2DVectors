/**
 * Length. Normals 
 * by hyonsoo han
 *
 * Show vector's length and normal vectors.
 * Checkout : brownsoo.github.io/2DVectors
 * Apache License 2.0 - http://www.apache.org/licenses/LICENSE-2.0
 */

final int _GREEN = 0xff4CAF50;
final int _RED = 0xffFF5252;
final int _BLUE = 0xff03A9F4;
final int _GRAY = 0xff757575;
final int _BLACK = 0xff212121;

//scale is to convert between stage coordinates
final int scale = 10;

//dragging is true when the point is being dragged
boolean dragging = false;

Vector vector;
Dragger dragger1;
Dragger dragger2;
Arrow arrow1;//vector
Arrow arrow2;//unit vector
Arrow arrow3;//right normal
Arrow arrow4;//left normal

void setup() {
  size(320, 300);
  // Pulling the display's density dynamically
  try {
    pixelDensity(displayDensity());
  } catch(Exception e){}
  background(255);
  
  //create vector
  //point p0 is its starting point in the coordinates x/y
  //vx, vy are vectors components
  vector = new Vector();
  vector.p0 = new Point(15, 10);
  vector.vx = 4;
  vector.vy = 3;
  
  //find end point
  vector.p1 = new Point();
  vector.p1.x = int(vector.p0.x + vector.vx);
  vector.p1.y = int(vector.p0.y + vector.vy);
  
  //Dragging Handler
  dragger1 = new Dragger();
  dragger2 = new Dragger();
  dragger1.x = scale * vector.p0.x;
  dragger1.y = scale * vector.p0.y;
  dragger2.x = scale * vector.p1.x;
  dragger2.y = scale * vector.p1.y;
  
  //Arrow graphics for vector
  arrow1 = new Arrow(_BLACK);
  arrow2 = new Arrow(_BLUE);
  arrow3 = new Arrow(_GREEN);
  arrow4 = new Arrow(_RED);
  
  //calculate all parameters for the vector and draw it
  updateVector(vector);
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
  }
  else if(dragger2.contains(mouseX, mouseY)) {    
    dragging = true;
    dragger1.pressed = false;
    dragger2.pressed = true;
  }
  else {
    dragging = false;
    dragger1.pressed = false;
    dragger2.pressed = false;
  }
}
void mouseReleased() {
  dragging = false;
  dragger1.pressed = false;
  dragger2.pressed = false;
  drawAll();
}

//main function
void runMe() {
  //check if point is dragged
  if (dragging) {
    
    //Snap the dragger with grid
    if(dragger1.pressed) {
      dragger1.x = round(mouseX / scale) * scale;
      dragger1.y = round(mouseY / scale) * scale;
    }
    else {
      dragger2.x = round(mouseX / scale) * scale;
      dragger2.y = round(mouseY / scale) * scale;
    }
    
    Vector v = vector;
    //get the coordinates from draggers
    v.p0.x = round(dragger1.x / scale);
    v.p0.y = round(dragger1.y / scale);
    v.p1.x = round(dragger2.x / scale);
    v.p1.y = round(dragger2.y / scale);
    
    //calculate new parameters for the vector and draw
    updateVector(v);
  }
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
  
  //Draw Dragger
  dragger1.place();
  dragger2.place();
  
  Vector v = vector;
  // vector's line
  stroke(arrow1.c);
  line(v.p0.x * scale, v.p0.y * scale, 
      v.p1.x * scale, v.p1.y * scale);
  
  //unit vector's line
  stroke(arrow2.c);
  line(v.p0.x * scale, v.p0.y * scale, 
      (v.p0.x+v.dx) * scale, (v.p0.y+v.dy) * scale);
  
  //right normal's line
  stroke(arrow3.c);
  line(v.p0.x * scale, v.p0.y * scale, 
      (v.p0.x+v.rx) * scale, (v.p0.y+v.ry) * scale);    

  //left normal's line
  stroke(arrow4.c);
  line(v.p0.x * scale, v.p0.y * scale, 
      (v.p0.x+v.lx) * scale, (v.p0.y+v.ly) * scale);
  
  //Draw arrows
  arrow1.x = v.p1.x * scale;
  arrow1.y = v.p1.y * scale;
  arrow1.rotation = atan2(v.vy, v.vx);
  arrow2.x = (v.p0.x+v.dx) * scale;
  arrow2.y = (v.p0.y+v.dy) * scale;
  arrow2.rotation = atan2(v.dy, v.dx);
  arrow3.x = (v.p0.x+v.rx) * scale;
  arrow3.y = (v.p0.y+v.ry) * scale;
  arrow3.rotation = atan2(v.ry, v.rx);
  arrow4.x = (v.p0.x+v.lx) * scale;
  arrow4.y = (v.p0.y+v.ly) * scale;
  arrow4.rotation = atan2(v.ly, v.lx);
  
  arrow1.place();
  arrow2.place();
  arrow3.place();
  arrow4.place();
  
  //text
  fill(arrow1.c);
  text("vector", arrow1.x + 5, arrow1.y);
  fill(arrow3.c);
  text("R normal", (vector.p0.x * scale  + arrow3.x) * 0.5 + 5, (vector.p0.y * scale + arrow3.y) * 0.5 + 5);
  fill(arrow4.c);
  text("L normal", (vector.p0.x * scale  + arrow4.x) * 0.5 + 5, (vector.p0.y * scale + arrow4.y) * 0.5 + 5);
  
  fill(45);
  text("p0: x="+v.p0.x+", y="+v.p0.y, 10, 20);
  text("p1: x="+v.p1.x+", y="+v.p1.y, 10, 35);
  text("vx: "+v.vx+", vy: "+v.vy, 10, 50);
  String len = roundMe(v.length);
  text("length: "+len, 10, 65);
  String dx = roundMe(v.dx);
  String dy = roundMe(v.dy);
  text("dx: "+dx+", dy: "+dy, 10, 80);
  text("rx: "+v.rx+", ry: "+v.ry, 10, 95);
  text("lx: "+v.lx+", ly: "+v.ly, 10, 110);
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
}