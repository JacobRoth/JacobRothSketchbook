//all globals must be declared out here in globalspace.
final int windowSize = 500;
final int difficulty = 1;
final boolean invincible = true;

Layer layer1 = new Layer(6,255,0,0);
Layer layer2 = new Layer(4,0,255,0);
Layer layer3 = new Layer(2,0,0,255);


PFont f; //PFONT! 

boolean[] keys = new boolean[526];
boolean gameRunning = true;
boolean paused = false;

void setup () {
  size(500,500);
  frameRate(30);
  f = loadFont("AgencyFB-Reg-48.vlw");
}
void keyPressed() { 
  keys[keyCode] = true;
}
void keyReleased() { 
  keys[keyCode] = false;
}
boolean checkKey(String k) {
  for(int i = 0; i < keys.length; i++) {
    if(KeyEvent.getKeyText(i).toLowerCase().equals(k.toLowerCase())) {
      return keys[i];
    }
  }
  return false; 
}
void draw() {
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
void gameOverCycle() {
  layer1.frozenCycle();
  layer2.frozenCycle();
  layer3.frozenCycle();
  fill(255);
  textFont(f,48);
  text("Game over", 100,100);
}

void pauseCycle() {
  layer1.frozenCycle();
  layer2.frozenCycle();
  layer3.frozenCycle();
  fill(255);
  textFont(f,48);
  text("Paused", 100,100);
  textFont(f,26);
  text("Press U to unpause", 300,400);
  checkForPauseInput();
}

void runningCycle() {
  layer1.activeCycle();
  layer2.activeCycle();
  layer3.activeCycle();
  checkForPauseInput();
}

void checkForPauseInput() {
  if (checkKey("P")) {
    paused = true;
  }
  if (checkKey("U")) {
    paused = false;
  }
}

boolean collDetect(Rectangle rect1, Rectangle rect2) {
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


  
