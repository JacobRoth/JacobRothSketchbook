class Layer { //has-a fighter, source, bullet ArrayList
  Fighter thisFighter;
  Source thisSource;
  ArrayList thisBullets;
  float speed;
  int r;
  int g;
  int b;
  Layer(float inspeed, int inr, int ing, int inb, int rate) {
    speed = inspeed;
    r = inr;
    g = ing;
    b = inb;
    thisFighter = new Fighter((int)random(windowSize), (int)random(windowSize), 10, 10, r, g, b, speed*1.5);
    thisSource = new Source(windowSize/2,windowSize/2,speed,r,g,b,rate);
    thisBullets = new ArrayList();
  }
  void activeCycle() {
    for (int iii=0; iii <= (thisBullets.size()-1); iii++) {
      Bullet currentbullet = (Bullet) thisBullets.get(iii);
      currentbullet.render();
      currentbullet.boundrycheck(thisBullets);
      currentbullet.moveSelf();
      if(collDetect(thisFighter,currentbullet)) {
        thisFighter.r=255;
        thisFighter.g=255;
        thisFighter.b=255;
        if (!invincible) gameRunning = false;
      }
    }
    if (gameRunning) thisFighter.moveSelf();
    thisFighter.boundrycheck(windowSize);
    thisFighter.render();
    thisSource.handle(thisBullets,500);
    thisSource.render();
  }
  void frozenCycle() {
    for (int iii=0; iii <= (thisBullets.size()-1); iii++) {
      Bullet currentbullet = (Bullet) thisBullets.get(iii);
      currentbullet.render();
    }
    thisFighter.render();
    thisSource.render();
  }
}
