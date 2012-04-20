/*CONFIG------*/
final float globalfriction = 0.98;
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

ArrayList<GenericEnemy> enemies;
ArrayList<PhysicsRect> playersBullets;
ArrayList<PhysicsRect> enemiesBullets;

void setup() {
  f = loadFont("AgencyFB-Reg-48.vlw");
  
  player = new Player(new PVector(200,200),24,24,color(0,0,0,0),new PVector(0,0),200);
  enemies = new ArrayList<GenericEnemy>();
  playersBullets = new ArrayList<PhysicsRect>();
  enemiesBullets = new ArrayList<PhysicsRect>();
  
  enemies.add(new Chaingunner(new PVector(400,300),10,10,color(0,0,0,0),new PVector(0,0)));
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
  
  
  
  if(player.isOffSides(windowX,windowY) || player.health <= 0) gameover = true;
  
  for(int iii=0;iii<playersBullets.size();iii++) {
    PhysicsRect foo = (PhysicsRect)playersBullets.get(iii);
    foo.render();
    foo.update();
    //foo.frictionate(globalfriction);    //we'll exempt the bullets from friction, partly for gameplay and partly to reduce lag from all that calc
    if(foo.isOffSides(windowX,windowY)) playersBullets.remove(iii);
  }
  for(int iii=0;iii<enemiesBullets.size();iii++) {
    PhysicsRect foo = (PhysicsRect)enemiesBullets.get(iii);
    foo.render();
    foo.update();
    if(foo.isOffSides(windowX,windowY)) enemiesBullets.remove(iii);
  }
  for(int iii=0;iii<enemies.size();iii++) {
    GenericEnemy currentChar = enemies.get(iii);
    currentChar.render();
    currentChar.update();
    currentChar.frictionate(globalfriction);
    for(int jjj=0;jjj<playersBullets.size();jjj++) {
      PhysicsRect foo = (PhysicsRect)playersBullets.get(jjj);
      if(foo.rectCollision(currentChar)) currentChar.takedamage(foo);
    }
    currentChar.aquireTarget(player,enemiesBullets);
    if(currentChar.isOffSides(windowX,windowY) || currentChar.health <=0) enemies.remove(iii);
  }

  if(gameover) setup(); //call to setup resets the game.
}


