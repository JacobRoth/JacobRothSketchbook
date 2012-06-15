
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
  void render() {
    stroke(r,g,b);
    noFill();
    line(x,y+8,x-4,y-4);
    line(x-4,y-4,x+4,y-4); //triangle yay
    line(x+4,y-4,x,y+8);
  }
  
  void handle(ArrayList holdbullet, int windowSize) {
    if(sourceDrift) {
      if(x>windowSize) {
        x-=sourceDriftSpeed;
      } else if (x<0) {
        x+=sourceDriftSpeed;
      } else {
        x+=random(-1*sourceDriftSpeed,sourceDriftSpeed+1);
      }
      if(y>windowSize) {
        y-=sourceDriftSpeed;
      } else if (y<0) {
        y+=sourceDriftSpeed;
      } else {
        y+=random(-1*sourceDriftSpeed,sourceDriftSpeed+1);
      }
    }
    
    
    while (timer.fires()) {
      float randX = random(-1*speed, speed);
      float randY = random(-1*speed, speed);
      holdbullet.add(new Bullet(x, y, 5, 5, r, g, b, randX, randY));
    }
  }
}


