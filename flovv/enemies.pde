class GenericEnemy extends CharacterRect {
  GenericEnemy(PVector inpos, int inw, int inh, color incol, PVector inspeed, float inmass, float inhealth, PImage inimg) { //FROM HERE ON OUT, defining attribuites such as guns, health, and images in the class, not making them constructor options.
    super(inpos,inw,inh,incol,inspeed,inmass,inhealth,inimg);
    myguns = new Gun[1];
    myguns[0] = new Gun(10,  10,2  ,.01,        color(255,255,255),.35);
  }
  void aquireTarget(Player target,ArrayList putBulletsHere) {
    shootTowards(target.getCX(),target.getCY(),putBulletsHere);
  }
}
class Chaingunner extends GenericEnemy {
  Chaingunner(PVector inpos, PVector inspeed) {
    super(inpos,20,20,color(0,0,0,0),inspeed,240,400,loadImage("chaingunner.png")); //no need to supply height, width, color, mass, health, or image - these hardcoded.
    myguns = new Gun[1];
    myguns[0] = new Gun(11,5,11,0,color(0,255,255),.4); 
  }
}
class Sniper extends GenericEnemy {
  Sniper(PVector inpos,  PVector inspeed) {
    super(inpos,15,15,color(0,0,0,0),inspeed,200,400,loadImage("sniper.png"));
    myguns = new Gun[1];
    myguns[0] = new Gun(50,17,300,0,color(0,125,255),1); 
  }
}
class Blocker extends GenericEnemy {
  Blocker(PVector inpos,  PVector inspeed) {
    super(inpos,30,30,color(0,0,0,0),inspeed,200,800,loadImage("blocker.png"));
    myguns = new Gun[1];
    myguns[0] = new Gun(100 ,24,80  ,0.196,color(255,0,5),1);
  }
}



