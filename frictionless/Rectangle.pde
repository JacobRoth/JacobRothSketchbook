
class Rectangle {
  PVector pos;

  int h;
  int w;

  int r;
  int g;
  int b;

  boolean hollow;

  Rectangle (PVector inpos, int inw, int inh, int inr, int ing, int inb, boolean inhollow) { //non-hollow
    pos = inpos;
    h = inh;
    w = inw;
    r = inr;
    g = ing;
    b = inb;
    hollow = inhollow;
  }
  Rectangle (PVector inpos, int inw, int inh, int inr, int ing, int inb) {
    this(inpos,inw,inh,inr,ing,inb,false);
  } 
  void render () {
    stroke(r,g,b);
    if(hollow) {
      noFill();
    } else {
      fill(r, g, b);
      for (int iii=0; iii<coronaStormIntensity; iii++) {
        PVector cr1 = getCoronaPoint();
        PVector cr2 = getCoronaPoint();
        line(cr1.x,cr1.y,cr2.x,cr2.y);
      }
    }
    rect(pos.x, pos.y, w, h);
    
    stroke(r,g,b);
    
    
  }
  PVector getCoronaPoint() { //corona extends 1/2 the width out the sides of the rect and 1/2 the height out the top and bottom
  /* finds a point in the corona */
    int thisX = 0;
    int thisY = 0;
    if(random(1)>0.5) { //x on the left
      thisX = (int)(random(pos.x-(w/2),pos.x));
    } else {
      thisX = (int)(random(pos.x+w,pos.x+(w*1.5)));
    }
    /*if(random(1)>0.5) {
      thisY = (int)(random(pos.y-(h/2),pos.y));
    } else {
      thisY = (int)(random(pos.y+h,pos.y+(h*1.5)));
    }*/
    thisY = (int)(random(pos.y-(h/2),pos.y+h+(h/2)));
    return new PVector(thisX,thisY);
  }
  float getCX() { //get center-x
    return pos.x+(w/2);
  }
  float getCY() { //get center-y
    return pos.y+(h/2);
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
  int score;
  PlayerRect(PVector inpos, int inw, int inh, int inr, int ing, int inb) {
    super(inpos, inw, inh, inr, ing, inb, new PVector(0,0)); //start out speedless
    score = 0;
  }
  void moveself() {
    if (checkKey("Up") || checkKey("W")) {
      speed.y -= .05;
    }
    if (checkKey("Down")|| checkKey("S")) {
      speed.y += .05;
    }
    if (checkKey("Left")|| checkKey("A")) {
      speed.x -= .05;
    }
    if (checkKey("Right")|| checkKey("D")) {
      speed.x += .05;
    }
  }
  
}

class GravRect extends Rectangle {
  float magnitude;
  GravRect (PVector inpos, int inw, int inh, int inr, int ing, int inb, float inmag) {
    super(inpos,inw,inh,inr,ing,inb);
    magnitude = inmag;
  }
  

  void affect(MotileRect target) {
    // the distance on the x-axis
    float dx = getCX() - target.pos.x;
    
    // the distance on the y-axis
    float dy = getCY() - target.pos.y;
    
    // the distance between the 2 objects 
    float d = sqrt( dx * dx + dy * dy );
    
    // the acceleration - inversely proportional to the square of the distance
    float acc = magnitude / ( d * d);
    // the direction angle
    float sinAngle = dy / d;
    float cosAngle = dx / d;
    
    
    // the acceleration on the x-axis
    float accX = acc * cosAngle;
    
    // the acceleration on the y-axis
    float accY = acc * sinAngle;
    
    PVector effect = new PVector( accX, accY);
    target.speed.add(effect);
  } 
}

boolean rectCollision(Rectangle rect1, Rectangle rect2) {
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
