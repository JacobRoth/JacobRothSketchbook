float jjj;
void setup() {
  size(300,300);
  jjj=0;
}
void draw() {
  background(140);
  line(150,150,mouseX,mouseY);
  //line(150,150,mouseX,150);
  //line(mouseX,150,mouseX,mouseY);
  float dy = mouseY-150;
  float dx = mouseX-150;
  
  
  float atanval = atan2(dx,dy); //dist-x, dist-y - the initial vector
  PVector oneVec = new PVector(sin(atanval+.1),cos(atanval+.1)); //add or sub from that ATAN
  PVector twoVec = new PVector(sin(atanval-.1),cos(atanval-.1)); // ''
  oneVec.mult(150); //scale to match
  twoVec.mult(150);
  line(150,150,150+oneVec.x,150+oneVec.y);
  line(150,150,150+twoVec.x,150+twoVec.y);
  println("--------------------------------------");
 
}
