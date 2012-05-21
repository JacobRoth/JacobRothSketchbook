ArrayList<Unit> units;
ArrayList<FluxBeacon> beacons;
void setup() {
  size(1024,768);
  units = new ArrayList<Unit>();
  beacons = new ArrayList<Beacons>();
}

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
  void update(ArrayList<Unit> unitslive) {
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
class FluxBeacon {
  PVector pos;
  PVector dest;
  float rad;
  float speed;
  FluxBeacon(PVector inpos, PVector indest, float inrad, float inspeed) {
    rad = inrad;
    speed = inspeed
    pos = inpos.get();
    dest = indest.get();
  }
  void render() {
    noFill();
    stroke(0,255,0);
    ellipse(pos.x,pos.y,rad,rad);
  }
  void update() {
    PVector mov = new PVector(dest.x-pos.x,dest.y-pos.y);
    mov.normalize();
    mov.mult(speed);
    pos.add(mov);
  }
  void sweepUnits(ArrayList<Unit> seek) {
    for(Unit foo: seek) {
      double foodist = sqrt( (pos.x-foo.pos.x)*(pos.x-foo.pos.x) + (pos.y-foo.pos.y)*(pos.y-foo.pos.y) );
      if(foodist < rad) {
        foo.dest = dest.get();
      }
    }
  }
}
    
