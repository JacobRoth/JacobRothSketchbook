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
  void handleOffSides(int windowX, int windowY, float wallreduce) {
    if(pos.x < 0){
      pos.x = 0;
      speed.x = speed.x*-1;
      frictionate(wallreduce);
    } else if (pos.x+w > windowX) {
      pos.x = windowX-w;
      speed.x = speed.x*-1;
      frictionate(wallreduce);
    }  
    if(pos.y < 0 ) { 
      pos.y=0;
      speed.y = speed.y*-1;
      frictionate(wallreduce);
    } else if (pos.y+h > windowY) {
      pos.y=windowY-h;
      speed.y = speed.y*-1;
      frictionate(wallreduce);
    }
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
    health = inhealth;                                 
    myguns = new Gun[1];
    myguns[0] = new Gun(0,0,0,0,color(0,0,0),0); //placeholder weapon
    currentgun = 0;
  }
  void shootTowards(float Xloc, float Yloc, ArrayList putbulletshere) {
    myguns[currentgun].fire(this,Xloc,Yloc,putbulletshere);
  }
  void render() {
    //super.render();
    image(img,pos.x,pos.y,w,h);
  }
  void takedamage(PhysicsRect touchingMe) { //precondition - touchingMe has been indeed confirmed to be touching me
    PVector impactspeed = touchingMe.speed.get();
    impactspeed.sub(speed);
    impactspeed.mult(touchingMe.mass);
    applyforce(impactspeed); //recoil from the shot
    health -= impactspeed.mag();
  }
}
class Player extends CharacterRect {
  Gun thruster;
  Player(PVector inpos, int inw, int inh, color incol, PVector inspeed, float inmass) {
    super(inpos,inw,inh,incol,inspeed,inmass,1500,loadImage("player.png"));
    
    thruster = new Gun(100 ,20,1  ,1.1781,color(255,255,255,150),.06); //thruster (3/8 PI spread)
    
    myguns = new Gun[4];
    myguns[0] = new Gun(250 ,12,50  ,0.3927,color(255,255,255,150),1); //shotgun (1/8 PI spread)
    myguns[1] = new Gun(40  ,37,200,.01,        color(255,255,255),1);  //bolt
    myguns[2] = new Gun(5000,9 ,400,PI,    color(255,255,255),1);  //360 radial cannon
    myguns[3] = new Gun(10,  20,2  ,.01,        color(255,255,255),.35); //chaingun
  }
  void update() {
    super.update();
    for(int iii=0;iii<playerWepKeys.length;iii++) {
      if(checkKey(playerWepKeys[iii])) currentgun = iii;
    }
  }
  void thrustTowards(float Xloc, float Yloc, ArrayList putbulletshere) {
    thruster.fire(this,Xloc,Yloc,putbulletshere);
  }
}
