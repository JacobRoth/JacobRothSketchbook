class PlayerRect extends MotileRect {
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
  
  Weapon currentwep;
  
  PlayerRect(PVector inpos, int inw, int inh, int inr, int ing, int inb) {
    super(inpos, inw, inh, inr, ing, inb, new PVector(0,0)); //start out speedless
    score = 0;
    img = loadImage("tilde.png");
    imgred = loadImage("tildered.png");
    imgblue = loadImage("tildeblue.png");
    imggreen = loadImage("tildegreen.png");
    imgorange = loadImage("tildeorange.png");
    
    greenwep = new Weapon(3,3,3); //slow-speed gun
    //bluewep = new Weapon 
    //redwep = new Weapon
    //orangewep = new Weapon(
    
    currentwep = new Weapon(0,0,0); //null weapon.    
  }
  void render() {
    image(img,pos.x,pos.y,w,h);
  }
  void fireMyWeapon() {
    currentwep.fire(this,mouseX,mouseY,playersBullets); //pos.get() becase doing just pos causes nasty aliasing
  }
  void moveself() {
    if (checkKey("Up") || checkKey("W")) {
      speed.y = -5;
      speed.x = 0;
      img=imgred;
    }
    if (checkKey("Down") || checkKey("S")) {
      speed.y = 5;
      speed.x = 0;
      img=imgblue;
    }
    if (checkKey("Left") || checkKey("A")) {
      speed.x = -5;
      speed.y = 0;
      img=imggreen;
      currentwep=greenwep;
    }
    if (checkKey("Right") || checkKey("D")) {
      speed.x = 5;
      speed.y = 0;
      img=imgorange;
    }
    
  }
}

class Weapon { //a set of definitions - fire rate, num projectiles, projectile speeds, etc.
  private int numprojectiles;
  private int projectilespeed;

  private int firerate; //is actually frames between shots
  private int spreadangle;
  private long lastframeshot;
  Weapon(int numpr, int ps, int frate) { //leaving out spreadangle till i figure out the formula for that 
    //frate not yet implemented either.
    numprojectiles = numpr;
    projectilespeed = ps;
    firerate = frate;
    lastframeshot = frameCount;
  }
  void fire(MotileRect theShooter, int Xloc, int Yloc, ArrayList putBulletsHere) {
    if(lastframeshot+firerate<frameCount) { //enough frames has past
      lastframeshot = frameCount;
      for(int iii=0;iii<numprojectiles;iii++) { //shot several
        PVector effect = new PVector(Xloc-theShooter.getCX(), Yloc-theShooter.getCY());
        effect.normalize();
        effect.mult(projectilespeed);
        effect.add(theShooter.speed); //projectile inheritance! SHAZBOT!
        putBulletsHere.add(new MotileRect(new PVector(theShooter.getCX(),theShooter.getCY()),4,4,0,255,0,effect));
      }
    }
  }
}
