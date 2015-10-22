/**
 * Length. Normals 
 * by hyonsoo han
 *
 * Show vector's length and normal vectors.
 * Checkout : brownsoo.github.io/vectors
 */


//scaling is to convert between stage coordinates
var scaling = 10;

//dragging is true when the point is being dragged
var dragging = false;

var vector;
var dragger0;
var dragger1;
var arrow0;//vector
var arrow1;//unit vector
var arrow2;//right normal
var arrow3;//left normal

function setup() {
  createCanvas(320, 300);
  background(255);
  
  //create vector
  //point p0 is its starting point in the coordinates x/y
  //vx, vy are vectors components
  vector = newVector();
  vector.p0 = newPoint(15, 10);
  vector.vx = 4;
  vector.vy = 3;
  
  //find end point
  vector.p1.x = (vector.p0.x + vector.vx);
  vector.p1.y = (vector.p0.y + vector.vy);
  
  //Dragging Handler
  dragger0 = newDragger(16);
  dragger1 = newDragger(16);
  dragger0.x = scaling * vector.p0.x;
  dragger0.y = scaling * vector.p0.y;
  dragger1.x = scaling * vector.p1.x;
  dragger1.y = scaling * vector.p1.y;
  
  //Arrow graphics for vector
  arrow0 = newArrow("#212121");//black
  arrow1 = newArrow("#2196f3");//blue
  arrow2 = newArrow("#4caf50");//green
  arrow3 = newArrow("#ff5252");//red
  
  //calculate all parameters for the vector and draw it
  updateVector(vector);
  drawAll();
}

function draw() {
  runMe();
}

function touchStarted() {
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
  
  return false;
}
function touchEnded() {
  dragging = false;
  dragger0.pressed = false;
  dragger1.pressed = false;
  drawAll();
  
  return false;
}

//main function
function runMe() {
  //check if point is dragged
  if (dragging) {
    
    //Snap the dragger with grid
    if(dragger0.pressed) {
      dragger0.x = round(mouseX / scaling) * scaling;
      dragger0.y = round(mouseY / scaling) * scaling;
    }
    else {
      dragger1.x = round(mouseX / scaling) * scaling;
      dragger1.y = round(mouseY / scaling) * scaling;
    }
    
    var v = vector;
    //get the coordinates from draggers
    v.p0.x = round(dragger0.x / scaling);
    v.p0.y = round(dragger0.y / scaling);
    v.p1.x = round(dragger1.x / scaling);
    v.p1.y = round(dragger1.y / scaling);
    
    //calculate new parameters for the vector and draw
    updateVector(v);
    drawAll();
    
  }
}

//function to draw the points, lines and show text
//this is only needed for the example to illustrate
function drawAll() {
  //clear all
  background(255);
  
  //draw grid
  stroke(208);
  strokeWeight(1);
  for(var i=0; i<width; i+=scaling) {
    line(i, 0, i, height);
  }
  for(var j=0; j<height; j+=scaling) {
    line(0, j, width, j);  
  }
  
  //Draw Dragger
  dragger0.place();
  dragger1.place();
  
  var v = vector;
  // vector's line
  stroke(arrow0.c);
  line(v.p0.x * scaling, v.p0.y * scaling, 
      v.p1.x * scaling, v.p1.y * scaling);
  
  //unit vector's line
  stroke(arrow1.c);
  line(v.p0.x * scaling, v.p0.y * scaling, 
      (v.p0.x+v.dx) * scaling, (v.p0.y+v.dy) * scaling);
  
  //right normal's line
  stroke(arrow2.c);
  line(v.p0.x * scaling, v.p0.y * scaling, 
      (v.p0.x+v.rx) * scaling, (v.p0.y+v.ry) * scaling);    

  //left normal's line
  stroke(arrow3.c);
  line(v.p0.x * scaling, v.p0.y * scaling, 
      (v.p0.x+v.lx) * scaling, (v.p0.y+v.ly) * scaling);
  
  //Draw arrows
  arrow0.x = v.p1.x * scaling;
  arrow0.y = v.p1.y * scaling;
  arrow0.rotation = atan2(v.vy, v.vx);
  arrow1.x = int((v.p0.x+v.dx) * scaling);
  arrow1.y = int((v.p0.y+v.dy) * scaling);
  arrow1.rotation = atan2(v.dy, v.dx);
  arrow2.x = int((v.p0.x+v.rx) * scaling);
  arrow2.y = int((v.p0.y+v.ry) * scaling);
  arrow2.rotation = atan2(v.ry, v.rx);
  arrow3.x = int((v.p0.x+v.lx) * scaling);
  arrow3.y = int((v.p0.y+v.ly) * scaling);
  arrow3.rotation = atan2(v.ly, v.lx);
  
  arrow0.place();
  arrow1.place();
  arrow2.place();
  arrow3.place();
  
  //text
  noStroke();
  fill(arrow0.c);
  text("vector", arrow0.x + 5, arrow0.y);
  fill(arrow2.c);
  text("R normal", (vector.p0.x * scaling  + arrow2.x) * 0.5 + 5, (vector.p0.y * scaling + arrow2.y) * 0.5 + 5);
  fill(arrow3.c);
  text("L normal", (vector.p0.x * scaling  + arrow3.x) * 0.5 + 5, (vector.p0.y * scaling + arrow3.y) * 0.5 + 5);
  
  fill(45);
  text("p0: x="+v.p0.x+", y="+v.p0.y, 10, 20);
  text("p1: x="+v.p1.x+", y="+v.p1.y, 10, 35);
  text("vx: "+v.vx+", vy: "+v.vy, 10, 50);
  var len = roundMe(v.length);
  text("length: "+len, 10, 65);
  var dx = roundMe(v.dx);
  var dy = roundMe(v.dy);
  text("dx: "+dx+", dy: "+dy, 10, 80);
  text("rx: "+v.rx+", ry: "+v.ry, 10, 95);
  text("lx: "+v.lx+", ly: "+v.ly, 10, 110);
}

//function to find all parameters for the vector
function updateVector(v) {
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
function roundMe(num) {
  var rnum = str(num);
  var nums = split(rnum, ".");
  if (nums[1] === undefined) {
    nums[1] = "00";
  }
  return nums[0]+"." + nums[1].substring(0, min(nums[1].length, 2));
  
}

/** Handler to drag the points */
function newDragger(size0) {
  
  var dragger = {
    x:0, y:0,
    size:size0/2, 
    pressed:false,
    place:function() {
      
      noStroke();
      fill(50, 76);
      rect(this.x -this.size -2, this.y -this.size -2, 
        this.size + this.size + 4, this.size + this.size + 4);
      if(!this.pressed) fill(255, 50);
      else fill(204, 102, 45, 200);
      rect(this.x - this.size, this.y - this.size, 
        this.size + this.size, this.size + this.size);
      
    },
    contains:function(x0, y0) {
      if(x0 < this.x - this.size || x0 > this.x + this.size 
        || y0 < this.y - this.size || y0 > this.y + this.size) {
        return false;
      }
      return true;
    }
  }
  
  return dragger;
  
}


/** Arrow Graphic definition */
function newArrow(color0) {
  
  var arrow = {
    x:0, y:0, 
    rotation:0,//radian
    c:color0,
    place:function() {
     stroke(this.c);
     noFill();
     push();
     translate(this.x, this.y);
     rotate(this.rotation + QUARTER_PI); //Arrow is leaned by QUARTER_PI 
     line(0, 0, -9, 2);
     line(0, 0, -2, 9);
     pop();
   }
  };
  
  return arrow;
  
 
  
}

/** Point definition */
function newPoint() {
  var p = {
    x:0, y:0
  }
  return p;
}
function newPoint(x0, y0) {
  var p = {
    x:x0, y:y0
  }
  return p;
}

/** Vector definition */
function newVector() {
  var v = {
    p0:newPoint(),
    p1:newPoint(),
    vx:0, vy:0,
    rx:0, ry:0,
    lx:0, ly:0,
    dx:0, dy:0,
    length:0
  };
  return v;
}