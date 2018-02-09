/**
 * Moving with Vector 
 * by hyonsoo han
 *
 * Show how to use vector to move object.
 * Checkout : brownsoo.github.io/2DVectors
 * Apache License 2.0 - http://www.apache.org/licenses/LICENSE-2.0
 */

function setup() {
  var myCanvas = createCanvas(windowWidth * 0.96, windowWidth * 0.96);
  myCanvas.x = windowWidth * 0.02;
  myCanvas.parent('canvasHolder1')
  // Pulling the display's density dynamically
  try {
    pixelDensity(displayDensity());
  } catch(e){}
  background(255);
  //create object
  ball = new Ball(color('#ff5252'), 20);
  //point p0 is its starting point in the coordinates x/y
  ball.p0 = new Point(150, 100);
  //vector x/y components
  ball.vx = 3;
  ball.vy = 1;
}

function draw() {
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

function keyPressed() {
  if(keyCode == LEFT_ARROW && ball.vx > -maxV) {
      //reduce x velocity
      ball.vx--;
    }
    else if(keyCode == RIGHT_ARROW && ball.vx < maxV) {
      //increase x velocity
      ball.vx++;
    }
    else if (keyCode == UP_ARROW && ball.vy > -maxV) {
      //reduce y velocity
      ball.vy--;
    } 
    else if (keyCode == DOWN_ARROW && ball.vy < maxV) {
      //increase y velocity
      ball.vy++;
    }
  return false; // prevent default
}

//function to draw the points, lines and show text
//this is only needed for the example to illustrate
function drawAll() {
  //clear all
  background(255);
  
  //draw grid
  stroke(208);
  noFill();
  for(var i=0; i<width; i+=segments) {
    if(i%(10*segments)==0 && i>0) strokeWeight(2);
    else strokeWeight(1);
    line(i, 0, i, height);
  }
  for(var j=0; j<height; j+=segments) {
    if(j%(10*segments)==0 && j>0) strokeWeight(2);
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
function updateBall(v) {
  //find time passed from last update
  var thisTime = millis();
  var time = (thisTime - v.lastTime) / 1000.0 * segments;
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
