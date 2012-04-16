/*CONFIG------*/
final float globalfriction = 0.99;
final String[] playerWepKeys = {"7","8","9","0"};
/*-----END CONFIG*/


import fullscreen.*;
import japplemenubar.*;
import processing.opengl.*;

final int windowX = 800;
final int windowY = 600;

FullScreen fs;
PFont f;

Player player;
CharacterRect testchar;

ArrayList enemies;
ArrayList<PhysicsRect> playersBullets;
ArrayList<PhysicsRect> enemiesBullets;

void setup() {
  f = loadFont("AgencyFB-Reg-48.vlw");
  player = new Player(new PVector(200,200),24,24,color(0,0,0,0),new PVector(0,0),200);
  testchar = new CharacterRect(new PVector(400,300),24,24,color(0,0,0,0),new PVector(0,0),200,60,loadImage("null.png"));
  playersBullets = new ArrayList<PhysicsRect>();
  
  size(windowX,windowY,OPENGL);
  frameRate(60);
  
  try {
    fs.leave();
  } catch (Exception e) {
    //no fullscreen running,then
  } 
  //fs = new FullScreen(this);
  //fs.enter(); 
}


void draw(){
  boolean gameover = false;
  
  background(0);
  player.render();
  player.update();
  player.frictionate(globalfriction);
  if(mousePressed) player.shootTowards(mouseX,mouseY,playersBullets);
  
  testchar.render();
  testchar.update();
  testchar.frictionate(globalfriction);
  
  if(player.isOffSides(windowX,windowY) || player.health <= 0) gameover = true;
  
  for(int iii=0;iii<playersBullets.size();iii++) {
    PhysicsRect foo = (PhysicsRect)playersBullets.get(iii);
    foo.render();
    foo.update();
    //foo.frictionate(globalfriction);    //we'll exempt the bullets from friction, partly for gameplay and partly to reduce lag from all that calc
    if(foo.isOffSides(windowX,windowY)) playersBullets.remove(iii);
    if(foo.rectCollision(testchar)) testchar.takedamage(foo);
  }
  println(testchar.health);
  if(gameover) setup(); //call to setup resets the game.
}


