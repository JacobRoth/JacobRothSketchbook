/*DESCRIPTION ------
floVV is a 2d arena game based on realistic physics;

----------END DESCRIPTION*/
/*CONFIG------*/
final float globalfriction = 1;
final float wallreduce = .4;
final String[] playerWepKeys = {"1","2","3","4"};
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
  textFont(f,26);
  size(windowX,windowY,OPENGL);
  frameRate(60);
  
  /*try {
    fs.leave();
  } catch (Exception e) {
    //no fullscreen running,then
  }*/
  fs = new FullScreen(this);
  //fs.enter();
  gamesetup(); 
}

void gamesetup() {
  frameCount = 0;
  
  player = new Player(new PVector(200,200),24,24,color(0,0,0,0),new PVector(0,0),200);
  enemies = new ArrayList<GenericEnemy>();
  playersBullets = new ArrayList<PhysicsRect>();
  enemiesBullets = new ArrayList<PhysicsRect>();
  
}

void mousePressed() {
  
}


void draw(){
  if(mousePressed) {
    if (mouseButton == LEFT) {
      player.shootTowards(mouseX,mouseY,playersBullets);
    } else if (mouseButton == RIGHT) {
      player.thrustTowards(mouseX,mouseY,playersBullets);
    }
  }
  
  boolean gameover = false;
  
  background(0);
  
  stroke(255);
  line(1,1,1,windowY);
  line(1,windowY-1,windowX-1,windowY-1);
  line(windowX-1,windowY-1,windowX-1,1);
  line(windowX-1,1,1,1);
  
  fill(255);
  text("Health: "+(int)player.health,0,590);
  text(frameCount/60,770,590);
  
  player.render();
  player.update();
  //if(player.isOffSides(windowX,windowY)) player.speed = new PVector(0,0);
  player.frictionate(globalfriction);
  
  player.handleOffSides(windowX,windowY,wallreduce);
  if(player.health <= 0) gameover = true;
  
  if(frameCount%70==0) randInsertEnemy(enemies);
  
  for(int iii=0;iii<playersBullets.size();iii++) {
    PhysicsRect foo = (PhysicsRect)playersBullets.get(iii);
    foo.render();
    foo.update();
    //foo.frictionate(globalfriction);    //we'll exempt the bullets from friction, partly for gameplay and partly to reduce lag from all that calc
    if(foo.isOffSides(windowX,windowY)) playersBullets.remove(iii);
    for(int jjj=0;jjj<enemies.size();jjj++) {
      GenericEnemy e = (GenericEnemy)enemies.get(jjj);
      if(e.rectCollision(foo)) {
        e.takedamage(foo);
        playersBullets.remove(iii);
      }
    }
  }
  for(int iii=0;iii<enemiesBullets.size();iii++) {
    PhysicsRect foo = (PhysicsRect)enemiesBullets.get(iii);
    foo.render();
    if(foo.isOffSides(windowX,windowY)) enemiesBullets.remove(iii); 
    foo.update();
    if(foo.rectCollision(player)) {
      player.takedamage(foo); 
      enemiesBullets.remove(iii);
    }
  }
  for(int iii=0;iii<enemies.size();iii++) {
    GenericEnemy currentChar = enemies.get(iii);
    currentChar.render();
    currentChar.handleOffSides(windowX,windowY,wallreduce);
    currentChar.update();
    currentChar.frictionate(globalfriction);
    
    currentChar.aquireTarget(player,enemiesBullets);
    if(currentChar.health <=0) enemies.remove(iii);
  }

  if(gameover) gamesetup(); 
}


