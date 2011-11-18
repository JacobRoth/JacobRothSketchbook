
class Source { 
  int x;
  int y;
  float speed;
  int r;
  int g;
  int b;
  Trigger timer;
  
  Source (int inx, int iny, float inspeed, int ir, int ig, int ib, int rate) {
    x = inx;
    y = iny;
    speed = inspeed;
    r=ir;
    g=ig;
    b=ib;
    timer = new Trigger(rate);
  }
  
  
  void handle(ArrayList holdbullet, int windowSize) {
    x = (int)(500*noise(globalnoise));
    globalnoise += .002;
    y = (int)(500*noise(globalnoise));
    globalnoise += .002;
    while (timer.fires()) {
      float randX = random(-1*speed, speed);
      float randY = random(-1*speed, speed);
      
      holdbullet.add(new Bullet(x, y, 5, 5, r, g, b, randX, randY));
    }
  }
}


