class PlayerRect extends MotileRect {
  int score;
  PlayerRect(PVector inpos, int inw, int inh, int inr, int ing, int inb) {
    super(inpos, inw, inh, inr, ing, inb, new PVector(0,0)); //start out speedless
    score = 0;
  }
  void moveself() {
    if (checkKey("Up") || checkKey("W")) {
      speed.y = -10;
      speed.x = 0;
    }
    if (checkKey("Down") || checkKey("S")) {
      speed.y = 10;
      speed.x = 0;
    }
    if (checkKey("Left") || checkKey("A")) {
      speed.x = -10;
      speed.y = 0;
    }
    if (checkKey("Right") || checkKey("D")) {
      speed.x = 10;
      speed.y = 0;
    }
  }
  
}

