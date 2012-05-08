/*DESCRIPTION ------
floVV is a 2d arena game based on realistic physics!
projectile inheritance and physically realistic recoil (on the shooter and the target) are implemented.
bullet damage in floVV is calculated not based on weapon types or on arbitrary damage calculations, but on the actual kinetic force imparted by the bullet.
your only means of movement in floVV is weapon recoil, with some "thruster" weapons intended entirely for this purpose.

use the mouse to aim your character, then right click on the game screen to use your jets and left click to fire your weapons. number keys 1 thru 4 switch weapons.

----------END DESCRIPTION*/
/*CONFIG------*/
final float globalfriction = 1;
final float wallreduce = .4;
final String[] playerWepKeys = {"1","2","3","4"};
final String thrustKey = "W";
final String gunKey = "Q";
/*-----END CONFIG*/


import fullscreen.*;
import japplemenubar.*;
import processing.opengl.*;

final int windowX = 800;
final int windowY = 600;

FullScreen fs;
PFont f;
int gamestate;

Player player;
CharacterRect testchar;

ArrayList<GenericEnemy> enemies;
ArrayList<PhysicsRect> playersBullets;
ArrayList<PhysicsRect> enemiesBullets;

void setup() {
  gamestate = 0; //titleScreen
  f = loadFont("AgencyFB-Reg-48.vlw");
  textFont(f,26);
  size(windowX,windowY,OPENGL);
  frameRate(60);
  
  /*try {
    fs.leave();
  } catch (Exception e) {
    //no fullscreen running,then
  }*/
  //fs = new FullScreen(this);
  //fs.enter(); 
}

void gamesetup() {
  frameCount = 0;
  gamestate = 1; //running
  player = new Player(new PVector(200,200),24,24,color(0,0,0,0),new PVector(0,0),300);
  enemies = new ArrayList<GenericEnemy>();
  playersBullets = new ArrayList<PhysicsRect>();
  enemiesBullets = new ArrayList<PhysicsRect>();
  
}

void titleScreen () {
  background(0);
  fill(0,0,255);
  textFont(f, 48);
  text("f", 50, 100);
  text("l", 90, 100);
  text("o", 140,100);
  text("V", 240,100);
  text("V", 350,100);
  text("Beta!!111!!!!!111!",400,200);
  text("By Yanom", 100, 300);
  textFont(f, 36);
  text("Press B to start", 200, 350);
  if (checkKey("b")) {
    gamesetup();
  }
}

void gameCycle() {
  if (checkKey(gunKey) || (mousePressed  && mouseButton == LEFT)) {
    player.shootTowards(mouseX,mouseY,playersBullets);
  } else if (checkKey(thrustKey) || (mousePressed  && mouseButton == RIGHT)) {
    player.thrustTowards(mouseX,mouseY,playersBullets);
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

  if(gameover) gamestate =0; 
}

void draw(){
  if(gamestate == 0) {
    titleScreen();
  } else if (gamestate==1) {
    gameCycle();
  }
}


