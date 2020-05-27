int w = 12;
int h = 19;

void setup() {
  size(520, 800,OPENGL);
  rectMode(CENTER);
}


void draw() {
  randomSeed(1);  
  background(255);
//  stroke(0);
  pushMatrix();
  translate(20,20);
  for (int y = 0; y<h; y++) {
    for (int x = 0; x<w; x++) {
      pushMatrix();
      translate((x+0.5)*10*4, (y+0.5)*10*4);
      translate(random(-y,y),random(-y,y));

      rotateZ(radians(random(-y*10,y*10)));
      rect(0,0, 10*4, 10*4);
      popMatrix();
    }
  }
  popMatrix();
}
