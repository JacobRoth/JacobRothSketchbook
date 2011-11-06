class Rectangle {
  int x; //position
  int y;
  
  int h;
  int w;
  
  int mvmntx;
  int mvmnty;
  
  int r;
  int g;
  int b;

  int lifespan;
  int life;
  
  int fissility; //how much it divides = 1/fissility chance every frame
    
  Rectangle (int c1x, int c1y) { //constructor
    x = c1x;
    y = c1y;
    h = 20;
    w = 20;
    r = round(random(255));
    g = round(random(255));
    b = round(random(255));
    mvmntx = round(random(-2,3)); 
    mvmnty = round(random(-2,3)); 
    
    lifespan = round(random(700,1000));
    life = lifespan;
    fissility = round(random(800,800));
  }
  
  Rectangle (int c1x, int c1y, int inr, int ing, int inb, int fiss, int lf) { //totally specific constructor
    x = c1x;
    y = c1y;
    h = 20;
    w = 20;
    r = inr;
    g = ing;
    b = inb;
    
    mvmntx = round(random(-2,3)); 
    mvmnty = round(random(-2,3)); 
    
    lifespan = lf;
    life = lifespan;
    fissility = fiss;
  }
  
  void boundryCheck() {
    if (x < 0) {
      mvmntx = round(random(1,3));
      if (mvmnty == 0) { //fix the "straight movement" problem
        mvmnty = round(random(-2,3)); 
      }
    }
    if (x+w > windowSize) {
      mvmntx = round(random(-2,0));
      if (mvmnty == 0) { //fix the "straight movement" problem
        mvmnty = round(random(-2,3)); 
      }
    }
    if (y < 0) {
      mvmnty = round(random(1,3));
      if (mvmntx == 0) { //fix the "straight movement" problem
        mvmntx = round(random(-2,3)); 
      }
    }  
    if (y+h > windowSize) {
      mvmnty = round(random(-2,0));
      if (mvmntx == 0) { //fix the "straight movement" problem
        mvmntx = round(random(-2,3)); 
      }
    }
  }
  
  void moveRect() {
    x = x+mvmntx;
    y = y+mvmnty;
  }
  
  void render () {
    fill(r,g,b);
    rect(x,y,w,h);
  }
  
  
  void die(ArrayList whatList) {
    whatList.remove(this);
  }
 
  void fission(ArrayList whatList) {
    whatList.remove(this);
    whatList.add(new Rectangle(x-10,y-10,r,g,b,fissility,lifespan));
    whatList.add(new Rectangle(x+w+20,y+h+20,r,g,b,fissility,lifespan));
  }
  
  void update(ArrayList ArrayListIn) {
    if(AGING) {
      life = life-1; //age
    }
    boundryCheck();
    moveRect();
    render();
    if (life < 0) {
      die(ArrayListIn);
    }
    if (round(random(0,fissility)) == 3) { // 1/fiss chance to undergo fission each frame.
      fission(ArrayListIn);
    }
  }
}
