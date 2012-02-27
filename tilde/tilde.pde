/*GPL licenced */
final int windowSize = 600;
PFont f;
long frame = 0;

PlayerRect player;
ArrayList enemies;
ArrayList playersBullets;
ArrayList enemiesBullets;


boolean[] keys = new boolean[526];
boolean checkKey(String k) {
  for (int i = 0; i < keys.length; i++) {
    if (KeyEvent.getKeyText(i).toLowerCase().equals(k.toLowerCase())) {
      return keys[i];
    }
  }
  return false;
}
void keyPressed()
{
  keys[keyCode] = true;
  //println(KeyEvent.getKeyText(keyCode));
}

void keyReleased()
{ 
  keys[keyCode] = false;
}

void setup() { 
  size(windowSize,windowSize);
  frameRate(40);
  f = loadFont("Braggadocio-48.vlw");
  player = new PlayerRect(new PVector(300,300),20,20,255,0,0);
  enemies = new ArrayList();
}
void draw() {
  boolean gameOver = false;
  frame++;
  background(0);
  
  for(int iii=0;iii<enemies.size();iii++) {
    MotileRect thisEnemy = (MotileRect) enemies.get(iii);
    thisEnemy.render();
    thisEnemy.update();
    if(rectCollision(thisEnemy,player)) gameOver=true;
    if(thisEnemy.isOffSides(windowSize,windowSize)) enemies.remove(this);
  }
  player.render();
  player.update();
  player.moveself();
  if(player.isOffSides(windowSize,windowSize)) gameOver=true; 
  if(gameOver) setup(); // a call to setup(); resets the game :D
}
