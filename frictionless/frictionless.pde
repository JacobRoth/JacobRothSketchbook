PlayerRect mov = new PlayerRect(new PVector(40, 94), 5, 5, 0, 0, 255);
final int windowX = 800;
final int windowY = 600;
void setup() { size(windowX,windowY); }
void draw() {
  background(150);
  mov.update();
  mov.render();
  mov.moveself();
}
