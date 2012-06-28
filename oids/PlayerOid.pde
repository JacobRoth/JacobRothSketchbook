class PlayerOid extends Oid {
  final String[] upLeftDownRight = {"W","A","S","D"};
  PlayerOid(PVector inpos, PVector inspd, float inrad, color incol, color inedgecol) {
    super(inpos,inspd,inrad,incol,inedgecol);
  }
  void update() {
    super.update();
    if(checkKey(upLeftDownRight[0])) {
      //go up
      //println("going up");
      applyforce(new PVector(0,-10));
    } else if(checkKey(upLeftDownRight[2])) {
      //go down
      //println("going down");
      applyforce(new PVector(0,10));
    }
    if(checkKey(upLeftDownRight[1])) {
      //go left
      //println("going left");
      applyforce(new PVector(-10,0));
    } else if(checkKey(upLeftDownRight[3])) {
      //go right
      //println("going right");
      applyforce(new PVector(10,0));
    }
  }
}
