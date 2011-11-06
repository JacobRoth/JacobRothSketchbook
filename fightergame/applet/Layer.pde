class Layer { //has-a fighter, source, bullet ArrayList
  Fighter thisFighter;
  Source thisSource;
  ArrayList thisBullets;
  Layer(Fighter inFighter,ArrayList inBullets, Source inSource) {
    thisFighter = inFighter;
    thisSource = inSource;
    thisBullets = inBullets;
  }
  void activeCycle() {
    for (int iii=0; iii <= (thisBullets.size()-1); iii++) {
      Bullet currentbullet = (Bullet) thisBullets.get(iii);
      currentbullet.render();
      currentbullet.boundrycheck(thisBullets);
      currentbullet.moveSelf();
      if(collDetect(thisFighter,currentbullet)) {
        gameRunning = false;
      }
    }
    if (gameRunning) thisFighter.moveSelf();
    thisFighter.boundrycheck(windowSize);
    thisFighter.render();
    thisSource.handle(layer1.thisBullets,difficulty,500);
  }
  void frozenCycle() {
    for (int iii=0; iii <= (thisBullets.size()-1); iii++) {
      Bullet currentbullet = (Bullet) thisBullets.get(iii);
      currentbullet.render();
    }
    thisFighter.render();
  }
}