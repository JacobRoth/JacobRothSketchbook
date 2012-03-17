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

public class fightergame extends PApplet {

//all globals must be declared out here in globalspace.
final int windowSize = 500;
final boolean invincible = false;

int secsrunning = 0;
Trigger secsCounter;

Layer layer1;
Layer layer2;
Layer layer3;

PFont f;  

boolean[] keys = new boolean[526];
boolean gameRunning = false;
boolean paused = false;

public void setup () {
  size(500, 500); //gotta put those numeric values, not vars, in or ExportApplet chokes.
  frameRate(30);
  f = loadFont("AgencyFB-Reg-48.vlw");
  setLayers();
}

public void setLayers() {
  layer1 = new Layer(1.5f, 255, 0, 0, 400); //red
  layer2 = new Layer(5, 0, 255, 0, 1000);  //green
  /*there's currenty super-hackish code down in void runningCycle() {
    that progressively makes the delay on the green layer (layer 2) get shorter and shorter. There's probably a more
    elegant way to code difficulty progression, but I'm ok with this.
  */
  layer3 = new Layer(4, 0, 100, 255, 100); //blue
  
  
  secsrunning = 0;
  secsCounter = new Trigger(1000);
}

public void keyPressed() { 
  keys[keyCode] = true;
}
public void keyReleased() { 
  keys[keyCode] = false;
}
public boolean checkKey(String k) {
  for (int i = 0; i < keys.length; i++) {
    if (KeyEvent.getKeyText(i).toLowerCase().equals(k.toLowerCase())) {
      return keys[i];
    }
  }
  return false;
}
public void draw() {
  background(0);

  if (gameRunning) {
    if (paused) {
      pauseCycle();
    } 
    else {
      runningCycle();
    }
  } 
  else {
    offCycle();
  }
}
public void offCycle() {
  layer1.frozenCycle();
  layer2.frozenCycle();
  layer3.frozenCycle();
  fill(255);
  textFont(f, 48);
  text("f", 50, 100);
  textFont(f, 120);
  text("A", 150, 100);
  textFont(f, 48);
  text("d", 250, 100);
  text("e", 350, 100);
  text("By Yanom", 100, 300);
  textFont(f, 36);
  text("Press B to start", 200, 350);
  if (checkKey("b")) {
    setLayers();
    gameRunning=true;
  }
  text(secsrunning, 400, 490);
}

public void pauseCycle() {
  layer1.frozenCycle();
  layer2.frozenCycle();
  layer3.frozenCycle();
  fill(255);
  textFont(f, 48);
  text("Paused", 100, 100);
  textFont(f, 26);
  text("Press U to unpause", 300, 400);
  checkForPauseInput();
  text(secsrunning, 400, 490);
}

public void runningCycle() {
  if (secsCounter.fires()) {
    secsrunning++;
    if(!(secsrunning>999)) { //ensure we won't be setting the timer's rate to a negative number (this would cause problems)
      layer2.thisSource.timer.setRate(1000-secsrunning); //reach all the way down into the innards of the green layer and make it harder.
    }
  }

  layer1.activeCycle();
  layer2.activeCycle();
  layer3.activeCycle();
  
  
  //checkForPauseInput();
  textFont(f, 26);
  fill(255);
  text(secsrunning, 400, 490);
}

public void checkForPauseInput() {
  if (checkKey("P")) {
    paused = true;
  }
  if (checkKey("U")) {
    paused = false;
  }
}




class Layer { //has-a fighter, source, bullet ArrayList
  Fighter thisFighter;
  Source thisSource;
  ArrayList thisBullets;
  float speed;
  int r;
  int g;
  int b;
  Layer(float inspeed, int inr, int ing, int inb, int rate) {
    speed = inspeed;
    r = inr;
    g = ing;
    b = inb;
    thisFighter = new Fighter((int)random(windowSize), (int)random(windowSize), 10, 10, r, g, b, speed*1.5f);
    thisSource = new Source(windowSize/2,windowSize/2,speed,r,g,b,rate);
    thisBullets = new ArrayList();
  }
  public void activeCycle() {
    for (int iii=0; iii <= (thisBullets.size()-1); iii++) {
      Bullet currentbullet = (Bullet) thisBullets.get(iii);
      currentbullet.render();
      currentbullet.boundrycheck(thisBullets);
      currentbullet.moveSelf();
      if(collDetect(thisFighter,currentbullet)) {
        thisFighter.r=255;
        thisFighter.g=255;
        thisFighter.b=255;
        if (!invincible) gameRunning = false;
      }
    }
    if (gameRunning) thisFighter.moveSelf();
    thisFighter.boundrycheck(windowSize);
    thisFighter.render();
    thisSource.handle(thisBullets,500);
  }
  public void frozenCycle() {
    for (int iii=0; iii <= (thisBullets.size()-1); iii++) {
      Bullet currentbullet = (Bullet) thisBullets.get(iii);
      currentbullet.render();
    }
    thisFighter.render();
  }
}
class Rectangle {
  float x; //position
  float y;

  int h;
  int w;


  int r;
  int g;
  int b;

  Rectangle (float c1x, float c1y) { //constructor
    x = c1x;
    y = c1y;
    h = 20;
    w = 20;
    r = round(random(255));
    g = round(random(255));
    b = round(random(255));
  }

  Rectangle (float c1x, float c1y, int inw, int inh, int inr, int ing, int inb) { //totally specific constructor
    x = c1x;
    y = c1y;
    h = inh;
    w = inw;
    r = inr;
    g = ing;
    b = inb;
  }

  public void render () {
    fill(r, g, b);
    noStroke();
    rect(x, y, w, h);
  }


  public void die(ArrayList whatList) {
    whatList.remove(this);
  }
}

class Fighter extends Rectangle {
  float topspeed;
  Fighter (int c1x, int c1y, int inw, int inh, int inr, int ing, int inb, float topspd) {
    super(c1x, c1y, inw, inh, inr, ing, inb);
    topspeed = topspd;
  }

  public void boundrycheck(int windowsize) {
    if (x < 0) {
      x = 0;
    }
    if (y < 0) {
      y = 0;
    }
    if (x+w>windowsize) {
      x = windowsize-w;
    }
    if (y+h>windowsize) {
      y = windowsize-h;
    }
  }
  public void render() {
    noFill();
    stroke(r, g, b);
    ellipse(x+(w/2), y+(h/2), w*5, h*5);
    super.render();
  }
  public void moveSelf() {
    if (checkKey("W")) {
      y -= topspeed;
    }
    if (checkKey("S")) {
      y += topspeed;
    }
    if (checkKey("A")) {
      x -= topspeed;
    }
    if (checkKey("D")) {
      x += topspeed;
    }
  }
}

class Bullet extends Rectangle {
  float mvx;
  float mvy;
  Bullet (int c1x, int c1y, int inw, int inh, int inr, int ing, int inb, float motionx, float motiony) {
    super(c1x, c1y, inw, inh, inr, ing, inb);
    mvx = motionx;
    mvy = motiony;
  }

  public void boundrycheck(ArrayList listIn) {
    if (x < 0) {
      die(listIn);
    }
    if (y < 0) {
      die(listIn);
    }
    if (x+w>windowSize) {
      die(listIn);
    }
    if (y+h>windowSize) {
      die(listIn);
    }
  }
  public void moveSelf() {
    x = x+mvx;
    y = y+mvy;
  }
}

public boolean collDetect(Rectangle rect1, Rectangle rect2) {
  if (rect1.x+rect1.w < rect2.x) { 
    return false;
  }
  if (rect1.x > rect2.x+rect2.w) { 
    return false;
  }
  if (rect1.y+rect1.h < rect2.y) { 
    return false;
  }
  if (rect1.y > rect2.y+rect2.h) { 
    return false;
  }
  return true;
}



class Source { 
  int x;
  int y;
  float speed;
  int r;
  int g;
  int b;
  Trigger timer;
  
  Source (int inx, int iny, float inspeed, int ir, int ig, int ib, int rate) {
    x = inx;
    y = iny;
    speed = inspeed;
    r=ir;
    g=ig;
    b=ib;
    timer = new Trigger(rate);
  }
  
  
  public void handle(ArrayList holdbullet, int windowSize) {
    /*
    x = (int)(windowSize*noise(globalnoise));
    globalnoise += .002;
    y = (int)(windowSize*noise(globalnoise));
    globalnoise += .002;
    */
    while (timer.fires()) {
      float randX = random(-1*speed, speed);
      float randY = random(-1*speed, speed);
      holdbullet.add(new Bullet(x, y, 5, 5, r, g, b, randX, randY));
    }
  }
}



// The trigger class, by kritzikratzi
class Trigger{
  long start = millis(); 
  int rate; 
  
  public Trigger( int rate ){
    this( rate, false ); 
  }
  
  /**
   * additional boolean parameter to indicate whether the trigger 
   * should fire immediately
   */
   public Trigger( int rate, boolean immediately ){
     setRate( rate ); 
     if( immediately ) start -= rate; 
   }
   
  /** 
   * changes the rate at which the trigger fires in milliseconds 
   */
  public void setRate( int rate ){
    this.rate = rate; 
  }
  
  /**
   * returns the rate at which the trigger fires, in milliseconds
   */
  public int getRate(){
    return rate; 
  }
  
  /**
   * returns true if the trigger has fired, false otherwise
   */
  public boolean fires(){
    if( millis() - start >= rate ){
      start += rate; 
      return true; 
    }
    else{
      return false; 
    }
  }
  
  /**
   * resets the timer, 
   * next trigger will occur in _rate_ milliseconds.  
   */
  public void reset(){
    start = millis(); 
  }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "fightergame" });
  }
}
