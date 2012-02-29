class PlayerRect extends MotileRect {
  int score;
  PImage img;
  PImage imgred;
  PImage imggreen;
  PImage imgblue;
  PImage imgorange;
  Weapon somewep;
  PlayerRect(PVector inpos, int inw, int inh, int inr, int ing, int inb) {
    super(inpos, inw, inh, inr, ing, inb, new PVector(0,0)); //start out speedless
    score = 0;
    img = loadImage("tilde.png");
    imgred = loadImage("tildered.png");
    imgblue = loadImage("tildeblue.png");
    imggreen = loadImage("tildegreen.png");
    imgorange = loadImage("tildeorange.png");
    somewep = new Weapon(3,1,2,3);
  }
  void render() {
    image(img,pos.x,pos.y,w,h);
  }
  void moveself() {
    if (checkKey("Up") || checkKey("W")) {
      speed.y = -10;
      speed.x = 0;
      img=imgred;
    }
    if (checkKey("Down") || checkKey("S")) {
      speed.y = 10;
      speed.x = 0;
      img=imgblue;
    }
    if (checkKey("Left") || checkKey("A")) {
      speed.x = -10;
      speed.y = 0;
      img=imggreen;
    }
    if (checkKey("Right") || checkKey("D")) {
      speed.x = 10;
      speed.y = 0;
      img=imgorange;
    }
    
  }
}

class Weapon { //a set of definitions - fire rate, num projectiles, projectile speeds, etc.
  private int numprojectiles;
  private int minprojectilespeed;
  private int maxprojectilespeed;
  private int firerate;
  private int spreadangle;
  Weapon(int numpr, int minps, int maxps, int frate) { //leaving out spreadangle till i figure out the formula for that 
    //frate not yet implemented either.
    numprojectiles = numpr;
    minprojectilespeed = minps;
    maxprojectilespeed = maxps;
    firerate = frate;
  }
  void fire(PVector mypos, int Xloc, int Yloc, ArrayList putBulletsHere) {
    PVector effect = new PVector(Xloc-mypos.x,Yloc-mypos.y);
    effect.normalize();
    putBulletsHere.add(new MotileRect(mypos,4,4,0,255,0,new PVector(1,1)));
  }
}
