final int windowSize = 500;
final boolean sourceDrift = true;
final int sourceDriftSpeed = 1;
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

void setup () {
  size(500, 500); //gotta put those numeric values, not vars, in or ExportApplet chokes.
  frameRate(30);
  f = loadFont("AgencyFB-Reg-48.vlw");
  setLayers();
}

void setLayers() {
  layer1 = new Layer(1, 255, 0, 0, 1000); //red
  layer2 = new Layer(2, 0, 255, 0, 1000);  //green
  /*there's currenty super-hackish code down in void runningCycle() {
    that progressively makes the delay on the green layer (layer 2) get shorter and shorter. There's probably a more
    elegant way to code difficulty progression, but I'm ok with this.
  */
  layer3 = new Layer(3, 0, 100, 255, 100); //blue
  
  
  secsrunning = 0;
  secsCounter = new Trigger(1000);
}

void keyPressed() { 
  keys[keyCode] = true;
}
void keyReleased() { 
  keys[keyCode] = false;
}
boolean checkKey(String k) {
  for (int i = 0; i < keys.length; i++) {
    if (KeyEvent.getKeyText(i).toLowerCase().equals(k.toLowerCase())) {
      return keys[i];
    }
  }
  return false;
}
void draw() {
  background(0);

  if (gameRunning) {
    //if (paused) {
    //  pauseCycle();
    //} 
    //else {
    runningCycle();
    //}
  } 
  else {
    offCycle();
  }
}
void offCycle() {
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

/*void pauseCycle() {
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
}*/

void runningCycle() {
  if (secsCounter.fires()) {
    secsrunning++;
    if(layer2.thisSource.timer.getRate()>2) { //ensure we won't be setting the timer's rate to a negative number (this would cause problems)
      layer2.thisSource.timer.setRate(100-secsrunning); //reach all the way down into the innards of the green layer and make it harder.
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

void checkForPauseInput() {
  if (checkKey("P")) {
    paused = true;
  }
  if (checkKey("U")) {
    paused = false;
  }
}




