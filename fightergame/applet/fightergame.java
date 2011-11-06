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
final int difficulty = 1;

Layer layer1 = new Layer(new Fighter(400, 250, 10, 10, 255, 0, 0, 4),new ArrayList(),new Source(8,8));

PFont f;  

boolean[] keys = new boolean[526];
boolean gameRunning = true;
boolean paused = false;

public void setup () {
  size(500,500);
  frameRate(30);
  f = loadFont("AgencyFB-Reg-48.vlw");
}
public void keyPressed() { 
  keys[keyCode] = true;
}
public void keyReleased() { 
  keys[keyCode] = false;
}
public boolean checkKey(String k) {
  for(int i = 0; i < keys.length; i++) {
    if(KeyEvent.getKeyText(i).toLowerCase().equals(k.toLowerCase())) {
      return keys[i];
    }
  }
  return false; 
}
public void draw() {
  background(0);
    
  if(gameRunning) {
    if (paused) {
      pauseCycle();
    } else {
      runningCycle();
    }
  } else {
    gameOverCycle();
  }
}
public void gameOverCycle() {
  layer1.frozenCycle();
  fill(255);
  textFont(f,48);
  text("Game over", 100,100);
}

public void pauseCycle() {
  layer1.frozenCycle();
  
  fill(255);
  textFont(f,48);
  text("Paused", 100,100);
  textFont(f,26);
  text("Press U to unpause", 300,400);
  checkForPauseInput();
}

public void runningCycle() {
  layer1.activeCycle();
  checkForPauseInput();
}

public void checkForPauseInput() {
  if (checkKey("P")) {
    paused = true;
  }
  if (checkKey("U")) {
    paused = false;
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


  
class Layer { //has-a fighter, source, bullet ArrayList
  Fighter thisFighter;
  Source thisSource;
  ArrayList thisBullets;
  Layer(Fighter inFighter,ArrayList inBullets, Source inSource) {
    thisFighter = inFighter;
    thisSource = inSource;
    thisBullets = inBullets;
  }
  public void activeCycle() {
    for (int iii=0; iii <= (thisBullets.size()-1); iii++) {
      Bullet currentbullet = (Bullet) thisBullets.get(iii);
      currentbullet.render();
      currentbullet.boundrycheck(thisBullets);
      currentbullet.moveSelf();
      if(collDetect(thisFighter,currentbullet)) {
        gameRunning = false;
      }
    }
    if (gameRunning) thisFighter.moveSelf();
    thisFighter.boundrycheck(windowSize);
    thisFighter.render();
    thisSource.handle(layer1.thisBullets,difficulty,500);
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
    ellipse(x+(w/2), y+(h/2), w*8, h*8);
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

class Source { 
  int x;
  int y;
  boolean goingRight;
  Source (int inx, int iny) {
    x = inx;
    y = iny;
    goingRight=true;
  }
  public void handle(ArrayList holdbullet, int numbullets, int windowSize) {
    if (goingRight) {
      x += 6;
    } 
    else {
      x -= 6;
    }
    if (x<8) {
      goingRight = true;
    } 
    if (x>(windowSize-8)) {
      goingRight = false;
    }

    for (int iii=1; iii<=numbullets; iii++) { 
      float randX = random(-6, 5);
      float randY = random(1, 5);
      
      holdbullet.add(new Bullet(x, y, 10, 10, 255, 0, 0, randX, randY));
    }
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "fightergame" });
  }
}
