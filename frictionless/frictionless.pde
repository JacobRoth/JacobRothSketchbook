import processing.opengl.*;

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
final boolean useDynamicBackground = true;
//[/CONFIG]

PlayerRect player;
GravRect sun;

ArrayList meteors;
Rectangle goldrect = new Rectangle(new PVector(20,20),goldRectSize,goldRectSize,255,255,0,true);

PFont f;
boolean gamerunning = false;

float backgroundNoise=0;

void setup() { 
  size(1024,768,OPENGL);
  frameRate(30);
  set_up_game();
  f = loadFont("TlwgTypist-48.vlw");
}

void set_up_game() {
  sun = new GravRect(new PVector(windowX/2,windowY/2),35,35,255,0,0,gravMag);
  player = new PlayerRect(new PVector(40, 94), 3, 3, 255, 255, 255);
  player.score = 0;
  placeGoldRect();
  meteors = new ArrayList();
}

void activeCycle() {
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

void titleScreen() {
  textFont(f,48);
  text("syßtem",0,40);
  text("Press K to start", 200,200);
  if(checkKey("K")) {
    set_up_game();
    gamerunning = true;
  }
  String scorestr = "Score: " + player.score;
  text(scorestr,0,720);
}


void draw() {
  if(useDynamicBackground) {
    background(noise(backgroundNoise)*backgroundBrightness);
    backgroundNoise += 0.01;
  } else {
    background(0);
  }
  if(gamerunning)  { activeCycle(); } else { titleScreen(); }
}
