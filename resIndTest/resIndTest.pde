class ResInd {
  final int sizex;//size x and y of the virtual screen
  final int sizey;
  final int destx;//destination-x and destination-y - dims of the surface where it gets rendered
  final int desty;
  ResInd(float x, float y, float dx, float dy) {
    sizex = (int)x;
    sizey = (int)y;
    destx = (int)dx;
    desty = (int)dy;
  }
  int x(float in) {
    return (int)(destx*(in/sizex));
  }
  int y(float in) {
    return (int)(desty*(in/sizey));
  }
}
ResInd r;
void setup() {
  size(1440,1080);
  r = new ResInd(640,480,1400,1050);
}
void draw() {
  point(r.x(200),r.y(200));
  rect(r.x(20),r.y(200),r.x(20),r.y(20));
}
boolean sketchFullScreen() { return true; }

PVector resInd(int x, int y) {
  return(new PVector(screenWidth*(x/640.0), screenHeight*(y/480.0)));
} 
