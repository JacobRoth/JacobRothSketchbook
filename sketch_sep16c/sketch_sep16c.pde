final int windowSize = 500;
int[][] heatarray = new int[windowSize][windowSize];
int[][] bufferarray = new int[windowSize][windowSize];
int totalheat = 0;

void setup() {
  size(windowSize, windowSize);
  frameRate(200);
  for (int iii=0; iii<=(windowSize-1); iii++) {
    for (int jjj=0; jjj<=(windowSize-1); jjj++) {
      heatarray[iii][jjj] = round((noise(iii/200,jjj/200)*200));
    }
  }
}

void draw() {
  println(millis());
  /*
  totalheat = 0;
  bufferarray = heatarray;
  for (int iii=0; iii<=(windowSize-1); iii++) {
    for (int jjj=0; jjj<=(windowSize-1); jjj++) {
      if ((iii>0) && (iii<windowSize-1) && (jjj>0) && (jjj<windowSize-1)) { //middle piece
        bufferarray[iii][jjj] = (heatarray[iii+1][jjj] + heatarray[iii-1][jjj] + heatarray[iii][jjj+1] + heatarray [iii][jjj-1])/4;
      } else if ((iii==0) && (jjj==0)) { //topleft corner
        bufferarray[iii][jjj] = (heatarray[iii+1][jjj] + heatarray[iii][jjj+1])/2;
      } else if ((iii==0) && (jjj==windowSize-1)) { //bottomleft corner
        bufferarray[iii][jjj] = (heatarray[iii+1][jjj] + heatarray[iii][jjj-1])/2;
      }
      
      
      stroke(heatarray[iii][jjj],heatarray[iii][jjj],heatarray[iii][jjj]);
      totalheat += heatarray[iii][jjj];
      point(iii,jjj);
    }
  }
  heatarray = bufferarray;
  println(totalheat/250000); */
}



