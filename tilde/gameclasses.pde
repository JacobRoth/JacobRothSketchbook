class PlayerRect extends MotileRect {
  static final float playerspeed = 10;
  int score;
  PImage img;
  PImage imgred;
  PImage imggreen;
  PImage imgblue;
  PImage imgorange;
  
  Weapon redwep;
  Weapon greenwep;
  Weapon bluewep;
  Weapon orangewep;
 
  
  PlayerRect(PVector inpos, int inw, int inh, int inr, int ing, int inb) {
    super(inpos, inw, inh, inr, ing, inb, new PVector(0,0)); //start out speedless
    score = 0;
    img = loadImage("tilde.png");
    imgred = loadImage("tildered.png");
    imgblue = loadImage("tildeblue.png");
    imggreen = loadImage("tildegreen.png");
    imgorange = loadImage("tildeorange.png");
    
    greenwep = new Weapon(3,playerspeed+.02,3,.1); //driftmine lanucher. the playerspeed+.02 is significant - eversoslightly more than player's speed
    //so if fired directly behind a moving player, the bullets stay on screen a loooooooooooooooong time and drift slowly
    //bluewep = new Weapon 
    //redwep = new Weapon
    orangewep = new Weapon(300,playerspeed+.02,300,PI); //radial burst cannon
    
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

class Weapon { //a set of definitions - fire rate, num projectiles, projectile speeds, etc.
  private int numprojectiles;
  private float projectilespeed;
  private int firerate; //is actually frames between shots
  private float spreadangle; //in RADIANS, NOT degrees.
  private long lastframeshot;
  Weapon(int numpr, float ps, int frate, float spreadradians) { 
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
