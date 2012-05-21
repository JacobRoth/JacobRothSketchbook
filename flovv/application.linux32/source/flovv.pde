/*DESCRIPTION ------
floVV is a 2d arena game based on realistic physics!
projectile inheritance and physically realistic recoil (on the shooter and the target) are implemented.
bullet damage in floVV is calculated not based on weapon types or on arbitrary damage calculations, but on the actual kinetic force imparted by the bullet.
your only means of movement in floVV is weapon recoil, with some "thruster" weapons intended entirely for this purpose.

use WASD keys to move. Movement fires the "thruster" weapon. You can bouce off walls in this game, so bouce strategically
use the mouse to aim your weapon, then left click to fire your weapons. number keys 1 thru 4 switch weapons.

Enemies will arive in waves. Try to reach the highest wave you can. My record as the programmer is wave 10.

----------END DESCRIPTION*/
/*CONFIG------*/
final float globalfriction = 1; //1 = no friction; 0 = complete friction (no movement of objects)
final float wallreduce = .4;
final String[] playerWepKeys = {"1","2","3","4"};
final String[] playerMoveKeys = {"W","A","S","D"}; //in the format {Up, Left, Down, Right};
/*-----END CONFIG*/


import fullscreen.*;
import japplemenubar.*;
import processing.opengl.*;

final int windowX = 800;
final int windowY = 600;

FullScreen fs;
PFont f;
ArrayList<PVector> titleScreenPoints;
final int maxTSPoints = 50;

int gamestate;
WavesData wav;

Player player;
CharacterRect testchar;

ArrayList<GenericEnemy> enemies;
ArrayList<PhysicsRect> playersBullets;
ArrayList<PhysicsRect> enemiesBullets;

void setup() {
  gamestate = 0; //titleScreen
  f = loadFont("AgencyFB-Reg-48.vlw");
  textFont(f,26);
  titleScreenPoints = new ArrayList<PVector>();
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
  wav = new WavesData();
  enemies = new ArrayList<GenericEnemy>();
  playersBullets = new ArrayList<PhysicsRect>();
  enemiesBullets = new ArrayList<PhysicsRect>();
  
}

void titleScreen () {
  background(0);
  if(titleScreenPoints.size()>maxTSPoints) {
    titleScreenPoints = new ArrayList<PVector>();
  }
  if(frameCount%30==0) {
    titleScreenPoints.add(new PVector( random(0,windowX), random(0,windowY)));
  }
  for(PVector foo: titleScreenPoints) {
    stroke(200);
    //point(foo.x,foo.y);
    for(PVector other: titleScreenPoints) {
      if( sqrt(   (foo.x-other.x)*(foo.x-other.x) + (foo.y-other.y)*(foo.y-other.y)) < 200) { //dist formula
        line(foo.x,foo.y,other.x,other.y);
      }
    }
  }
  fill(0,255,120);
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
  if (checkKey("B")) {
    gamesetup();
  }
}

void gameCycle() {
  if (mousePressed  && mouseButton == LEFT) {
    player.shootTowards(mouseX,mouseY,playersBullets);
  } 
  //if (mousePressed  && mouseButton == RIGHT) {
  //  player.thrustTowards(mouseX,mouseY,playersBullets);
  //}
  
  boolean keyUp = checkKey(playerMoveKeys[0]);
  boolean keyDown = checkKey(playerMoveKeys[2]);
  boolean keyLeft = checkKey(playerMoveKeys[1]);
  boolean keyRight = checkKey(playerMoveKeys[3]);
  if(keyUp || keyDown || keyLeft || keyRight) {
    int xmod = 0;
    int ymod = 0;
    
    if(keyUp)  
      ymod = 1; 
    else if(keyDown) 
      ymod = -1;
    if(keyLeft) //left
      xmod = 1;
    else if(keyRight) //right
      xmod = -1;
    player.thrustTowards(player.getCX()+xmod,player.getCY()+ymod,playersBullets); 
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
  text("Wave: "+wav.currentwave,700,590);
  
  player.render();
  player.update();
  //if(player.isOffSides(windowX,windowY)) player.speed = new PVector(0,0);
  player.frictionate(globalfriction);
  
  player.handleOffSides(windowX,windowY,wallreduce);
  if(player.health <= 0) gameover = true;
  
  if(enemies.size() == 0) { //wave over!
    wav.update(enemies); //get a new wave for me
    player.refreshHealth();
  }
  
  for(int iii=0;iii<playersBullets.size();iii++) {
    PhysicsRect foo = (PhysicsRect)playersBullets.get(iii);
    foo.render();
    foo.update();
    //foo.frictionate(globalfriction);    //we'll exempt the bullets from friction, partly for gameplay and partly to reduce lag from all that calc
    if(foo.isOffSides(windowX,windowY)) {
      playersBullets.remove(iii);
    } else { //isn't off screen so check enemy collision
      for(int jjj=0;jjj<enemies.size();jjj++) {
        GenericEnemy e = (GenericEnemy)enemies.get(jjj);
        if(e.rectCollision(foo)) {
          e.takedamage(foo);
          playersBullets.remove(iii);
          break;
        }
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


