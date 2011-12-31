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
  PlayerRect(PVector inpos, int inw, int inh, int inr, int ing, int inb) {
    super(inpos, inw, inh, inr, ing, inb, new PVector(0,0)); //start out speedless
  }
  void moveself() {
    if (checkKey("Up")) {
      speed.y -= .1;
    }
    if (checkKey("Down")) {
      speed.y += .1;
    }
    if (checkKey("Left")) {
      speed.x -= .1;
    }
    if (checkKey("Right")) {
      speed.x += .1;
    }
    println(" player coordinates x=" + pos.x + ", y=" + pos.y);
  }
}

class GravRect extends Rectangle {
  float magnitude;
  GravRect (PVector inpos, int inw, int inh, int inr, int ing, int inb, float inmag) {
    super(inpos,inw,inh,inr,ing,inb);
    magnitude = inmag;
  }
  
  /*
  void affect(MotileRect target) {
    PVector effect = new PVector( magnitude/(pos.x-target.pos.x), magnitude/(pos.y-target.pos.y));
    print(effect.x);
    print(" , ");
    println(effect.y);
    //effect.normalize();
    //effect.mult(magnitude);
    target.speed.add(effect);
  }
  */
  void affect(MotileRect target) {
    if (rectCollision(this,target)) {
      target.speed = new PVector(0,0);
    } else {
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
      /*print("Sine Angle = ");
      print(sinAngle);
      print(" , ");
    
      print("Cosine Angle = ");
      print(cosAngle);
      println("");
      */
    
      // the acceleration on the x-axis
      float accX = acc * cosAngle;
    
      // the acceleration on the y-axis
      float accY = acc * sinAngle;
    
      PVector effect = new PVector( accX, accY);
      target.speed.add(effect);
    }
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
