ArrayList nodea;
int cycle = 0; 

final int runcycles = 0; // runcycles out of a hundred cycles will be run.
final int windowSize = 500;

void setup() {
  size(windowSize,windowSize);
  nodea = new ArrayList();
  frameRate(100);
  setMatrix(nodea);
}

void draw() {
  cycle++;
  if (cycle>100) {
    cycle = 0;
  }
  background(255);
  for (int iii=0;iii<=nodea.size()-1;iii++) { //cycle nodes
    Node firstnode = (Node) nodea.get(iii);
    firstnode.render();
    if (cycle<runcycles) { //hackish - jumps, then waits, rather than smooth slowdown, but it works.
      firstnode.update();
    }
  }
}

/*    
void mouseClicked() { 
  nodea.add( new Node(mouseX,mouseY) );
}
*/
void setMatrix(ArrayList nodelist) {
  int range = windowSize-20;
  for (int iii=1; iii<=range/20;iii++) {
    for (int jjj=1; jjj<=range/20;jjj++) {
      float someNoise = noise(iii,jjj);
      int partics = (int)(someNoise*255);
      nodelist.add(new Node(iii*20,jjj*20,partics));
    }
  }
}
    
    
    
    
class Node {
  float x;
  float y;
  ArrayList connections; //stores nearby nodes.
  int numparticles;
  Node(float inx, float iny) {
    x = inx;
    y = iny;
    connections = new ArrayList();
    numparticles = (int)random(255);
  }
  Node(float inx, float iny, int nump) {
    x = inx;
    y = iny;
    connections = new ArrayList();
    numparticles = nump;
  }
  void render() {
    fill(numparticles,0,0);
    ellipse(x,y,20,20);
    for (int iii=0; iii<=connections.size()-1; iii++) {
      Node othernode = (Node) connections.get(iii);
      //line(x,y,othernode.x,othernode.y);  //lines to connections
    }
  }
    
  
  void update() {
    seekConnections();   
    stroke(0);
    
    for (int iii=1; iii<=numparticles; iii++) { //transmit particles
      //stroke(0,0,255);                                  //
      //point(x+random(-25,25), y+random(-25,25));        //render particles     
      int nnum = (int)random(0,connections.size());
      Node thatnode = (Node) connections.get(nnum);
      sendParticle(thatnode);  
    }
  }
  
  void sendParticle(Node othernode) {
    numparticles-=1;
    othernode.numparticles+=1;
  }
  
  void seekConnections() {
    connections.clear();
    for (int iii=0;iii<=nodea.size()-1;iii++) {
      Node secondnode = (Node) nodea.get(iii);
      if (410 > (((secondnode.x-x)*(secondnode.x-x))+((secondnode.y-y)*(secondnode.y-y)))) { //euclidean dist
        connections.add(secondnode);
      }
    }
  }   
}


