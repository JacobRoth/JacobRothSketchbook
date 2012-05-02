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
    myguns[0] = new Gun(1,9,2,.005,color(0,200,255),.1); 
  }
}
class Sniper extends GenericEnemy {
  Sniper(PVector inpos,  PVector inspeed) {
    super(inpos,15,15,color(0,0,0,0),inspeed,200,400,loadImage("sniper.png"));
    myguns = new Gun[1];
    myguns[0] = new Gun(9,18,200,.005,color(0,125,255),1); 
  }
}


void randInsertEnemy(ArrayList enemys) { //needs fixing in terms of all the f****** variables in this function.
  int enemySize = 20; //max size
  float enemyTopSpeed = 10;
  int screenedge = (int)(random(0,4));
  if (screenedge == 0) { //the left edge
    int posx = 1;
    int posy = (int)(random(0,windowY-enemySize));
    float speedx = random(0,enemyTopSpeed);
    float speedy = random(-1*enemyTopSpeed,enemyTopSpeed);
    enemys.add(new Chaingunner(new PVector(posx,posy),new PVector(speedx,speedy)));
  } else if (screenedge == 1) { //the right edge
    int posx = windowX-enemySize;
    int posy = (int)(random(0,windowY-enemySize));
    float speedx = random(-1*enemyTopSpeed,0);
    float speedy = random(-1*enemyTopSpeed,enemyTopSpeed);
    enemys.add(new Chaingunner(new PVector(posx,posy),new PVector(speedx,speedy)));
  } else if (screenedge == 2) { //the top
    int posx = (int)(random(0,windowX-enemySize));
    int posy = 0;
    float speedx = random(-1*enemyTopSpeed, enemyTopSpeed);
    float speedy = random(0,enemyTopSpeed);
    enemys.add(new Chaingunner(new PVector(posx,posy),new PVector(speedx,speedy)));
  } else if (screenedge == 3) { //the bottom
    int posx = (int)(random(0,windowX-enemySize));
    int posy = windowY-enemySize;
    float speedx = random(-1*enemyTopSpeed, enemyTopSpeed);
    float speedy = random(-1*enemyTopSpeed,0);
    enemys.add(new Chaingunner(new PVector(posx,posy),new PVector(speedx,speedy)));
  }    
}

