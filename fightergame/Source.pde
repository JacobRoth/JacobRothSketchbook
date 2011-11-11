
class Source { 
  int x;
  int y;
  float speed;
  int r;
  int g;
  int b;

  Source () {
    x = 250;
    y = 250;
    speed = 5.0;
    r=255;
    g=0;
    b=0;
  }  
  
  Source (int inx, int iny) {
    x = inx;
    y = iny;
    speed = 5.0;
    r=255;
    g=0;
    b=0;
  }
  
  Source (int inx, int iny, float inspeed) {
    x = inx;
    y = iny;
    speed = inspeed;
    r=255;
    g=0;
    b=0;
  }
  
  Source (int inx, int iny, float inspeed, int ir, int ig, int ib) {
    x = inx;
    y = iny;
    speed = inspeed;
    r=ir;
    g=ig;
    b=ib;
  }
  
  
  void handle(ArrayList holdbullet, int numbullets, int windowSize) {
    /*
    if (goingRight) {
      x += 6;
    } 
    else {
      x -= 6;
    }
    if (x<8) {
      goingRight = true;
    } 
    if (x>(windowSize-8)) {
      goingRight = false;
    }
    */

    for (int iii=1; iii<=numbullets; iii++) { 
      float randX = random(-1*speed, speed);
      float randY = random(-1*speed, speed);
      
      holdbullet.add(new Bullet(x, y, 10, 10, r, g, b, randX, randY));
    }
  }
}


