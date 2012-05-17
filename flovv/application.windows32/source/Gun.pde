class Gun { //shoots little green squares.
  int numprojectiles;
  float projectilespeed;
  float projectilemass;
  
  int firerate; //is actually frames between shots
  float spreadangle; //in RADIANS, NOT degrees.
  long lastframeshot;
  
  color col;
  
  Gun(int numpr, float ps, int frate, float spreadradians, color incol, float inmass) { 
    numprojectiles = numpr;
    projectilespeed = ps;
    projectilemass = inmass;
    firerate = frate;
    spreadangle = spreadradians;
    lastframeshot = frameCount;
    col = incol;
  }
  
  
  PVector computeShot(MotileRect theShooter, float destX, float destY) {
    float atanval = atan2(destX-theShooter.getCX(),destY-theShooter.getCY()); //find the heading of where were shooting
    float sinRandomness = atanval+random(-1*spreadangle,spreadangle);
    float cosRandomness = atanval+random(-1*spreadangle,spreadangle);
    PVector effect = new PVector(sin(sinRandomness),cos(cosRandomness)); //add or sub from that ATAN
                      
    effect.normalize();
    effect.mult(projectilespeed);
    effect.mult(random(.85,1.15));
        
    return effect;
  }
  PVector advShot(PhysicsRect theShooter, float destX, float destY) { 
    PVector newV = computeShot(theShooter,destX,destY);
    
    PVector counterV = newV.get();
    counterV.mult(-1);                   //these bits apply recoil
    counterV.mult(projectilemass);       //recoil
    theShooter.applyforce(counterV);     //recoil
    
    newV.add(theShooter.speed); //projectile inheritance! SHAZBOT!
    
    return newV;
  }
  
  void fire(PhysicsRect theShooter, float Xloc, float Yloc, ArrayList putBulletsHere) { 
    if(lastframeshot+firerate<frameCount) { //enough frames has past
      for(int iii=0;iii<numprojectiles;iii++) { //shot several if we want
        lastframeshot = frameCount;
        putBulletsHere.add(new PhysicsRect(new PVector(theShooter.getCX(),theShooter.getCY()),0,0,col,advShot(theShooter,Xloc,Yloc),projectilemass));
      }
    }
  }
}
