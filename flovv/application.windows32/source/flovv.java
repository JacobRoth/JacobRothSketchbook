import processing.core.*; 
import processing.xml.*; 

import fullscreen.*; 
import japplemenubar.*; 
import processing.opengl.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class flovv extends PApplet {

/*DESCRIPTION ------
floVV is a 2d arena game based on realistic physics!
projectile inheritance and physically realistic recoil (on the shooter and the target) are implemented.
bullet damage in floVV is calculated not based on weapon types or on arbitrary damage calculations, but on the actual kinetic force imparted by the bullet.
your only means of movement in floVV is weapon recoil, with some "thruster" weapons intended entirely for this purpose.

use the mouse to aim your character, then right click on the game screen to use your jets and left click to fire your weapons. number keys 1 thru 4 switch weapons.

----------END DESCRIPTION*/
/*CONFIG------*/
final float globalfriction = 1;
final float wallreduce = .4f;
final String[] playerWepKeys = {"1","2","3","4"};
final String thrustKey = "W";
final String gunKey = "Q";
/*-----END CONFIG*/






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

public void setup() {
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

public void gamesetup() {
  frameCount = 0;
  gamestate = 1; //running
  player = new Player(new PVector(200,200),24,24,color(0,0,0,0),new PVector(0,0),300);
  enemies = new ArrayList<GenericEnemy>();
  playersBullets = new ArrayList<PhysicsRect>();
  enemiesBullets = new ArrayList<PhysicsRect>();
  
}

public void titleScreen () {
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

public void gameCycle() {
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

public void draw(){
  if(gamestate == 0) {
    titleScreen();
  } else if (gamestate==1) {
    gameCycle();
  }
}


class Gun { //shoots little green squares.
  int numprojectiles;
  float projectilespeed;
  float projectilemass;
  
  int firerate; //is actually frames between shots
  float spreadangle; //in RADIANS, NOT degrees.
  long lastframeshot;
  
  int col;
  
  Gun(int numpr, float ps, int frate, float spreadradians, int incol, float inmass) { 
    numprojectiles = numpr;
    projectilespeed = ps;
    projectilemass = inmass;
    firerate = frate;
    spreadangle = spreadradians;
    lastframeshot = frameCount;
    col = incol;
  }
  
  
  public PVector computeShot(MotileRect theShooter, float destX, float destY) {
    float atanval = atan2(destX-theShooter.getCX(),destY-theShooter.getCY()); //find the heading of where were shooting
    float sinRandomness = atanval+random(-1*spreadangle,spreadangle);
    float cosRandomness = atanval+random(-1*spreadangle,spreadangle);
    PVector effect = new PVector(sin(sinRandomness),cos(cosRandomness)); //add or sub from that ATAN
                      
    effect.normalize();
    effect.mult(projectilespeed);
        
    return effect.get();
  }
  public PVector advShot(PhysicsRect theShooter, float destX, float destY) { 
    PVector newV = computeShot(theShooter,destX,destY);
    
    PVector counterV = newV.get();
    counterV.mult(-1);                   //these bits apply recoil
    counterV.mult(projectilemass);       //recoil
    theShooter.applyforce(counterV);     //recoil
    
    newV.add(theShooter.speed); //projectile inheritance! SHAZBOT!
    
    return newV;
  }
  
  public void fire(PhysicsRect theShooter, float Xloc, float Yloc, ArrayList putBulletsHere) { 
    if(lastframeshot+firerate<frameCount) { //enough frames has past
      for(int iii=0;iii<numprojectiles;iii++) { //shot several if we want
        lastframeshot = frameCount;
        putBulletsHere.add(new PhysicsRect(new PVector(theShooter.getCX(),theShooter.getCY()),0,0,col,advShot(theShooter,Xloc,Yloc),projectilemass));
      }
    }
  }
}
class Rectangle {
  protected PVector pos;

  int h;
  int w;

  int col;

  Rectangle (PVector inpos, int inw, int inh, int incol) {
    pos = inpos;
    h = inh;
    w = inw;
    col = incol;
  }
  public void render () {
    fill(col);
    stroke(col);
    if(w==0 && h==0) {//if no dimension it's just a tiny point
    point(pos.x,pos.y);
    } else {
    rect(pos.x, pos.y, w, h);
    }
  }
  
  public boolean isOffSides(int windowX, int windowY) {
    if(pos.x < 0)  {
      return true;
    } else if(pos.y < 0) { 
      return true;
    } else if(pos.x+w > windowX) {
      return true;
    } else if(pos.y+h > windowY) {
      return true;
    }
    return false;
  }
  public boolean rectCollision(Rectangle rect1) {
    if (rect1.pos.x+rect1.w < pos.x) { 
      return false;
    }
    if (rect1.pos.x > pos.x+w) { 
      return false;
    }
    if (rect1.pos.y+rect1.h < pos.y) { 
      return false;
    }
    if (rect1.pos.y > pos.y+h) { 
      return false;
    }
    return true;
  }
  
  public PVector getCoronaPoint() { //corona extends 1/2 the width out the sides of the rect and 1/2 the height out the top and bottom
  /* finds a point in the corona */
    int thisX = 0;
    int thisY = 0;
    if(random(1)>0.5f) { //x on the left
      thisX = (int)(random(pos.x-(w/2),pos.x));
    } else {
      thisX = (int)(random(pos.x+w,pos.x+(w*1.5f)));
    }
    /*if(random(1)>0.5) {
      thisY = (int)(random(pos.y-(h/2),pos.y));
    } else {
      thisY = (int)(random(pos.y+h,pos.y+(h*1.5)));
    }*/
    thisY = (int)(random(pos.y-(h/2),pos.y+h+(h/2)));
    return new PVector(thisX,thisY);
  }
  public float getCX() { //get center-x
    return pos.x+(w/2);
  }
  public float getCY() { //get center-y
    return pos.y+(h/2);
  }
}

class MotileRect extends Rectangle {
  PVector speed; //in pixels per 1/10th second.
  MotileRect(PVector inpos, int inw, int inh, int incol, PVector inspd) {
    super(inpos, inw, inh, incol);
    speed = inspd.get();
  }
  public void update() {
    pos.add(speed);
  }
}

class PhysicsRect extends MotileRect {
  float mass; 
  PhysicsRect(PVector inpos, int inw, int inh, int incol, PVector inspeed, float inmass) {
    super(inpos,inw,inh,incol,inspeed);
    mass = inmass;
  }
  public void applyforce(PVector force) {
    PVector newforce = force.get();
    newforce.div(mass);
    speed.add(newforce);
  }
  public void frictionate(float percent) { //super-ghetto-nonrealistic friction math! yAAAY!
    speed.mult(percent);
  }
  public PVector getMomentumVector() {
    PVector retvector = speed.get();
    retvector.mult(mass);
    return retvector;
  }
  public float getMomentumScalar() { //for calculating damage and the like.
    return speed.mag()*mass;
  }
  public void handleOffSides(int windowX, int windowY, float wallreduce) {
    if(pos.x < 0){
      pos.x = 0;
      speed.x = speed.x*-1;
      frictionate(wallreduce);
    } else if (pos.x+w > windowX) {
      pos.x = windowX-w;
      speed.x = speed.x*-1;
      frictionate(wallreduce);
    }  
    if(pos.y < 0 ) { 
      pos.y=0;
      speed.y = speed.y*-1;
      frictionate(wallreduce);
    } else if (pos.y+h > windowY) {
      pos.y=windowY-h;
      speed.y = speed.y*-1;
      frictionate(wallreduce);
    }
  }
  //void renderMomentumVector() {    stroke(col);    PVector momentum = getMomentumVector();    line(pos.x,pos.y,momentum.x+pos.x,momentum.y+pos.y);  }
}
class CharacterRect extends PhysicsRect {
  float health;
  PImage img;
  Gun[] myguns;
  int currentgun;
  CharacterRect(PVector inpos, int inw, int inh, int incol, PVector inspeed, float inmass, float inhealth, PImage inimg) {
    super(inpos,inw,inh,incol,inspeed,inmass);
    img = inimg;
    health = inhealth;                                 
    myguns = new Gun[1];
    myguns[0] = new Gun(0,0,0,0,color(0,0,0),0); //placeholder weapon
    currentgun = 0;
  }
  public void shootTowards(float Xloc, float Yloc, ArrayList putbulletshere) {
    myguns[currentgun].fire(this,Xloc,Yloc,putbulletshere);
  }
  public void render() {
    //super.render();
    image(img,pos.x,pos.y,w,h);
  }
  public void takedamage(PhysicsRect touchingMe) { //precondition - touchingMe has been indeed confirmed to be touching me
    PVector impactspeed = touchingMe.speed.get();
    impactspeed.sub(speed);
    impactspeed.mult(touchingMe.mass);
    applyforce(impactspeed); //recoil from the shot
    health -= impactspeed.mag();
  }
}
class Player extends CharacterRect {
  Gun thruster;
  Player(PVector inpos, int inw, int inh, int incol, PVector inspeed, float inmass) {
    super(inpos,inw,inh,incol,inspeed,inmass,1500,loadImage("player.png"));
    
    thruster = new Gun(100 ,20,1  ,1.1781f,color(255,255,255,150),.06f); //thruster (3/8 PI spread)
    
    myguns = new Gun[4];
    myguns[0] = new Gun(250 ,12,50  ,0.3927f,color(255,255,255,150),1); //shotgun (1/8 PI spread)
    myguns[1] = new Gun(20  ,17,200,.01f,       color(255,255,255),3);  //bolt
    myguns[2] = new Gun(5000,9 ,400,PI,    color(255,255,255),1);  //360 radial cannon
    myguns[3] = new Gun(10,  20,2  ,.01f,        color(255,255,255),.35f); //chaingun
  }
  public void update() {
    super.update();
    for(int iii=0;iii<playerWepKeys.length;iii++) {
      if(checkKey(playerWepKeys[iii])) currentgun = iii;
    }
  }
  public void thrustTowards(float Xloc, float Yloc, ArrayList putbulletshere) {
    thruster.fire(this,Xloc,Yloc,putbulletshere);
  }
}
class GenericEnemy extends CharacterRect {
  GenericEnemy(PVector inpos, int inw, int inh, int incol, PVector inspeed, float inmass, float inhealth, PImage inimg) { //FROM HERE ON OUT, defining attribuites such as guns, health, and images in the class, not making them constructor options.
    super(inpos,inw,inh,incol,inspeed,inmass,inhealth,inimg);
    myguns = new Gun[1];
    myguns[0] = new Gun(10,  10,2  ,.01f,        color(255,255,255),.35f);
  }
  public void aquireTarget(Player target,ArrayList putBulletsHere) {
    shootTowards(target.getCX(),target.getCY(),putBulletsHere);
  }
}
class Chaingunner extends GenericEnemy {
  Chaingunner(PVector inpos, PVector inspeed) {
    super(inpos,20,20,color(0,0,0,0),inspeed,240,400,loadImage("chaingunner.png")); //no need to supply height, width, color, mass, health, or image - these hardcoded.
    myguns = new Gun[1];
    myguns[0] = new Gun(11,11,11,0,color(0,255,255),.1f); 
  }
}
class Sniper extends GenericEnemy {
  Sniper(PVector inpos,  PVector inspeed) {
    super(inpos,15,15,color(0,0,0,0),inspeed,200,400,loadImage("sniper.png"));
    myguns = new Gun[1];
    myguns[0] = new Gun(50,17,300,0,color(0,125,255),1); 
  }
}


public void randInsertEnemy(ArrayList enemys) { //needs fixing in terms of all the f****** variables in this function.
  int enemySize = 20; //max size
  float enemyTopSpeed = 10;
  int screenedge = (int)(random(0,4));
  int posx = 0;
  int posy = 0;
  float speedx = 0;
  float speedy = 0;
  if (screenedge == 0) { //the left edge
    posx = 1;
    posy = (int)(random(0,windowY-enemySize));
    speedx = random(0,enemyTopSpeed);
    speedy = random(-1*enemyTopSpeed,enemyTopSpeed);
  } else if (screenedge == 1) { //the right edge
    posx = windowX-enemySize;
    posy = (int)(random(0,windowY-enemySize));
    speedx = random(-1*enemyTopSpeed,0);
    speedy = random(-1*enemyTopSpeed,enemyTopSpeed);
  } else if (screenedge == 2) { //the top
    posx = (int)(random(0,windowX-enemySize));
    posy = 0;
    speedx = random(-1*enemyTopSpeed, enemyTopSpeed);
    speedy = random(0,enemyTopSpeed);
  } else if (screenedge == 3) { //the bottom
    posx = (int)(random(0,windowX-enemySize));
    posy = windowY-enemySize;
    speedx = random(-1*enemyTopSpeed, enemyTopSpeed);
    speedy = random(-1*enemyTopSpeed,0);
  }
  int enemytype = (int)(random(0,2));
  if(enemytype == 0) 
    enemys.add(new Sniper(new PVector(posx,posy),new PVector(speedx,speedy)));
  else if(enemytype == 1)
    enemys.add(new Chaingunner(new PVector(posx,posy),new PVector(speedx,speedy)));
}

boolean[] keys = new boolean[526];
public boolean checkKey(String k) {
  for (int i = 0; i < keys.length; i++) {
    if (KeyEvent.getKeyText(i).toLowerCase().equals(k.toLowerCase())) {
      return keys[i];
    }
  }
  return false;
}
public void keyPressed()
{
  keys[keyCode] = true;
  //println(KeyEvent.getKeyText(keyCode));
}

public void keyReleased()
{ 
  keys[keyCode] = false;
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--stop-color=#cccccc", "flovv" });
  }
}
