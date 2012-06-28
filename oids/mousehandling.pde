import java.awt.event.*;

void mouseClicked() {
  println(translateClickToPoint(mouseX,mouseY));
  for(int urph = 0; urph< 15; urph++) oids.add(new Oid(new PVector(random(0,80),random(0,80)),          new PVector(random(0,22),random(-1,1)),   random(1,5),color(255,0,255),color(255,0,0)));
  for(int urph = 0; urph< 15; urph++) oids.add(new Oid(new PVector(random(800,880),random(0,80)),      new PVector(random(-1,1),random(0,22)),   random(1,5),color(255,0,255),color(255,0,0)));
  for(int urph = 0; urph< 15; urph++) oids.add(new Oid(new PVector(random(800,880),random(800,880)),  new PVector(random(-22,0),random(-1,1)),  random(1,5),color(255,0,255),color(255,0,0)));
  for(int urph = 0; urph< 15; urph++) oids.add(new Oid(new PVector(random(0,80),random(800,880)),      new PVector(random(-1,1),random(-22,0)),  random(1,5),color(255,0,255),color(255,0,0)));
}
PVector translateClickToPoint(float x, float y) {
  return new PVector(    (x*(1/scalefactor))+offsetX,           (y*(1/scalefactor))+offsetY);
} 
 
//setup mousewheel listener like this in your setup() method:
//addMouseWheelListener(new MouseWheelListener() {     public void mouseWheelMoved(MouseWheelEvent mwe) {       mouseWheel(mwe.getWheelRotation());   }}); 

 
void mouseWheel(int delta) {
  println("mouse has moved by " + delta + " units."); 
}
