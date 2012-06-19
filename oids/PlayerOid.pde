class PlayerOid extends Oid {
  final String[] upLeftDownRight = {"W","A","S","D"};
  PlayerOid(PVector inpos, PVector inspd, float inrad, color incol, color inedgecol) {
    super(inpos,inspd,inrad,incol,inedgecol);
  }
  void update() {
    super.update();
  }
}
