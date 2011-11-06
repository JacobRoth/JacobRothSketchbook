final int windowSize = 500;
final int numOrgs = 10;
final int deathonTouch = 10; // this means 1/10 th chance

final boolean AGING = false;

ArrayList myRects;
int locationX, locationY;


void setup () {
  myRects = new ArrayList();
  for (int iii=0; iii <= (numOrgs-1); iii++) {
    locationX = int(random(windowSize));
    locationY = int(random(windowSize));
    myRects.add(new Rectangle(locationX, locationY));
  }
  size(windowSize, windowSize);
  noStroke();
  frameRate(60);
}

void draw () {
  background(255);
  iterateRects();
}

void iterateRects () {
  for (int iii=0; iii <= (myRects.size()-1); iii++) {
    Rectangle firstrect = (Rectangle) myRects.get(iii);
    firstrect.update(myRects);
    
    for (int jjj=0; jjj<= (myRects.size()-1); jjj++) {
      Rectangle secondrect = (Rectangle) myRects.get(jjj);
      if (iii != jjj) { //not the same rect
        boolean coll = collDetect(firstrect, secondrect);
        if (coll) {
          handleColl(firstrect,secondrect);
        }
      }
    }
  }
}
void handleColl(Rectangle firstrect, Rectangle secondrect) {
  if ( round(random(1,deathonTouch)) == 3) {
    myRects.remove(firstrect);
    myRects.remove(secondrect);
  }
  firstrect.mvmntx = firstrect.mvmntx-(firstrect.mvmntx*2);
  secondrect.mvmntx = secondrect.mvmntx-(secondrect.mvmntx*2);
  firstrect.x = firstrect.x+(firstrect.mvmntx*15);
  secondrect.x = secondrect.x+(secondrect.mvmntx*15);
}

void conjugate (Rectangle firstrect, Rectangle secondrect) {
  int localR = (firstrect.r+secondrect.r)/2;
  int localG = (firstrect.g+secondrect.g)/2;
  int localB = (firstrect.b+secondrect.b)/2;
  firstrect.r = localR;
  firstrect.g = localG;
  firstrect.b = localB;
  secondrect.r = localR;
  secondrect.g = localG;
  secondrect.b = localB;
}

boolean collDetect(Rectangle rect1, Rectangle rect2) { // this will be collison detection
  if (rect1.x+rect1.w < rect2.x) { 
    return false;
  }
  if (rect1.x > rect2.x+rect2.w) { 
    return false;
  }
  if (rect1.y+rect1.h < rect2.y) { 
    return false;
  }
  if (rect1.y > rect2.y+rect2.h) { 
    return false;
  }
  return true;
}

