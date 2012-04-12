class Rectangle {
  protected PVector pos;

  int h;
  int w;

  color col;

  Rectangle (PVector inpos, int inw, int inh, color incol) {
    pos = inpos;
    h = inh;
    w = inw;
    col = incol;
  }
  void render () {
    fill(col);
    stroke(col);
    if(w==0 && h==0) {//if no dimension it's just a tiny point
      point(pos.x,pos.y);
    } else {
      rect(pos.x, pos.y, w, h);
    }
  }
  
  boolean isOffSides(int windowX, int windowY) {
    if(pos.x < 0)  {
      return true;
    } else if(pos.y < 0) { 
      return true;
    } else if(pos.x+w > windowX) {
      return true;
    } else if(pos.y+h > windowY) {
      return true;
    }
    return false;
  }
  boolean rectCollision(Rectangle rect1) {
    if (rect1.pos.x+rect1.w < pos.x) { 
      return false;
    }
    if (rect1.pos.x > pos.x+w) { 
      return false;
    }
    if (rect1.pos.y+rect1.h < pos.y) { 
      return false;
    }
    if (rect1.pos.y > pos.y+h) { 
      return false;
    }
    return true;
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
  MotileRect(PVector inpos, int inw, int inh, color incol, PVector inspd) {
    super(inpos, inw, inh, incol);
    speed = inspd.get();
  }
  void update() {
    pos.add(speed);
  }
}

class PhysicsRect extends MotileRect {
  float mass; 
  PhysicsRect(PVector inpos, int inw, int inh, color incol, PVector inspeed, float inmass) {
    super(inpos,inw,inh,incol,inspeed);
    mass = inmass;
  }
  void applyforce(PVector force) {
    PVector newforce = force.get();
    newforce.div(mass);
    speed.add(newforce);
  }
  void frictionate(float percent) { //super-ghetto-nonrealistic friction math! yAAAY!
    /*PVector appliedforce = speed.get();
    appliedforce.mult(mass);
    appliedforce.mult(-1*coeff);
    applyforce(appliedforce);  */
    speed.mult(percent);
  }
  PVector getMomentumVector() {
    PVector retvector = speed.get();
    retvector.mult(mass);
    return retvector;
  }
  float getMomentumScalar() { //for calculating damage and the like.
    return speed.mag()*mass;
  }
  //void renderMomentumVector() {    stroke(col);    PVector momentum = getMomentumVector();    line(pos.x,pos.y,momentum.x+pos.x,momentum.y+pos.y);  }
}
class CharacterRect extends PhysicsRect {
  float health;
  PImage img;
  Gun[] myguns;
  int currentgun;
  CharacterRect(PVector inpos, int inw, int inh, color incol, PVector inspeed, float inmass, float inhealth, PImage inimg) {
    super(inpos,inw,inh,incol,inspeed,inmass);
    img = inimg;
    health = inhealth;                                 //FROM HERE ON OUT, defining attribuites such as guns, health, and images in the class, not making them constructor options.
    myguns = new Gun[1];
    myguns[0] = new Gun(0,0,0,0,color(0,0,0),0); //placeholder weapon
    currentgun = 0;
  }
  void shootTowards(float Xloc, float Yloc, ArrayList putbulletshere) {
    myguns[currentgun].fire(this,Xloc,Yloc,putbulletshere);
  }
  void render() {
    super.render();
    image(img,pos.x,pos.y);
  }
}
class PlayerRect extends CharacterRect {
  PlayerRect(PVector inpos, int inw, int inh, color incol, PVector inspeed, float inmass) {
    super(inpos,inw,inh,incol,inspeed,inmass,50,loadImage("player.png"));
    myguns = new Gun[1];
    myguns[0] = new Gun(100,12,0,QUARTER_PI,color(255,255,255,150),.04);
  }
}
  


/*
class Particle extends PhysicsRect {
  float damage;
  Particle(PVector inpos, color incol, PVector inspeed, float inmass, float indamage) {
    super(inpos,0,0,incol,inspeed,inmass);
    damage = indamage;
  }
  void render() {
    stroke(col);
    point(pos.x,pos.y);
  }
}*/
