class Player extends CharacterRect {
  Gun thruster;
  Player(PVector inpos, int inw, int inh, color incol, PVector inspeed, float inmass) {
    super(inpos,inw,inh,incol,inspeed,inmass,1500,loadImage("player.png"));
    
    thruster = new Gun(50 ,20,1  ,1.1781,color(200,200,200),.12); //thruster (3/8 PI spread)
    
    myguns = new Gun[4];
    myguns[0] = new Gun(250 ,12,50  ,0.3927,color(255,255,255,150),1); //shotgun (1/8 PI spread)
    myguns[1] = new Gun(40  ,37,50,.01,        color(255,255,255),1);  //bolt
    myguns[2] = new Gun(5000,9 ,300,PI,    color(255,255,255),1);  //360 radial cannon
    myguns[3] = new Gun(10,  20,2  ,.003,        color(255,255,255),.35); //chaingun
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
