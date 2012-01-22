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
final int gravMag = 1600;
final int windowX = 1024;
final int windowY = 768;
final int goldRectSize = 70;
final int meteorSize = 30;
final float meteorTopSpeed = 0.5f;
//[/CONFIG]

PlayerRect player;
GravRect sun;

ArrayList meteors;
Rectangle goldrect = new Rectangle(new PVector(20,20),goldRectSize,goldRectSize,255,255,0,true);


PFont f;
boolean gamerunning = false;

public void setup() { 
  size(1024,768);
  frameRate(120);
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
    player.score++;
    placeGoldRect();
    for(int iii=0; iii<=player.score;iii++) {
      fireMeteor();
    }
  }
  textFont(f,30);
  fill(255);
  String scorestr = "Score: " + player.score;
  text(scorestr,0,750);
}

public void titleScreen() {
  textFont(f,48);
  text("sy\u00dftem",0,40);
  text("Press ENTER to start", 200,200);
  if(checkKey("Enter")) {
    set_up_game();
    gamerunning = true;
  }
  String scorestr = "Score: " + player.score;
  text(scorestr,0,720);
}


public void draw() {
  background(0);
  if(gamerunning)  { activeCycle(); } else { titleScreen(); } //one-line if-else with brackets - like a boss.
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
    if(hollow) {
      stroke(r,g,b);
      noFill();
    } else {
      fill(r, g, b);
      noStroke();
    }
    rect(pos.x, pos.y, w, h);
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
    if (checkKey("Up")) {
      speed.y -= .02f;
    }
    if (checkKey("Down")) {
      speed.y += .02f;
    }
    if (checkKey("Left")) {
      speed.x -= .02f;
    }
    if (checkKey("Right")) {
      speed.x += .02f;
    }
  }
  
}

class GravRect extends Rectangle {
  float magnitude;
  GravRect (PVector inpos, int inw, int inh, int inr, int ing, int inb, float inmag) {
    super(inpos,inw,inh,inr,ing,inb);
    magnitude = inmag;
  }
  
  /*
  void affect(MotileRect target) {
    PVector effect = new PVector( magnitude/(pos.x-target.pos.x), magnitude/(pos.y-target.pos.y));
    print(effect.x);
    print(" , ");
    println(effect.y);
    //effect.normalize();
    //effect.mult(magnitude);
    target.speed.add(effect);
  }
  */
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
  player.pos.x = mouseX;
  player.pos.y = mouseY;
  player.speed = new PVector(0,0); //reset it
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
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "frictionless" });
  }
}
