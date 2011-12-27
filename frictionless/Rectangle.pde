class Rectangle {
  PVector pos;

  int h;
  int w;

  int r;
  int g;
  int b;

  Rectangle (PVector inpos, int inw, int inh, int inr, int ing, int inb) { //define with a vector
    pos = inpos;
    h = inh;
    w = inw;
    r = inr;
    g = ing;
    b = inb;
  }

  void render () {
    fill(r, g, b);
    noStroke();
    rect(pos.x, pos.y, w, h);
  }
  float getCX() { //get center-x
    return pos.x-(w/2);
  }
  float getCY() { //get center-y
    return pos.y-(h/2);
  }
}

class MotileRect extends Rectangle {
  PVector speed; //in pixels per 1/10th second.
  Trigger timer; 
  MotileRect(PVector inpos, int inw, int inh, int inr, int ing, int inb, PVector inspd) {
    super(inpos, inw, inh, inr, ing, inb);
    speed = inspd;
    timer = new Trigger(10);
  }
  void update() {
    while (timer.fires ()) {
      pos.add(speed);
    }
  }
}

class PlayerRect extends MotileRect {
  PlayerRect(PVector inpos, int inw, int inh, int inr, int ing, int inb) {
    super(inpos, inw, inh, inr, ing, inb, new PVector(0,0)); //start out speedless
  }
  void moveself() {
    if (checkKey("W")) {
      speed.y -= .1;
    }
    if (checkKey("S")) {
      speed.y += .1;
    }
    if (checkKey("A")) {
      speed.x -= .1;
    }
    if (checkKey("D")) {
      speed.x += .1;
    }
  }
}
    

boolean collDetect(Rectangle rect1, Rectangle rect2) {
  if (rect1.pos.x+rect1.w < rect2.pos.x) { 
    return false;
  }
  if (rect1.pos.x > rect2.pos.x+rect2.w) { 
    return false;
  }
  if (rect1.pos.y+rect1.h < rect2.pos.y) { 
    return false;
  }
  if (rect1.pos.y > rect2.pos.y+rect2.h) { 
    return false;
  }
  return true;
}
