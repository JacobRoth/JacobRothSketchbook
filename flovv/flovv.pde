import fullscreen.*;
import japplemenubar.*;
import processing.opengl.*;
FullScreen fs;
PFont f;

PhysicsRect recto;
PhysicsRect recte;
ArrayList enemies;
ArrayList playersBullets;
ArrayList enemiesBullets;

final float globalfriction = 0.995;

void setup() {
  f = loadFont("AgencyFB-Reg-48.vlw");
  recto = new PhysicsRect(new PVector(0,200),0,0,color(255,255,0),new PVector(600,600),200);
  recte = new PhysicsRect(new PVector(200,0),0,0,color(255,0,255),new PVector(40,40),25);
  
  size(800, 600,OPENGL);
  frameRate(60);
  
  /* fs = new FullScreen(this);
  fs.enter(); */
}


void draw(){
  background(0);
  recto.render();
  recto.update();
  recto.frictionate(globalfriction);
  
  recte.render();
  recte.update();
  recte.frictionate(globalfriction);
}


