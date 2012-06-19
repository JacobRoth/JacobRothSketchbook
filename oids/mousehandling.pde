import java.awt.event.*;

void mouseClicked() {
  println((mouseX*(1/scalefactor))+offsetX);
  println((mouseY*(1/scalefactor))+offsetY);
  for(int urph = 0; urph< 15; urph++) oids.add(new Oid(new PVector(random(0,80),random(0,80)),          new PVector(random(0,22),random(-1,1)),   random(1,5),color(255,255,0),color(255,0,0)));
  for(int urph = 0; urph< 15; urph++) oids.add(new Oid(new PVector(random(800,880),random(0,80)),      new PVector(random(-1,1),random(0,22)),   random(1,5),color(255,255,0),color(255,0,0)));
  for(int urph = 0; urph< 15; urph++) oids.add(new Oid(new PVector(random(800,880),random(800,880)),  new PVector(random(-22,0),random(-1,1)),  random(1,5),color(255,255,0),color(255,0,0)));
  for(int urph = 0; urph< 15; urph++) oids.add(new Oid(new PVector(random(0,80),random(800,880)),      new PVector(random(-1,1),random(-22,0)),  random(1,5),color(255,255,0),color(255,0,0)));
}
 
//setup mousewheel listener like this in your setup() method:
//addMouseWheelListener(new MouseWheelListener() {     public void mouseWheelMoved(MouseWheelEvent mwe) {       mouseWheel(mwe.getWheelRotation());   }}); 

 
void mouseWheel(int delta) {
  println("mouse has moved by " + delta + " units."); 
}
