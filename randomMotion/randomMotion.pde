class Particle {
  float x;
  float y;
  Particle(float inx, float iny) {
    x = inx;
    y = iny;
  }
  void render() {
    point(x,y);
  }
  void moveself() {
    x = x+random(-1,1.0000001);
    y = y+random(-1,1.0000001);
    if (x<0) {
      x = 0;
    } else if (x > 499) {
      x = 499;
    }
    
    if (y<0) {
      y = 0;
    } else if (y > 499) {
      y = 499;
    }
    
  }
}

Particle[] partlist;

void setup() {
  size(500,500);
  frameRate(60);
  partlist = new Particle[20000];
  for (int iii=0; iii<=19999; iii++) {
    partlist[iii] = new Particle(random(200,400),random(200,400));
  }
}

void draw() {
  background(255);
  for (int iii=0; iii<=19999; iii++) {
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].moveself();
    partlist[iii].render();
  }
}
