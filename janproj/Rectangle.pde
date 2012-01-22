class Rectangle {
  PVector pos;

  int h;
  int w;

  int r;
  int g;
  int b;

  boolean hollow;

  Rectangle (PVector inpos, int inw, int inh, int inr, int ing, int inb, boolean inhollow) { //non-hollow
    pos = inpos;
    h = inh;
    w = inw;
    r = inr;
    g = ing;
    b = inb;
    hollow = inhollow;
  }
  Rectangle (PVector inpos, int inw, int inh, int inr, int ing, int inb) {
    this(inpos,inw,inh,inr,ing,inb,false);
  } 
  void render () {
    stroke(r,g,b);
    if(hollow) {
      noFill();
    } else {
      fill(r, g, b);
    }
    rect(pos.x, pos.y, w, h);
    stroke(r,g,b); 
  }
}
