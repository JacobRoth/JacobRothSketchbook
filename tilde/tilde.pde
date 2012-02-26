/*GPL licenced */
final int windowSize = 600;
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
}
