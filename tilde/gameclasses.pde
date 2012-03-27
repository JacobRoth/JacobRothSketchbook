class PlayerRect extends MotileRect {
  static final float playerspeed = 4;
  int score;
  PImage img;
  PImage imgred;
  PImage imggreen;
  PImage imgblue;
  PImage imgorange;
  
  //Weapon redwep;
  Gun greenwep;
  MissileLauncher bluewep;
  ZapwaveLauncher orangewep;
 
  
  PlayerRect(PVector inpos, int inw, int inh, int inr, int ing, int inb) {
    super(inpos, inw, inh, inr, ing, inb, new PVector(0,0)); //start out speedless
    score = 0;
    img = loadImage("tilde.png");
    imgred = loadImage("tildered.png");
    imgblue = loadImage("tildeblue.png");
    imggreen = loadImage("tildegreen.png");
    imgorange = loadImage("tildeorange.png");
    
    greenwep = new Gun(60,playerspeed,20,.1); //driftmine lanucher. the playerspeed is significant - eversoslightly more than player's speed
    //so if fired directly behind a moving player, the bullets stay on screen a loooooooooooooooong time and drift slowly
    bluewep = new MissileLauncher(2,.2,90,.3);
    //redwep = new Weapon
    orangewep = new ZapwaveLauncher(2,5); //radial burst cannon
    
  }
  void render() {
    image(img,pos.x,pos.y,w,h);
  }
  void fireMyWeapon() {
    if(speed.x<0)  {
      greenwep.fire(this,mouseX,mouseY,playersBullets); 
    } else if(speed.x>0) {
      orangewep.fire(this,mouseX,mouseY,playersBullets);
    } else if(speed.y>0) {
      bluewep.fire(this,mouseX,mouseY,playersBullets);
    }
  }
  void moveself() {
    if (checkKey("Up") || checkKey("W")) {
      speed.y = -1*playerspeed;
      speed.x = 0;
      img=imgred;
    }
    if (checkKey("Down") || checkKey("S")) {
      speed.y = playerspeed;
      speed.x = 0;
      img=imgblue;
    }
    if (checkKey("Left") || checkKey("A")) {
      speed.x = -1*playerspeed;
      speed.y = 0;
      img=imggreen;
    }
    if (checkKey("Right") || checkKey("D")) {
      speed.x = playerspeed;
      speed.y = 0;
      img=imgorange;
    }
    
  }
}

class Gun { //shoots little green squares.
  int numprojectiles;
  float projectilespeed;
  int firerate; //is actually frames between shots
  float spreadangle; //in RADIANS, NOT degrees.
  long lastframeshot;
  Gun(int numpr, float ps, int frate, float spreadradians) { 
    numprojectiles = numpr;
    projectilespeed = ps;
    firerate = frate;
    spreadangle = spreadradians;
    lastframeshot = frameCount;
  }
  PVector computeShot(MotileRect theShooter, int destX, int destY) {
    float atanval = atan2(destX-theShooter.getCX(),destY-theShooter.getCY()); //find the heading of where were shooting
    float sinRandomness = atanval+random(-1*spreadangle,spreadangle);
    float cosRandomness = atanval+random(-1*spreadangle,spreadangle);
    PVector effect = new PVector(sin(sinRandomness),cos(cosRandomness)); //add or sub from that ATAN
                      
    effect.normalize();
    effect.mult(projectilespeed);
        
    effect.add(theShooter.speed); //projectile inheritance! SHAZBOT!
    return effect.get();
  }
  //SEE COMMENT ON NEXT LINE
  void fire(MotileRect theShooter, int Xloc, int Yloc, ArrayList putBulletsHere) { //REMEMEBER IF YOU EDIT THIS, CHANGE IT IN MissileLauncher TOO!!!!!!
    if(lastframeshot+firerate<frameCount) { //enough frames has past
      for(int iii=0;iii<numprojectiles;iii++) { //shot several if we want
        lastframeshot = frameCount;
        putBulletsHere.add(new MotileRect(new PVector(theShooter.getCX(),theShooter.getCY()),4,4,0,255,0,computeShot(theShooter,Xloc,Yloc)));
      }
    }
  }
}

class MouseMissile extends MotileRect {
  float accelrate;
  MouseMissile(PVector inpos, int inw, int inh, int inr, int ing, int inb, PVector inspd, float inacc) {
    super(inpos,inw,inh,inr,ing,inb,inspd);
    accelrate = inacc;
  }
  void update() {
    super.update();
    PVector movementVector = new PVector(mouseX-pos.x,mouseY-pos.y);
    movementVector.normalize();
    movementVector.mult(accelrate);
    speed.add(movementVector);
  }
}

class MissileLauncher extends Gun {
  MissileLauncher( int numpr, float ps, int frate, float spreadradians) {
    super(numpr,ps,frate,spreadradians);
  }
  //i just copypasta'd Gun's fire() and replaced MotileRect with MouseMissile. And added accelrate to the created missile's constructor call. 
  //Program design fail, ik,ik,ik....
  void fire(MotileRect theShooter, int Xloc, int Yloc, ArrayList putBulletsHere) {
    if(lastframeshot+firerate<frameCount) { //enough frames has past
      for(int iii=0;iii<numprojectiles;iii++) { //shot several if we want
        lastframeshot = frameCount;
        putBulletsHere.add(new MouseMissile(new PVector(theShooter.getCX(),theShooter.getCY()),4,4,0,0,255,computeShot(theShooter,Xloc,Yloc),.1));
      }
    }
  }
}
class ZapwaveLauncher { //does not extend Gun because it lacks multiple projectiles and all that spread-vector-math-stuff.
  private float projectilespeed;
  private int firerate; //is actually frames between shots
  private long lastframeshot;
  ZapwaveLauncher(float ps, int frate) { 
    projectilespeed = ps;
    firerate = frate;
    lastframeshot = frameCount;
  }
  void fire(MotileRect theShooter, int Xloc, int Yloc, ArrayList putBulletsHere) {
    if(lastframeshot+firerate<frameCount) { //enough frames has past
      lastframeshot = frameCount;
      putBulletsHere.add(new Zapwave(new PVector(theShooter.getCX(),theShooter.getCY()),4,255,69,0,255)); //255,69,0 is a nice color  
    }
  }
}

class Zapwave { //an ever-expanding wave
  PVector pos;
  float speed;
  float rad; //radius
  int maxradius;
  int r;
  int g;
  int b;
  Zapwave(PVector inpos, float inspeed, int inr, int ing, int inb, int inmaxradius) {
    
    pos = inpos.get();
    rad = 1;
    speed = inspeed;
    r=inr;
    g=ing;
    b=inb;
    maxradius = inmaxradius;
  }
  void render() {
    stroke(r,g,b,maxradius-rad); //decreases to zero slowly
    noFill();
    ellipseMode(CENTER);
    ellipse(pos.x,pos.y,rad,rad);
    noStroke();
    
  }
  void update() {
    rad+=speed;
  }  
  boolean isOffSides(int windowX,int windowY) {
    /*
    if(  rad>sqrt((windowX*windowX)+(windowY*windowY))*2  ) return true; //so it checks to see if the diameter is greater than the diagonal size of the window. If so, it's off screen. hackish formula but it works :D
    return false;
    */
    return rad>maxradius;
    
  }
  boolean isOffSides() {
    return isOffSides(windowSize,windowSize);
  }
}


