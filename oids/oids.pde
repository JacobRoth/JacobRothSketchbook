import processing.opengl.*;

final int windowX = 1440;
final int windowY = 900;
final int halfWindowX = windowX/2;
final int halfWindowY = windowY/2;
      int offsetX = 0; //offset
      int offsetY = 0; //offset
    float scalefactor = 1;
      int currentoidfocusedTEMP = 0;

ArrayList<Oid> oids;
Oid thisoidisspecial; //later this will be player of class playerOid. Right now


void setup() {
  size(windowX, windowY, OPENGL);
  oids = new ArrayList<Oid>();
  //oids.add(new Oid(new PVector(400,000),new PVector(0 ,0),10,color(255,255,0),color(255,0,0)));
  thisoidisspecial = new Oid(new PVector(2000, 2000), new PVector(0, 0),600, color(255, 255, 0), color(255, 0, 0));
  oids.add(thisoidisspecial);
  //for(int urph = 0; urph< 5; urph++) oids.add(new Oid(new PVector(random(0,100),random(0,100)),      new PVector(random(0,1000),random(-10,10)),   random(1,190),color(255,255,0),color(255,0,0)));
  //for(int urph = 0; urph< 5; urph++) oids.add(new Oid(new PVector(random(1900,2100),random(0,100)),  new PVector(random(-10,10),random(0,1000)),   random(1,40),color(255,255,0),color(255,0,0)));
}
void draw() {
  scale(scalefactor);

  if(oids.size()>0) { //make sure there's something to focus
    if(currentoidfocusedTEMP>=oids.size() || currentoidfocusedTEMP < 0) {
      //something's gone horribly wrong! most likely an oid got eaten. Set the focus back to 0.
      currentoidfocusedTEMP = 0;
    }
    focusOnPoint(oids.get(currentoidfocusedTEMP).pos);
  }

  background(0);
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
  /*
  if(checkKey("W")) {
    offsetY-=1/scalefactor;
  } else if (checkKey("S")) {
    offsetY+=1/scalefactor;
  }
  if(checkKey("A")) {
    offsetX-=1/scalefactor;
  } else if(checkKey("D")) {
    offsetX+=1/scalefactor;
  }*/
  if(checkKey("Q")) {
    scalefactor*=1.01;
  } else if (checkKey("E")) {
    scalefactor*=.99;
  }
  if(checkKey("R") && currentoidfocusedTEMP<oids.size()-1) {
    currentoidfocusedTEMP++;
  } else if(checkKey("F") && currentoidfocusedTEMP>0) {
    currentoidfocusedTEMP--;
  }
    
}
void focusOnPoint(PVector gamepoint) {
  offsetX = (int)(gamepoint.x-(halfWindowX/scalefactor));
  offsetY = (int)(gamepoint.y-(halfWindowY/scalefactor));
}
  

