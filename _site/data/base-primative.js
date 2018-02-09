/**
 * Base Primative 
 * by hyonsoo han
 *
 * Shows how to use vector to move object with acceleration.
 * Checkout : brownsoo.github.io/2DVectors
 * Apache License 2.0 - http://www.apache.org/licenses/LICENSE-2.0
 */

//segments is to convert between stage coordinates
const segments = 10;
const maxV = 10; // speed limit
const maxA = 1; // acceleration limit
//Object to move
var ball;
//reset button
var resetBt;

/** Point definition */
class Point {
 constructor(x0, y0) {
   this.name = 'Point'
   this.x = x0;
   this.y = y0;
 }
}
 /** Vector definition */
class Vector {
  constructor() {
    this.name = 'Vector'
    this.p0 = new Point(0, 0);
    this.p1 = new Point(0, 0);
    this.ax = 0.0;
    this.ay = 0.0;
    this.vx = 0.0;
    this.vy = 0.0;
    this.rx = 0.0;
    this.ry = 0.0;
    this.lx = 0.0;
    this.ly = 0.0;
    this.dx = 0.0;
    this.dy = 0.0;
    this.length = 0.0;  
  }
}
/** Ball Graphic */
class Ball extends Vector {
 constructor(color0, size0){
   super(0, 0);
   this.name = 'Ball'
   this.c = color0;
   this.size = size0 / 2.0;
   this.lastTime = 0;
 }
 
 place() {
   fill(this.c);
   noStroke();
   ellipse(this.p1.x, this.p1.y, this.size, this.size);
 }
}