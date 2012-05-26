final int windowX = 1024;
final int windowY =  768;


class Unit {
  PVector pos;
  PVector dest;
  Unit(PVector inpos) {
    pos = inpos.get();
    dest = inpos.get(); //set dest to where spawned.
  }
  Unit(PVector inpos, PVector indest) {
    pos = inpos.get();
    dest = indest;
  }
  void render() {
    stroke(255,0,0);
    point(dest.x,dest.y);
    stroke(255);
    point(pos.x,pos.y);
  }
  void update() {
    PVector mov = new PVector(dest.x-pos.x,dest.y-pos.y);
    mov.normalize();
    pos.add(mov);
  }
  Unit findNearest(ArrayList<Unit> seek) {
    double currdist = 9999999.9;
    Unit retme = this;
    for(int iii=0;iii<seek.size();iii++) {
      Unit foo = (Unit)seek.get(iii);
      double foodist = sqrt( (pos.x-foo.pos.x)*(pos.x-foo.pos.x) + (pos.y-foo.pos.y)*(pos.y-foo.pos.y) );
      if(foodist < currdist && !(foo.equals(this))) {
        currdist = foodist;
        retme = seek.get(iii);
      }
    }
    return retme;
  }
}

