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

public class genhomogen_arraylist extends PApplet {

//TODO: fix sessiles?

final int windowSize = 500;
final int numOrgs = 0;


ArrayList myRects;
int locationX, locationY;


public void setup () {
  myRects = new ArrayList();
  for (int iii=0; iii <= (numOrgs-1); iii++) {
    locationX = PApplet.parseInt(random(windowSize));
    locationY = PApplet.parseInt(random(windowSize));
    myRects.add(new Rectangle(locationX, locationY));
  }
  size(windowSize,windowSize);
  noStroke();
}

public void draw () {
  background(0);
  handleColl();
  if (mousePressed) {
    myRects.add(new Rectangle(mouseX, mouseY));
  }
}
public void handleColl () {
  for (int iii=0; iii <= (myRects.size()-1); iii++) {
    Rectangle firstrect = (Rectangle) myRects.get(iii);
    firstrect.update();
    for (int jjj=0; jjj<= (myRects.size()-1); jjj++) {
      Rectangle secondrect = (Rectangle) myRects.get(jjj);
      if (iii != jjj) { //not the same rect
        boolean coll = collDetect(firstrect,secondrect);
        if (coll) {
          int localR = (firstrect.r+secondrect.r)/2;
          int localG = (firstrect.g+secondrect.g)/2;
          int localB = (firstrect.b+secondrect.b)/2;
          firstrect.r = localR;
          firstrect.g = localG;
          firstrect.b = localB;
          secondrect.r = localR;
          secondrect.g = localG;
          secondrect.b = localB;
        }
      }
    }
  }
}
  


public boolean collDetect(Rectangle rect1, Rectangle rect2) { // this will be collison detection
  if (rect1.x+rect1.w < rect2.x) { return false; }
  if (rect1.x > rect2.x+rect2.w) { return false; }
  if (rect1.y+rect1.h < rect2.y) { return false; }
  if (rect1.y > rect2.y+rect2.h) { return false; }
  return true;      
}

class Rectangle {
  int x; //position
  int y;
  
  int h;
  int w;
  
  int mvmntx;
  int mvmnty;
  
  int r;
  int g;
  int b;
    
  Rectangle (int c1x, int c1y) {
    x = c1x;
    y = c1y;
    h = 20;
    w = 20;
    r = round(random(255));
    g = round(random(255));
    b = round(random(255));
    mvmntx = round(random(-2,3)); 
    mvmnty = round(random(-2,3)); 
  }
  
  public void boundryCheck() {
    if (x < 0) {
      mvmntx = round(random(1,3));
      if (mvmnty == 0) { //fix the "straight movement" problem
        mvmnty = round(random(-2,3)); 
      }
    }
    if (x+w > windowSize) {
      mvmntx = round(random(-2,0));
      if (mvmnty == 0) { //fix the "straight movement" problem
        mvmnty = round(random(-2,3)); 
      }
    }
    
    
    if (y < 0) {
      mvmnty = round(random(1,3));
      if (mvmntx == 0) { //fix the "straight movement" problem
        mvmntx = round(random(-2,3)); 
      }
    }  
    if (y+h > windowSize) {
      mvmnty = round(random(-2,0));
      if (mvmntx == 0) { //fix the "straight movement" problem
        mvmntx = round(random(-2,3)); 
      }
    }
  }
    
  public void moveRect() {
    x = x+mvmntx;
    y = y+mvmnty;
  }
  
  public void render () {
    fill(r,g,b);
    rect(x,y,w,h);
  }
  
  public void update() {
    boundryCheck();
    moveRect();
    render();
  }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#ECE9D8", "genhomogen_arraylist" });
  }
}
