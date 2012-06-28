//todo - add applyforce()
class Oid {
  PVector pos;
  PVector speed;
  float rad; //radius
  color col;
  color edgecol;
  boolean dead;
  Oid(PVector inpos, PVector inspd, float inrad, color incol, color inedgecol) {
    pos = inpos.get();
    speed = inspd.get();
    rad = inrad;
    col = incol;
    edgecol = inedgecol;
    dead = false;    
  }
  void render(float offsetX, float offsetY) {
    fill(col);
    stroke(edgecol);
    ellipseMode(CENTER);
    ellipse(pos.x-offsetX,pos.y-offsetY,rad,rad);
  }
  void render() {
    render(0,0);
  }
  void update() {
    pos.add(speed);
    //death check code:
    if(rad <= 0) dead = true;
  }
  void applyforce(PVector force) {
    PVector inforce = force.get();
    inforce.div(getMass());
    speed.add(inforce);
  }
  PVector getMomentumVector() {
    PVector retvector = speed.get();
    retvector.mult(getMass());
    return retvector;
  }
  boolean isOffSides(float windowX,float windowY) {
    if(pos.x < 0 || pos.x > windowX || pos.y < 0 || pos.y > windowY)
      return true;
    return false;
  }
  void gravitate(Oid target) {
    if(target.equals(this)) return; //don't gravitate yourself.
    float dx = pos.x - target.pos.x;
    float dy = pos.y - target.pos.y; 
    float dsquared = (dx*dx)+(dy*dy);
    float acc = getMass() / ( dsquared  );
    float d = sqrt( dsquared );
    float sinAngle = dy / d;
    float cosAngle = dx / d;
    float accX = acc * cosAngle;
    float accY = acc * sinAngle;
    PVector effect = new PVector( accX, accY);
    target.speed.add(effect);
  }
  boolean oidCollision(Oid other) {
    float combinedradius = rad+other.rad;
    float dx = other.pos.x - pos.x;
    float dy = other.pos.y - pos.y;
    //line(pos.x,pos.y,other.pos.x,other.pos.y); 
    float dsquared = (dx*dx)+(dy*dy);
    return (combinedradius*combinedradius*.25 > dsquared);
  }
  boolean isInsideMe(Oid other) {
    float dx = pos.x - other.pos.x;
    float dy = pos.y - other.pos.y; 
    float dsquared = (dx*dx)+(dy*dy);
    return ( dsquared< rad*rad/4 );
  }
  void collisionCode(Oid target) {
    if(!(target.equals(this))) { //not targeting myself
      if(target.rad<=rad) {//smaller than me, we can proceed.
        if(oidCollision(target)) {
          //println("collision!");
          if(isInsideMe(target)) {
            /*
            applyforce(target.getMomentumVector());
            target.applyforce(getMomentumVector());
            */
            
            /*
            PVector mymomentum = getMomentumVector();
            PVector othermomentum = target.getMomentumVector();
            applyforce(othermomentum);
            target.applyforce(mymomentum);
            */
            
            PVector mym = getMomentumVector();
            mym.add(target.getMomentumVector());
            
            rad += target.rad; //create new Oid, essentially, from the two old ones.
            target.rad = 0;
            
            mym.div(getMass());
            speed = mym;
            
  
          } /*else {
            PVector newspeed = target.speed.get();
            newspeed.mult(1/target.getMass());
            newspeed.div(getMass());
            speed.add(newspeed);
            rad++;
            target.rad--; 
          }*/
        }
      }
    }
  }
  float getMass() {
    return rad*rad;
  }
  void setMass(float input) {
    rad = sqrt(input);
  }
  Oid findNearestOidToPoint(ArrayList<Oid> oidshere, PVector thispoint) {
    /***
      returns the nearest Oid in the oidshere ArrayList, or returns null if can't find any.
      NEVER RETURNS MYSELF. returns null if it can't find anything other than itself.
    ***/
  
    float nearestDist = (float)Integer.MAX_VALUE;
    Oid returnme = null; //start out with variable empty
    //if(oidshere.size() <= 0) returnme = this; //if there's nobody else out there, return myself.    
    for(Oid thisoid: oidshere) {
      float d = dist(thispoint.x,thispoint.y,thisoid.pos.x,thisoid.pos.y);
      if(d < nearestDist && !(thisoid.equals(this))) {
        returnme=thisoid;
        nearestDist = d;
      }
    }
    return returnme;
  }
}
