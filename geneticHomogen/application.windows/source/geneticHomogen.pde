final int windowSize = 500;
final int numOrgs = 10;


Rectangle[] myRects;
int locationX, locationY;


void setup () {
  myRects = new Rectangle[numOrgs];
  for (int iii=0; iii <= (numOrgs-1); iii++) {
    locationX = int(random(windowSize));
    locationY = int(random(windowSize));
    myRects[iii] = new Rectangle(locationX, locationY);
  }
  size(windowSize,windowSize);
  noStroke();
}

void draw () {
  background(0);
  for (int iii=0; iii <= (numOrgs-1); iii++) {
    myRects[iii].update();
    for (int jjj=0; jjj<= (numOrgs-1); jjj++) {
      if (iii != jjj) { //not the same rect
        boolean coll = collDetect(myRects[iii],myRects[jjj]);
        if (coll == true) {
          int localR = (myRects[iii].r+myRects[jjj].r)/2;
          int localG = (myRects[iii].g+myRects[jjj].g)/2;
          int localB = (myRects[iii].b+myRects[jjj].b)/2;
          myRects[iii].r = localR;
          myRects[iii].g = localG;
          myRects[iii].b = localB;
          
          myRects[jjj].r = localR;
          myRects[jjj].g = localG;
          myRects[jjj].b = localB;
        }
      }
    }
  }
}

boolean collDetect(Rectangle rect1, Rectangle rect2) { // this will be collison detection
  if (rect1.x+rect1.w < rect2.x) { return false; }
  if (rect1.x > rect2.x+rect2.w) { return false; }
  if (rect1.y+rect1.h < rect2.y) { return false; }
  if (rect1.y > rect2.y+rect2.h) { return false; }
  return true;      
}

class Rectangle {
  int x; //position
  int y;
  
  int h;
  int w;
  
  int mvmntx;
  int mvmnty;
  
  int r;
  int g;
  int b;
    
  Rectangle (int c1x, int c1y) {
    x = c1x;
    y = c1y;
    h = 20;
    w = 20;
    r = round(random(255));
    g = round(random(255));
    b = round(random(255));
    mvmntx = round(random(-2,3)); 
    mvmnty = round(random(-2,3)); 
  }
  
  void boundryCheck() {
    if (x < 0) {
      mvmntx = round(random(1,3));
      if (mvmnty == 0) { //fix the "straight movement" problem
        mvmnty = round(random(-2,3)); 
      }
    }
    if (x+w > windowSize) {
      mvmntx = round(random(-2,0));
      if (mvmnty == 0) { //fix the "straight movement" problem
        mvmnty = round(random(-2,3)); 
      }
    }
    
    
    if (y < 0) {
      mvmnty = round(random(1,3));
      if (mvmntx == 0) { //fix the "straight movement" problem
        mvmntx = round(random(-2,3)); 
      }
    }  
    if (y+h > windowSize) {
      mvmnty = round(random(-2,0));
      if (mvmntx == 0) { //fix the "straight movement" problem
        mvmntx = round(random(-2,3)); 
      }
    }
  }
    
  void moveRect() {
    x = x+mvmntx;
    y = y+mvmnty;
  }
  
  void render () {
    fill(r,g,b);
    rect(x,y,w,h);
  }
  
  void update() {
    boundryCheck();
    moveRect();
    render();
  }
}
