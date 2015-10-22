/**
 * Length. Normals 
 * by hyonsoo han
 *
 * Show vector's length and normal vectors.
 * Checkout : brownsoo.github.io/vectors
 */


//scale is to convert between stage coordinates
final int scale = 10;

//dragging is true when the point is being dragged
boolean dragging = false;

Vector vector;
Dragger dragger0;
Dragger dragger1;
Arrow arrow0;//vector
Arrow arrow1;//unit vector
Arrow arrow2;//right normal
Arrow arrow3;//left normal

void setup() {
  size(400, 300);
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
  dragger0 = new Dragger(12);
  dragger1 = new Dragger(12);
  dragger0.x = scale * vector.p0.x;
  dragger0.y = scale * vector.p0.y;
  dragger1.x = scale * vector.p1.x;
  dragger1.y = scale * vector.p1.y;
  
  //Arrow graphics for vector
  arrow0 = new Arrow(0xff212121);//black
  arrow1 = new Arrow(0xff2196f3);//blue
  arrow2 = new Arrow(0xff4caf50);//green
  arrow3 = new Arrow(0xffff5252);//red
  
  //calculate all parameters for the vector and draw it
  updateVector(vector);
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
  }
  else if(dragger1.contains(mouseX, mouseY)) {    
    dragging = true;
    dragger0.pressed = false;
    dragger1.pressed = true;
  }
  else {
    dragging = false;
    dragger0.pressed = false;
    dragger1.pressed = false;
  }
}
void mouseReleased() {
  dragging = false;
  dragger0.pressed = false;
  dragger1.pressed = false;
  drawAll();
}

//main function
void runMe() {
  //check if point is dragged
  if (dragging) {
    
    //Snap the dragger with grid
    if(dragger0.pressed) {
      dragger0.x = round(mouseX / scale) * scale;
      dragger0.y = round(mouseY / scale) * scale;
    }
    else {
      dragger1.x = round(mouseX / scale) * scale;
      dragger1.y = round(mouseY / scale) * scale;
    }
    
    Vector v = vector;
    //get the coordinates from draggers
    v.p0.x = round(dragger0.x / scale);
    v.p0.y = round(dragger0.y / scale);
    v.p1.x = round(dragger1.x / scale);
    v.p1.y = round(dragger1.y / scale);
    
    //calculate new parameters for the vector and draw
    updateVector(v);
    drawAll();
    
  }
}

//function to draw the points, lines and show text
//this is only needed for the example to illustrate
void drawAll() {
  //clear all
  background(255);
  
  //draw grid
  stroke(208);
  strokeWeight(1);
  for(int i=0; i<width; i+=scale) {
    line(i, 0, i, height);
  }
  for(int j=0; j<height; j+=scale) {
    line(0, j, width, j);  
  }
  
  //Draw Dragger
  dragger0.place();
  dragger1.place();
  
  Vector v = vector;
  // vector's line
  stroke(arrow0.c);
  line(v.p0.x * scale, v.p0.y * scale, 
      v.p1.x * scale, v.p1.y * scale);
  
  //unit vector's line
  stroke(arrow1.c);
  line(v.p0.x * scale, v.p0.y * scale, 
      (v.p0.x+v.dx) * scale, (v.p0.y+v.dy) * scale);
  
  //right normal's line
  stroke(arrow2.c);
  line(v.p0.x * scale, v.p0.y * scale, 
      (v.p0.x+v.rx) * scale, (v.p0.y+v.ry) * scale);    

  //left normal's line
  stroke(arrow3.c);
  line(v.p0.x * scale, v.p0.y * scale, 
      (v.p0.x+v.lx) * scale, (v.p0.y+v.ly) * scale);
  
  //Draw arrows
  arrow0.x = v.p1.x * scale;
  arrow0.y = v.p1.y * scale;
  arrow0.rotation = atan2(v.vy, v.vx);
  arrow1.x = int((v.p0.x+v.dx) * scale);
  arrow1.y = int((v.p0.y+v.dy) * scale);
  arrow1.rotation = atan2(v.dy, v.dx);
  arrow2.x = int((v.p0.x+v.rx) * scale);
  arrow2.y = int((v.p0.y+v.ry) * scale);
  arrow2.rotation = atan2(v.ry, v.rx);
  arrow3.x = int((v.p0.x+v.lx) * scale);
  arrow3.y = int((v.p0.y+v.ly) * scale);
  arrow3.rotation = atan2(v.ly, v.lx);
  
  arrow0.place();
  arrow1.place();
  arrow2.place();
  arrow3.place();
  
  //text
  fill(arrow0.c);
  text("vector", arrow0.x + 5, arrow0.y);
  fill(arrow2.c);
  text("R normal", (vector.p0.x * scale  + arrow2.x) * 0.5 + 5, (vector.p0.y * scale + arrow2.y) * 0.5 + 5);
  fill(arrow3.c);
  text("L normal", (vector.p0.x * scale  + arrow3.x) * 0.5 + 5, (vector.p0.y * scale + arrow3.y) * 0.5 + 5);
  
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
}