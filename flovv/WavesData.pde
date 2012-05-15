class WavesData {
  int currentwave;
  public WavesData() { //all the data's in the code here
    currentwave = 0;
  }
  void inject(ArrayList enemys) {
    int enemySize = 20; //max size
    float enemyTopSpeed = 10;
    for(int iii=0;iii<=currentwave;iii++) {
      int screenedge = (int)(random(0,4));
      int posx = 0;
      int posy = 0;
      float speedx = 0;
      float speedy = 0;
      if (screenedge == 0) { //the left edge
        posx = 1;
        posy = (int)(random(0,windowY-enemySize));
        speedx = random(0,enemyTopSpeed);
        speedy = random(-1*enemyTopSpeed,enemyTopSpeed);
      } else if (screenedge == 1) { //the right edge
        posx = windowX-enemySize;
        posy = (int)(random(0,windowY-enemySize));
        speedx = random(-1*enemyTopSpeed,0);
        speedy = random(-1*enemyTopSpeed,enemyTopSpeed);
      } else if (screenedge == 2) { //the top
        posx = (int)(random(0,windowX-enemySize));
        posy = 0;
        speedx = random(-1*enemyTopSpeed, enemyTopSpeed);  
        speedy = random(0,enemyTopSpeed);
      } else if (screenedge == 3) { //the bottom
        posx = (int)(random(0,windowX-enemySize));
        posy = windowY-enemySize;
        speedx = random(-1*enemyTopSpeed, enemyTopSpeed);
        speedy = random(-1*enemyTopSpeed,0);
      }
      PVector pos = new PVector(posx,posy);
      PVector speed = new PVector(speedx,speedy);
      if((float)iii/currentwave<.10) {
        enemys.add(new Sniper(pos,speed));
      } else if((float)iii/currentwave<.20) {
        enemys.add(new Blocker(pos,speed));
      } else {
        enemys.add(new Chaingunner(pos,speed));
      }        
    }
    currentwave++;
  }
}

