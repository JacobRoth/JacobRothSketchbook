Rectangle foo = new Rectangle(new PVector(20,20),30,30,0,255,255);
MotileRect movie = new MotileRect(new PVector(2,2),5,5,0,0,255,new PVector(0.005,0.005));

void draw() {
  foo.render();
  movie.update();
  movie.render();
}

class Rectangle {
  PVector pos;

  int h;
  int w;

  int r;
  int g;
  int b;

  /*Rectangle (float c1x, float c1y) { //constructor
    x = c1x;
    y = c1y;
    h = 20;
    w = 20;
    r = round(random(255));
    g = round(random(255));
    b = round(random(255));
  }*/
  
  Rectangle (PVector inpos, int inw, int inh, int inr, int ing, int inb) { //define with a vector
    pos = inpos;
    h = inh;
    w = inw;
    r = inr;
    g = ing;
    b = inb;
  }

  void render () {
    fill(r, g, b);
    noStroke();
    rect(pos.x, pos.y, w, h);
  }
}

class MotileRect extends Rectangle {
  private PVector speed; //in pixels per millisecond. //keeping
  Trigger timer; 
  MotileRect(PVector inpos, int inw, int inh, int inr, int ing, int inb, PVector inspd) {
    super(inpos,inw,inh,inr,ing,inb);
    setSpeed(inspd);
    timer = new Trigger(100); 
  }
  void update() {
    while (timer.fires()) {
      pos.add(speed); //reduces the vector by 1/10th, because the vector is in dist per sec and this calculates every 1/10 sec
    }
  }
  void setSpeed(PVector pixPerSec) {
    speed = pixPerSec;
    speed.mult(0.1);
  }
}


// The trigger class, by kritzikratzi
class Trigger{
  long start = millis(); 
  int rate; 
  
  public Trigger( int rate ){
    this( rate, false ); 
  }
  
  /**
   * additional boolean parameter to indicate whether the trigger 
   * should fire immediately
   */
   public Trigger( int rate, boolean immediately) {
     setRate( rate ); 
     if( immediately ) start -= rate; 
   }
   
  /** 
   * changes the rate at which the trigger fires in milliseconds 
   */
  public void setRate( int rate ){
    this.rate = rate; 
  }
  
  /**
   * returns the rate at which the trigger fires, in milliseconds
   */
  public int getRate(){
    return rate; 
  }
  
  /**
   * returns true if the trigger has fired, false otherwise
   */
  public boolean fires(){
    if( millis() - start >= rate ){
      start += rate; 
      return true; 
    }
    else{
      return false; 
    }
  }
  
  /**
   * resets the timer, 
   * next trigger will occur in _rate_ milliseconds.  
   */
  public void reset(){
    start = millis(); 
  }
}


