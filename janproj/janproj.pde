PVector primary;
PVector subthis;
PVector foo3;

void setup() {
  size(640,480);
  primary = new PVector(100,0); //this is the bullet's vel
  subthis = new PVector(-50,4); //this is the player's vel?
  foo3 = primary.get();
  foo3.sub(subthis);
}

void draw() {
  background(0);
  stroke(255,255,255);
  line(250,250,250+primary.x,250+primary.y);
  stroke(140,140,140);
  line(250,250,250+subthis.x,250+subthis.y);
  stroke(255,0,0);
  line(250,250,250+foo3.x,250+foo3.y);
}
