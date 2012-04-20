class GenericEnemy extends CharacterRect {
  GenericEnemy(PVector inpos, int inw, int inh, color incol, PVector inspeed, float inmass, float inhealth, PImage inimg) { //FROM HERE ON OUT, defining attribuites such as guns, health, and images in the class, not making them constructor options.
    super(inpos,inw,inh,incol,inspeed,inmass,inhealth,inimg);
    myguns = new Gun[1];
    myguns[0] = new Gun(10,  10,2  ,.01,        color(255,255,255),.35);
  }
  void aquireTarget(Player target,ArrayList putBulletsHere) {
    shootTowards(target.pos.x,target.pos.y,putBulletsHere);
  }
}
class Chaingunner extends GenericEnemy {
  Chaingunner(PVector inpos, int inw, int inh, color incol, PVector inspeed) {
    super(inpos,inw,inh,incol,inspeed,400,500,loadImage("chaingunner.png"));
    myguns = new Gun[1];
    myguns[0] = new Gun(9,  20,2  ,.005,color(0,125,255),.05); 
  }
}
class Sniper extends GenericEnemy {
  Sniper(PVector inpos, int inw, int inh, color incol, PVector inspeed) {
    super(inpos,inw,inh,incol,inspeed,200,500,loadImage("sniper.png"));
    myguns = new Gun[1];
    myguns[0] = new Gun(9,18,200,.005,color(0,125,255),1); 
  }
}
