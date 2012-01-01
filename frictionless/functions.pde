/*void mouseClicked() {
  player.pos.x = mouseX;
  player.pos.y = mouseY;
  player.speed = new PVector(0,0); //reset it
}*/



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

void placeGoldRect() {
  int randX = (int)(random(windowX-goldRectSize));
  int randY = (int)(random(windowY-goldRectSize));
  goldrect.pos = new PVector(randX,randY);
}

void fireMeteor() { //from the edge of the screen.
  int screenedge = (int)(random(0,4));
  if (screenedge == 0) { //the left edge
    int posx = 1;
    int posy = (int)(random(0,windowY-meteorSize));
    float speedx = random(0,meteorTopSpeed);
    float speedy = random(-1*meteorTopSpeed,meteorTopSpeed);
    meteors.add(new MotileRect(new PVector(posx,posy),meteorSize,meteorSize,0,140,50,new PVector(speedx,speedy)));
  }
}

class Trigger { //by kritzikratzi
  long start = millis(); 
  int rate; 

  public Trigger( int rate ) {
    this( rate, false );
  }
  /**
   * additional boolean parameter to indicate whether the trigger 
   * should fire immediately
   */
  public Trigger( int rate, boolean immediately) {
    setRate( rate ); 
    if ( immediately ) start -= rate;
  }

  /** 
   * changes the rate at which the trigger fires in milliseconds 
   */
  public void setRate( int rate ) {
    this.rate = rate;
  }
  public int getRate() {
    return rate;
  }
  /**
   * returns true if the trigger has fired, false otherwise
   */
  public boolean fires() {
    if ( millis() - start >= rate ) {
      start += rate; 
      return true;
    }
    else {
      return false;
    }
  }
  /**
   * resets the timer, 
   * next trigger will occur in _rate_ milliseconds.  
   */
  public void reset() {
    start = millis();
  }
}
