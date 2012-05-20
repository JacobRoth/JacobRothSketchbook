import processing.opengl.*;

/*I dreamed up the following system:

>>There is a threatmap that threat markers can be dropped on.
>>Each time a threat marker is dropped it is assigned to a war unit* and that unit becomes a "leader". The leader marches toward the marker location.
>>All non-leader war units GUARD the nearest leader, thus joining it's herd.
>>Once a leader reaches it's threat marker, it loses leader status and the herd disbands.

>>If a unit dies it drops a threat marker
>>Threat markers are randomly dropped on resource locations. This will give the AI the effect of scouting for / raididing enemy mining operations, AND defeding it's own mining operations
>> threat markers are occasionally dropped on the AI's own base, to ensure the area around the base is well policed by units going in and out.

If a unit gets shot by the enemy drop a threat marker.
*/
final int numUnits = 3000; //must be greater than 1. must always be 2+ units on screen or will crash.
final int windowX = 1024;
final int windowY = 768;
ArrayList<Unit> myUnits;

class Unit {
  PVector pos;
  PVector dest;
  boolean isLeader;
  Unit(PVector inpos) {
    pos = inpos.get();
    dest = inpos.get(); //set dest to nowhere.
    isLeader = false;
  }
  Unit(PVector inpos, PVector indest) {
    pos = inpos.get();
    isLeader = false;
    dest = indest;
  }
  void render() {
    stroke(255,0,0);
    point(dest.x,dest.y);
    stroke(255);
    point(pos.x,pos.y);
    if(isLeader) {
      stroke(0,0,255);
      noFill();
      ellipse(pos.x,pos.y,3,3);
    }
  }
  void update(ArrayList<Unit> unitslive) {
    render();
    PVector mov = new PVector(dest.x-pos.x,dest.y-pos.y);
    mov.normalize();
    pos.add(mov);
    if(isLeader && (int)(pos.x-dest.x) == 0 && (int)(pos.y-dest.y) == 0) {
      isLeader = false;
    }
    dest = findNearestLeader(unitslive).dest.get();
  }
  Unit findNearest(ArrayList<Unit> seek) {
    double currdist = 9999999.9;
    int retme = 0 ;
    for(int iii=0;iii<seek.size();iii++) {
      Unit foo = (Unit)seek.get(iii);
      if(sqrt( (pos.x-foo.pos.x)*(pos.x-foo.pos.x) + (pos.y-foo.pos.y)*(pos.y-foo.pos.y) ) < currdist && !(foo.equals(this))) {
        currdist = sqrt( (pos.x-foo.pos.x)*(pos.x-foo.pos.x) + (pos.y-foo.pos.y)*(pos.y-foo.pos.y) );
        retme = iii;
      }
    }
    return seek.get(retme);
  }
  Unit findNearestLeader(ArrayList<Unit> seek) {
    if(isLeader)
      return this;
    double currdist = 9999999.9;
    Unit retme = this;
    for(int iii=0;iii<seek.size();iii++) {
      Unit foo = (Unit)seek.get(iii);
      if( (pos.x-foo.pos.x)*(pos.x-foo.pos.x) + (pos.y-foo.pos.y)*(pos.y-foo.pos.y)  < currdist*currdist && foo.isLeader) {
        currdist = sqrt( (pos.x-foo.pos.x)*(pos.x-foo.pos.x) + (pos.y-foo.pos.y)*(pos.y-foo.pos.y) );
        retme = seek.get(iii);
      }
    }
    return retme;
  }   
}
void mouseClicked() {
  fill(255);
  ellipse(mouseX,mouseY,30,30);
  
  int pickedunit = (int)random(0,myUnits.size());
  for (int iii=0; (myUnits.get(pickedunit).isLeader)&&iii<myUnits.size();iii++) { //this wacky for loop SHOULD have the effect of making sure we only do as many attemts as there are units
    pickedunit = (int)random(0,myUnits.size()); //try again
  }
  myUnits.get(pickedunit).dest = new PVector(mouseX,mouseY);
  myUnits.get(pickedunit).isLeader = true;
}
void addUnitToGame() {
  PVector loc = new PVector((int)(random(0,windowX)),(int)(random(0,windowY)));
  myUnits.add(new Unit(loc,loc));
}
void setup() {
  size(windowX,windowY,OPENGL);
  myUnits = new ArrayList<Unit>();
  for(int iii=0;iii<numUnits;iii++) {
    addUnitToGame();
  }
}
void draw() {
  background(0);
  for(Unit foo: myUnits) {
    foo.update(myUnits);
  }
  if(frameCount%60==0) {
    addUnitToGame();
  }
}
