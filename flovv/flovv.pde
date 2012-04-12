import fullscreen.*;
import japplemenubar.*;
import processing.opengl.*;

final int windowX = 800;
final int windowY = 600;

FullScreen fs;
PFont f;

PlayerRect player;

ArrayList enemies;
ArrayList<PhysicsRect> playersBullets;
ArrayList<PhysicsRect> enemiesBullets;

final float globalfriction = 0.99;

void setup() {
  f = loadFont("AgencyFB-Reg-48.vlw");
  player = new PlayerRect(new PVector(200,200),24,24,color(0,0,0,0),new PVector(0,0),200);
  playersBullets = new ArrayList<PhysicsRect>();
  
  size(windowX,windowY,OPENGL);
  frameRate(60);
  
  /* fs = new FullScreen(this);
  fs.enter(); */
}


void draw(){
  boolean gameover = false;
  
  background(0);
  player.render();
  player.update();
  player.frictionate(globalfriction);
  if(mousePressed) player.shootTowards(mouseX,mouseY,playersBullets);
  if(player.isOffSides(windowX,windowY)) gameover = true;
  
  for(int iii=0;iii<playersBullets.size();iii++) {
    PhysicsRect foo = (PhysicsRect)playersBullets.get(iii);
    foo.render();
    foo.update();
    foo.frictionate(globalfriction);
    if(foo.isOffSides(windowX,windowY)) playersBullets.remove(iii);
  }
  if(gameover) setup(); //call to setup resets the game.
}


