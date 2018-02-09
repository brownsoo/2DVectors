package com.hansoolabs.processing {
/** Handler to drag the points */
class Dragger {
  public float x;
  public float y;
  public boolean pressed = false;
  private float size;
  private float degree = 0;
  private float expend = 0;
  public Dragger() {
    this(20);
  }
  public Dragger(int size0) {
    this.size = size0;
  }
  public void place() {
    degree = degree > 180 ? 0 : degree + 10;
    noStroke();
    fill(50, 76);
    expend = sin(radians(degree)) * 10f;
    ellipse(x, y, size + expend, size + expend);
    if(!pressed) fill(255, 50);
    else fill(204, 102, 45, 200);
    ellipse(x, y, size, size);
    
  }
  public boolean contains(float x0, float y0) {
    if(x0 < x - size || x0 > x + size 
      || y0 < y - size || y0 > y + size) {
      return false;
    }
    return true;
  }
}