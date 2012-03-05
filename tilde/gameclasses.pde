class PlayerRect extends MotileRect {
  static final float playerspeed = 10;
  int score;
  PImage img;
  PImage imgred;
  PImage imggreen;
  PImage imgblue;
  PImage imgorange;
  
  //Weapon redwep;
  Gun greenwep;
  //Weapon bluewep;
  ZapwaveLauncher orangewep;
 
  
  PlayerRect(PVector inpos, int inw, int inh, int inr, int ing, int inb) {
    super(inpos, inw, inh, inr, ing, inb, new PVector(0,0)); //start out speedless
    score = 0;
    img = loadImage("tilde.png");
    imgred = loadImage("tildered.png");
    imgblue = loadImage("tildeblue.png");
    imggreen = loadImage("tildegreen.png");
    imgorange = loadImage("tildeorange.png");
    
    greenwep = new Gun(3,playerspeed+.02,3,.1); //driftmine lanucher. the playerspeed+.02 is significant - eversoslightly more than player's speed
    //so if fired directly behind a moving player, the bullets stay on screen a loooooooooooooooong time and drift slowly
    //bluewep = new Weapon 
    //redwep = new Weapon
    orangewep = new ZapwaveLauncher(2,2); //radial burst cannon
    
  }
  void render() {
    image(img,pos.x,pos.y,w,h);
  }
  void fireMyWeapon() {
    if(speed.x<0)  {
      greenwep.fire(this,mouseX,mouseY,playersBullets); //pos.get() becase doing just pos causes nasty aliasing
    } else if(speed.x>0) {
      orangewep.fire(this,mouseX,mouseY,playersBullets);
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
  private int numprojectiles;
  private float projectilespeed;
  private int firerate; //is actually frames between shots
  private float spreadangle; //in RADIANS, NOT degrees.
  private long lastframeshot;
  Gun(int numpr, float ps, int frate, float spreadradians) { 
    numprojectiles = numpr;
    projectilespeed = ps;
    firerate = frate;
    spreadangle = spreadradians;
    lastframeshot = frameCount;
  }
  void fire(MotileRect theShooter, int Xloc, int Yloc, ArrayList putBulletsHere) {
    if(lastframeshot+firerate<frameCount) { //enough frames has past
      lastframeshot = frameCount;
      for(int iii=0;iii<numprojectiles;iii++) { //shot several if we want
                        
        float atanval = atan2(Xloc-theShooter.getCX(),Yloc-theShooter.getCY()); //find the heading of where were shooting
        float sinRandomness = atanval+random(-1*spreadangle,spreadangle);
        float cosRandomness = atanval+random(-1*spreadangle,spreadangle);
        PVector effect = new PVector(sin(sinRandomness),cos(cosRandomness)); //add or sub from that ATAN
       
        /*println("before spread:   "+(Xloc-theShooter.getCX())+"   "+(Yloc-theShooter.getCY()));
        println("after spread:    "+effect);
        println("the atan value:  "+atanval);*/
               
        effect.normalize();
        effect.mult(projectilespeed);
        
        effect.add(theShooter.speed); //projectile inheritance! SHAZBOT!
        putBulletsHere.add(new MotileRect(new PVector(theShooter.getCX(),theShooter.getCY()),4,4,0,255,0,effect)); 
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
      putBulletsHere.add(new Zapwave(new PVector(theShooter.getCX(),theShooter.getCY()),4,255,69,0));  
    }
  }
}

class Zapwave { //an ever-expanding wave
  PVector pos;
  float speed;
  float rad; //radius
  int r;
  int g;
  int b;
  Zapwave(PVector inpos, float inspeed, int inr, int ing, int inb) {
    pos = inpos.get();
    rad = 1;
    speed = inspeed;
    r=inr;
    g=ing;
    b=inb;
  }
  void render() {
    stroke(r,g,b);
    noFill();
    ellipseMode(CENTER);
    ellipse(pos.x,pos.y,rad,rad);
    noStroke();
  }
  void update() {
    rad+=speed;
  }  
  boolean isOffSides(int windowX,int windowY) {
    if(  rad>sqrt((windowX*windowX)+(windowY*windowY))*2  ) return true; //so it checks to see if the diameter is greater than the diagonal size of the window. If so, it's off screen. hackish formula but it works :D
    return false;
  }
  boolean isOffSides() {
    return isOffSides(windowSize,windowSize);
  }
}
