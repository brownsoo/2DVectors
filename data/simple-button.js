//----------------------------------

/** 
* Simple Button for P5
* by hyonsoo han
* 
To make button;

1. create new SimpleButton instance.
  btn = new SimpleButton("OK"); 
  btn.x = 10;
  btn.y = 50;

2. create new function for ButtonCallback.
  function clickBtn(b) {
    println("onclick");
  }

3. Connect listener instance with the button.
  btn.setCallback(clickBtn);

4. Call the place-function of SimpleButton in every time to draw 

  btn.place()

*/
class SimpleButton {
  constructor(label0){
    this.label = label0;
    textSize(14);
    this.tw = textWidth(label0) + 10;
    this.th = 24;
    this.c = color('#FFC107');
    this.pressed = false;
    this.x = 0;
    this.y = 0;
    this.mx = 0;
    this.my = 0;
    this.mTime = 0;
    this.mState = 0;
    this.onClick = null;

    this.onPressed = function() {
      this.mx = mouseX;
      this.my = mouseY;
      this.mTime = millis();
      this.pressed = this.contains(mouseX, mouseY);
      this.mState = (this.pressed ? 1:0);
    }
    
    this.onReleased = function() {
      this.pressed = false;
      this.mState = 0;
      if(!this.contains(mouseX, mouseY)) return;
      if(abs(this.mx - mouseX) > 10) return;
      if(abs(this.my - mouseY) > 10) return;
      if(millis() - this.mTime > 200) return;
      if(this.callback != null) this.callback(this);
    }
    
    this.contains = function(x0, y0) {
      if(x0 < this.x || x0 > this.x + this.tw 
        || y0 < this.y || y0 > this.y + this.th) {
        return false;
      }
      return true;
    }
  }
  
  place() {
    
    noStroke();
    textSize(14);

    if(!this.pressed) {
      fill(this.c);
      rect(this.x, this.y, this.tw, this.th);
      fill(255);
      textAlign(CENTER, CENTER);
      text(this.label, this.x + this.tw/2, this.y + this.th/2);
    }
    else {
      fill(200, 156);
      rect(this.x, this.y, this.tw, this.th);
      fill(0);
      textAlign(CENTER, CENTER);
      text(this.label, this.x + this.tw/2, this.y + this.th/2);
    }
    textAlign(LEFT, BASELINE);
    
    if(this.mState == 0 && mouseIsPressed) {
      this.onPressed();
    } else if(this.mState == 1 && !mouseIsPressed) {
      this.onReleased();
    }
  }
  
  setCallback(callback0) {
    this.callback = callback0;
  }
}