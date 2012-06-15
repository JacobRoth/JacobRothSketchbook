void mouseClicked() {
  println((mouseX*(1/scalefactor))+offsetX);
  println((mouseY*(1/scalefactor))+offsetY);
  for(int urph = 0; urph< 15; urph++) oids.add(new Oid(new PVector(random(0,400),random(0,400)),          new PVector(random(0,200),random(-10,10)),   random(1,50),color(255,255,0),color(255,0,0)));
  for(int urph = 0; urph< 15; urph++) oids.add(new Oid(new PVector(random(4000,4400),random(0,400)),      new PVector(random(-10,10),random(0,220)),   random(1,50),color(255,255,0),color(255,0,0)));
  for(int urph = 0; urph< 15; urph++) oids.add(new Oid(new PVector(random(4000,4400),random(4000,4400)),  new PVector(random(-220,0),random(-10,10)),  random(1,50),color(255,255,0),color(255,0,0)));
  for(int urph = 0; urph< 15; urph++) oids.add(new Oid(new PVector(random(0,400),random(4000,4400)),      new PVector(random(-10,10),random(-220,0)),  random(1,50),color(255,255,0),color(255,0,0)));
}
