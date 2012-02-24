int lastClickedX = 0;
int lastClickedY = 0;

void setup () {
  size(500,500);
}

void draw() {
  if (mousePressed) {
     lastClickedX = mouseX;
     lastClickedY = mouseY;
  }
  
  fill(0);
  rect(0,0,500,500);
  
  fill(0,0,255);
  ellipse(mouseX, mouseY, 50,50);
  
  fill(255,0,0);
  ellipse(lastClickedX,lastClickedY,25,25);
}
