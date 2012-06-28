//note on mass-energy conversion - in this game, we'll just go ahead and say that 1 unit of mass equals
// applyforce(new PVector(k,j)); where k+j=1, therefore making it a unit vector.
import processing.opengl.*;

final int windowX = 1440;
final int windowY = 900;
final int halfWindowX = windowX/2;
final int halfWindowY = windowY/2;
      int offsetX = 0; //offset
      int offsetY = 0; //offset
    float scalefactor = 1;
    
    
//final double universalGravConst = 6.67e-11; //not helpful

ArrayList<Oid> oids;
PlayerOid player;

void setup() {
  size(windowX, windowY, OPENGL);
  oids = new ArrayList<Oid>();
  
  //crazy code that makes the mouse wheel work.
  addMouseWheelListener(new MouseWheelListener() {     public void mouseWheelMoved(MouseWheelEvent mwe) {       mouseWheel(mwe.getWheelRotation());   }}); 
  
  //oids.add(new Oid(new PVector(400,000),new PVector(0 ,0),10,color(255,255,0),color(255,0,0)));
  player = new PlayerOid(new PVector(200, 200), new PVector(0, 0),60, color(255, 255, 0), color(255, 0, 0));
  oids.add(player);
  //for(int urph = 0; urph< 5; urph++) oids.add(new Oid(new PVector(random(0,100),random(0,100)),      new PVector(random(0,1000),random(-10,10)),   random(1,190),color(255,255,0),color(255,0,0)));
  //for(int urph = 0; urph< 5; urph++) oids.add(new Oid(new PVector(random(1900,2100),random(0,100)),  new PVector(random(-10,10),random(0,1000)),   random(1,40),color(255,255,0),color(255,0,0)));
}
void draw() {
  scale(scalefactor);
  
  //println(frameRate);

  if(!player.dead) {
    focusOnPoint(player.pos);
  }

  background(0);
  drawGuideLines();

  for (int iii=0;iii<oids.size();iii++) {
    Oid foo = (Oid)oids.get(iii);
    foo.render(offsetX,offsetY);
    foo.update();
    for (int jjj=0;jjj<oids.size();jjj++) {
      if (jjj!=iii) {
        Oid other = (Oid)oids.get(jjj);
        foo.collisionCode(other);
        //foo.gravitate(other);
      }
    }
    if (foo.dead) oids.remove(iii);
  }
  for(Oid foo: oids) {
    for(Oid other:oids) {
      if(!foo.equals(other)) foo.gravitate(other);
    }
  }
  if(checkKey("Q")) { //zoom
    scalefactor*=1.01;
  } else if (checkKey("E")) { //zoom
    scalefactor*=.99;
  } 
  /*
  if(mousePressed) {
    Oid nearest = findNearestOidToPointTEST(oids, translateClickToPoint(mouseX,mouseY));
    if(nearest==null) {
      println("can't find any");
    }
    if(nearest != null) {
      nearest.col = color(0,0,0);
      println(nearest.rad);
      if(nearest.equals(player)) {
        println("it's the player!");
      }
    }
  }*/
  
}
void drawGuideLines() {
  stroke(255,0,0);
  line(0-offsetX,0-offsetY,100-offsetX,0-offsetY);
  line(0-offsetX,0-offsetY,0-offsetX,100-offsetY);
  stroke(0,0,255);
  line(100-offsetX,100-offsetY,1000-offsetX,100-offsetY);
  line(100-offsetX,100-offsetY,100-offsetX,1000-offsetY);
  stroke(0,255,0);
  line(1000-offsetX,1000-offsetY,10000-offsetX,1000-offsetY);
  line(1000-offsetX,1000-offsetY,1000-offsetX,10000-offsetY);
  stroke(0,255,255);
  line(10000-offsetX,10000-offsetY,100000-offsetX,10000-offsetY);
  line(10000-offsetX,10000-offsetY,10000-offsetX,100000-offsetY);
  stroke(255,0,100);
  line(100000-offsetX,100000-offsetY,1000000-offsetX,100000-offsetY);
  line(100000-offsetX,100000-offsetY,100000-offsetX,1000000-offsetY);
}
void focusOnPoint(PVector gamepoint) {
  offsetX = (int)(gamepoint.x-(halfWindowX/scalefactor));
  offsetY = (int)(gamepoint.y-(halfWindowY/scalefactor));
}


  

