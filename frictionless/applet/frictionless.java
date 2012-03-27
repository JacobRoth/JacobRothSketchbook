import processing.core.*; 
import processing.xml.*; 

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

public class frictionless extends PApplet {

/* GPL licenced */
//[CONFIG]
final int gravMag = 1000;
final int windowX = 1024;
final int windowY = 768;
final int goldRectSize = 100;
final int meteorSize = 15;
final float meteorTopSpeed = 1;
final int coronaStormIntensity = 1;
final int backgroundBrightness = 100; //from 0 to 255
final boolean useDynamicBackground = false;
//[/CONFIG]

PlayerRect player;
GravRect sun;

ArrayList meteors;
Rectangle goldrect = new Rectangle(new PVector(20,20),goldRectSize,goldRectSize,255,255,0,true);

PFont f;
boolean gamerunning = false;

float backgroundNoise=0;

public void setup() { 
  size(1024,768);
  frameRate(30);
  set_up_game();
  f = loadFont("TlwgTypist-48.vlw");
}

public void set_up_game() {
  sun = new GravRect(new PVector(windowX/2,windowY/2),35,35,255,0,0,gravMag);
  player = new PlayerRect(new PVector(40, 94), 3, 3, 255, 255, 255);
  player.score = 0;
  placeGoldRect();
  meteors = new ArrayList();
}

public void activeCycle() {
  player.update();
  player.render();
  player.moveself();
  goldrect.render();
  sun.render();
  sun.affect(player);
  if(rectCollision(sun,player)) gamerunning=false;
  
  for (int iii=0; iii<=(meteors.size()-1); iii++) {
    MotileRect thismeteor = (MotileRect) meteors.get(iii);
    thismeteor.render();
    thismeteor.update();
    sun.affect(thismeteor);
    if(thismeteor.pos.x < 0 || thismeteor.pos.x+thismeteor.w > windowX )  meteors.remove(thismeteor);
    if(thismeteor.pos.y < 0 || thismeteor.pos.y+thismeteor.h > windowY )  meteors.remove(thismeteor);
    if(rectCollision(sun,thismeteor))                                     meteors.remove(thismeteor);
    
    if(rectCollision(player,thismeteor)) gamerunning=false; 
  }
  
  
  if(player.pos.x < 0 || player.pos.x+player.w > windowX ) /*player.speed.x = player.speed.x*-1;*/ gamerunning=false;
  if(player.pos.y < 0 || player.pos.y+player.h > windowY ) /*player.speed.y = player.speed.y*-1;*/ gamerunning=false;
  if(rectCollision(player,goldrect)) {
    player.score+= (1+meteors.size()); //award a bonus for any meteors on screen
    placeGoldRect();
    for(int iii=0; iii<=player.score;iii++) {
      fireMeteor();
    }
  }
  textFont(f,30);
  fill(255);
  String scorestr = "Score: " + player.score;
  text(scorestr,0,650);
}

public void titleScreen() {
  textFont(f,48);
  text("sy\u00dftem",0,40);
  text("Press K to start", 200,200);
  if(checkKey("K")) {
    set_up_game();
    gamerunning = true;
  }
  String scorestr = "Score: " + player.score;
  text(scorestr,0,720);
}


public void draw() {
  if(useDynamicBackground) {
    background(noise(backgroundNoise)*backgroundBrightness);
    backgroundNoise += 0.01f;
  } else {
    background(0);
  }
  if(gamerunning)  { activeCycle(); } else { titleScreen(); }
}

class Rectangle {
  PVector pos;

  int h;
  int w;

  int r;
  int g;
  int b;

  boolean hollow;

  Rectangle (PVector inpos, int inw, int inh, int inr, int ing, int inb, boolean inhollow) { //non-hollow
    pos = inpos;
    h = inh;
    w = inw;
    r = inr;
    g = ing;
    b = inb;
    hollow = inhollow;
  }
  Rectangle (PVector inpos, int inw, int inh, int inr, int ing, int inb) {
    this(inpos,inw,inh,inr,ing,inb,false);
  } 
  public void render () {
    stroke(r,g,b);
    if(hollow) {
      noFill();
    } else {
      fill(r, g, b);
      for (int iii=0; iii<coronaStormIntensity; iii++) {
        PVector cr1 = getCoronaPoint();
        PVector cr2 = getCoronaPoint();
        line(cr1.x,cr1.y,cr2.x,cr2.y);
      }
    }
    rect(pos.x, pos.y, w, h);
    
    stroke(r,g,b);
    
    
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
  Trigger timer; 
  MotileRect(PVector inpos, int inw, int inh, int inr, int ing, int inb, PVector inspd) {
    super(inpos, inw, inh, inr, ing, inb);
    speed = inspd;
    timer = new Trigger(10);
  }
  public void update() {
    while (timer.fires ()) {
      pos.add(speed);
    }
  }
}

class PlayerRect extends MotileRect {
  int score;
  PlayerRect(PVector inpos, int inw, int inh, int inr, int ing, int inb) {
    super(inpos, inw, inh, inr, ing, inb, new PVector(0,0)); //start out speedless
    score = 0;
  }
  public void moveself() {
    if (checkKey("Up") || checkKey("W")) {
      speed.y -= .05f;
    }
    if (checkKey("Down")|| checkKey("S")) {
      speed.y += .05f;
    }
    if (checkKey("Left")|| checkKey("A")) {
      speed.x -= .05f;
    }
    if (checkKey("Right")|| checkKey("D")) {
      speed.x += .05f;
    }
  }
  
}

class GravRect extends Rectangle {
  float magnitude;
  GravRect (PVector inpos, int inw, int inh, int inr, int ing, int inb, float inmag) {
    super(inpos,inw,inh,inr,ing,inb);
    magnitude = inmag;
  }
  

  public void affect(MotileRect target) {
    // the distance on the x-axis
    float dx = getCX() - target.pos.x;
    
    // the distance on the y-axis
    float dy = getCY() - target.pos.y;
    
    // the distance between the 2 objects 
    float d = sqrt( dx * dx + dy * dy );
    
    // the acceleration - inversely proportional to the square of the distance
    float acc = magnitude / ( d * d);
    // the direction angle
    float sinAngle = dy / d;
    float cosAngle = dx / d;
    
    
    // the acceleration on the x-axis
    float accX = acc * cosAngle;
    
    // the acceleration on the y-axis
    float accY = acc * sinAngle;
    
    PVector effect = new PVector( accX, accY);
    target.speed.add(effect);
  } 
}

public boolean rectCollision(Rectangle rect1, Rectangle rect2) {
  if (rect1.pos.x+rect1.w < rect2.pos.x) { 
    return false;
  }
  if (rect1.pos.x > rect2.pos.x+rect2.w) { 
    return false;
  }
  if (rect1.pos.y+rect1.h < rect2.pos.y) { 
    return false;
  }
  if (rect1.pos.y > rect2.pos.y+rect2.h) { 
    return false;
  }
  return true;
}
/*void mouseClicked() {
  fireMeteor();
}*/



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

public void placeGoldRect() {
  int randX = (int)(random(windowX-goldRectSize));
  int randY = (int)(random(windowY-goldRectSize));
  goldrect.pos = new PVector(randX,randY);
}

public void fireMeteor() { //from the edge of the screen.
  int screenedge = (int)(random(0,4));
  println(screenedge);
  if (screenedge == 0) { //the left edge
    int posx = 1;
    int posy = (int)(random(0,windowY-meteorSize));
    float speedx = random(0,meteorTopSpeed);
    float speedy = random(-1*meteorTopSpeed,meteorTopSpeed);
    meteors.add(new MotileRect(new PVector(posx,posy),meteorSize,meteorSize,0,140,50,new PVector(speedx,speedy)));
  } else if (screenedge == 1) { //the right edge
    int posx = windowX-meteorSize;
    int posy = (int)(random(0,windowY-meteorSize));
    float speedx = random(0,-1*meteorTopSpeed);
    float speedy = random(-1*meteorTopSpeed,meteorTopSpeed);
    meteors.add(new MotileRect(new PVector(posx,posy),meteorSize,meteorSize,0,140,50,new PVector(speedx,speedy)));
  } else if (screenedge == 2) { //the top
    int posx = (int)(random(0,windowX-meteorSize));
    int posy = 0;
    float speedx = random(-1*meteorTopSpeed, meteorTopSpeed);
    float speedy = random(0,meteorTopSpeed);
    meteors.add(new MotileRect(new PVector(posx,posy),meteorSize,meteorSize,0,140,50,new PVector(speedx,speedy)));
  } else if (screenedge == 3) { //the bottom
    int posx = (int)(random(0,windowX-meteorSize));
    int posy = windowY-meteorSize;
    float speedx = random(-1*meteorTopSpeed, meteorTopSpeed);
    float speedy = random(0,-1*meteorTopSpeed);
    meteors.add(new MotileRect(new PVector(posx,posy),meteorSize,meteorSize,0,140,50,new PVector(speedx,speedy)));
  }    
}

class Trigger { //by kritzikratzi
  long start = millis(); 
  int rate; 

  public Trigger( int rate ) {
    this( rate, false );
  }
  /**
   * additional boolean parameter to indicate whether the trigger 
   * should fire immediately
   */
  public Trigger( int rate, boolean immediately) {
    setRate( rate ); 
    if ( immediately ) start -= rate;
  }

  /** 
   * changes the rate at which the trigger fires in milliseconds 
   */
  public void setRate( int rate ) {
    this.rate = rate;
  }
  public int getRate() {
    return rate;
  }
  /**
   * returns true if the trigger has fired, false otherwise
   */
  public boolean fires() {
    if ( millis() - start >= rate ) {
      start += rate; 
      return true;
    }
    else {
      return false;
    }
  }
  /**
   * resets the timer, 
   * next trigger will occur in _rate_ milliseconds.  
   */
  public void reset() {
    start = millis();
  }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#ECE9D8", "frictionless" });
  }
}
