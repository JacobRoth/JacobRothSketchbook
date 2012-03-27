import fullscreen.*;
import japplemenubar.*;
//import processing.opengl.*;

FullScreen fs; 

void setup(){
  // set size to 640x480
  size(640, 480);
  
  // 5 fps
  frameRate(60);

  // Create the fullscreen object
  fs = new FullScreen(this); 
  
  // enter fullscreen mode
  fs.enter(); 
}


void draw(){
  background(0);
  
  // Do your fancy drawing here...
  for(int i = 0; i < 10; i++){
    fill(
      random(255),
      random(255),
      random(255)
    );

    rect(
      i*10, i*10,
      width - i*20, height - i*20
    ); 
  }
}

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
