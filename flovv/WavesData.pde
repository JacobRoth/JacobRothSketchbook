class WavesData {
  int currentwave;
  String[][] waves;
  public WavesData() { //all the data's in the code here
    currentwave = 0;
    waves[0][0] = "Sniper";
    /*waves[0] = {"Sniper","Sniper","Sniper","Sniper","Chaingunner","Chaingunner"};
    waves[1] = {"Sniper","Sniper","Sniper","Sniper","Chaingunner","Chaingunner","Chaingunner"};
    waves[2] = {"Sniper","Sniper","Sniper","Sniper","Chaingunner","Chaingunner","Chaingunner","Chaingunner"};
    waves[3] = {"Sniper","Sniper","Sniper","Sniper","Chaingunner","Chaingunner","Chaingunner","Chaingunner","Blocker"};
    waves[4] = {"Sniper","Sniper","Sniper","Sniper","Chaingunner","Chaingunner","Chaingunner","Chaingunner","Blocker","Blocker"};
    waves[5] = {"Sniper","Sniper","Sniper","Sniper","Chaingunner","Chaingunner","Chaingunner","Chaingunner","Blocker","Blocker","Blocker"};
    waves[6] = {"Sniper","Sniper","Sniper","Sniper","Sniper","Chaingunner","Chaingunner","Chaingunner","Chaingunner","Blocker","Blocker","Blocker","Blocker"};*/
  }
}
void randInsertEnemy(ArrayList enemys) {
  int enemySize = 20; //max size
  float enemyTopSpeed = 10;
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
  int enemytype = (int)(random(0,3));
  if(enemytype == 0) 
    enemys.add(new Sniper(new PVector(posx,posy),new PVector(speedx,speedy)));
  /*else if(enemytype == 1)
    enemys.add(new Chaingunner(new PVector(posx,posy),new PVector(speedx,speedy)));
  else if(enemytype == 2)
    enemys.add(new Blocker(new PVector(posx,posy),new PVector(speedx,speedy)));*/
}
