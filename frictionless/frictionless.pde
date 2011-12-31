PlayerRect player;
GravRect[] gravArray = new GravRect[4];
PFont f;
boolean gamerunning = false;

final int windowX = 1024;
final int windowY = 768;

void setup() { 
  size(1024,768);
  frameRate(120);
  set_up_game();
  f = loadFont("TlwgTypist-48.vlw");
}

void set_up_game() {
  for (int iii=0;iii<=gravArray.length-1;iii++) {
    int randX = (int)(random(windowX));
    int randY = (int)(random(windowY));
    gravArray[iii]= new GravRect(new PVector(randX,randY),20,20, 255, 0, 0,140);
  }
  player = new PlayerRect(new PVector(40, 94), 5, 5, 0, 0, 255);
}

void activeCycle() {
  player.update();
  player.render();
  player.moveself();
  for (int iii=0;iii<=gravArray.length-1;iii++) {
    gravArray[iii].render();
    gravArray[iii].affect(player);
  }
}

void titleScreen() {
  textFont(f,48);
  text("Frictionleß",0,40);
  text("Press an arrow key to start", 200,200);
  if(checkKey("Up") || checkKey("Down") || checkKey("Left") || checkKey("Right")) {
    gamerunning = true;
  }
}

void draw() {
  background(150);
  if(gamerunning)  { activeCycle(); } else { titleScreen(); } //one-line if-else with brackets - like a boss.
}
