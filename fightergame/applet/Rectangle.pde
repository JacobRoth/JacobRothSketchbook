class Rectangle {
  float x; //position
  float y;

  int h;
  int w;


  int r;
  int g;
  int b;

  Rectangle (float c1x, float c1y) { //constructor
    x = c1x;
    y = c1y;
    h = 20;
    w = 20;
    r = round(random(255));
    g = round(random(255));
    b = round(random(255));
  }

  Rectangle (float c1x, float c1y, int inw, int inh, int inr, int ing, int inb) { //totally specific constructor
    x = c1x;
    y = c1y;
    h = inh;
    w = inw;
    r = inr;
    g = ing;
    b = inb;
  }

  void render () {
    fill(r, g, b);
    noStroke();
    rect(x, y, w, h);
  }


  void die(ArrayList whatList) {
    whatList.remove(this);
  }
}

class Fighter extends Rectangle {
  float topspeed;

  Fighter (int c1x, int c1y, int inw, int inh, int inr, int ing, int inb, float topspd) {
    super(c1x, c1y, inw, inh, inr, ing, inb);
    topspeed = topspd;
  }

  void boundrycheck(int windowsize) {
    if (x < 0) {
      x = 0;
    }
    if (y < 0) {
      y = 0;
    }
    if (x+w>windowsize) {
      x = windowsize-w;
    }
    if (y+h>windowsize) {
      y = windowsize-h;
    }
  }
  void render() {
    noFill();
    stroke(r, g, b);
    ellipse(x+(w/2), y+(h/2), w*8, h*8);
    super.render();
  }
  void moveSelf() {
    if (checkKey("W")) {
      y -= topspeed;
    }
    if (checkKey("S")) {
      y += topspeed;
    }
    if (checkKey("A")) {
      x -= topspeed;
    }
    if (checkKey("D")) {
      x += topspeed;
    }
  }
}

class Bullet extends Rectangle {
  float mvx;
  float mvy;
  Bullet (int c1x, int c1y, int inw, int inh, int inr, int ing, int inb, float motionx, float motiony) {
    super(c1x, c1y, inw, inh, inr, ing, inb);
    mvx = motionx;
    mvy = motiony;
  }

  void boundrycheck(ArrayList listIn) {
    if (x < 0) {
      die(listIn);
    }
    if (y < 0) {
      die(listIn);
    }
    if (x+w>windowSize) {
      die(listIn);
    }
    if (y+h>windowSize) {
      die(listIn);
    }
  }
  void moveSelf() {
    x = x+mvx;
    y = y+mvy;
  }
}

boolean collDetect(Rectangle rect1, Rectangle rect2) {
  if (rect1.x+rect1.w < rect2.x) { 
    return false;
  }
  if (rect1.x > rect2.x+rect2.w) { 
    return false;
  }
  if (rect1.y+rect1.h < rect2.y) { 
    return false;
  }
  if (rect1.y > rect2.y+rect2.h) { 
    return false;
  }
  return true;
}


