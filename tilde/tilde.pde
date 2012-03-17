/*TODO:
make a Bullet class,
*/

/*GPL licenced */
final int windowSize = 720;
PFont f;

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
  frameRate(30);
  f = loadFont("Braggadocio-48.vlw");
  player = new PlayerRect(new PVector(300,300),24,24,255,0,0);
  enemies = new ArrayList();
  playersBullets = new ArrayList();
}
void draw() {
  println(frameRate);
  
  boolean gameOver = false;
  background(0);
  
  for(int iii=0;iii<enemies.size();iii++) {
    MotileRect thisEnemy = (MotileRect) enemies.get(iii);
    thisEnemy.render();
    thisEnemy.update();
    if(rectCollision(thisEnemy,player)) gameOver=true;
    if(thisEnemy.isOffSides()) enemies.remove(this);
  }
  for(int iii=0;iii<playersBullets.size();iii++) {
    if(playersBullets.get(iii).getClass().getSimpleName().equals("MotileRect")) {
      MotileRect thisBullet = (MotileRect) playersBullets.get(iii);
    
      thisBullet.render();
      thisBullet.update(); //is somehow affecting player.pos

      //collisiondetect against enemies, plz
      if(thisBullet.isOffSides()) playersBullets.remove(thisBullet);
    } else if (playersBullets.get(iii).getClass().getSimpleName().equals("Zapwave")) {
      Zapwave thisWave = (Zapwave) playersBullets.get(iii);
    
      thisWave.render();
      thisWave.update(); //is somehow affecting player.pos

      //collisiondetect against enemies, plz
      if(thisWave.isOffSides()) playersBullets.remove(thisWave);
    }
  }
  
  player.render();
  player.update();
  player.moveself();
  if(mousePressed) player.fireMyWeapon();
  if(player.isOffSides()) gameOver=true; 
  
  if(gameOver) setup(); // a call to setup(); resets the game :D
}
