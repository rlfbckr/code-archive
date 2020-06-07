float noiseLevel = 2.2;
float speed = 0.0001;
int resolution = 100;
float radius_min = 0;
float radius_max = 200;
float blobbyness = 300;
int steps = 40;

void setup() {
  size(1000, 1000, P2D);
//  fullScreen(P2D);
  smooth(8);
  //  blendMode(ADD);
  blendMode(LIGHTEST); // add up overlapping lines - looks cool
}


void draw() {
  background(5);
  stroke(255, 0, 0, 128);
  drawBlobbyCircleSet(width/2, height/2, radius_min, radius_max, steps, 300);
  stroke(0, 255, 0, 128);
  drawBlobbyCircleSet((width/2)+6, (height/2), radius_min, radius_max, steps, 300);
  stroke(0, 0, 255, 128);
  drawBlobbyCircleSet((width/2), (height/2)+6, radius_min, radius_max, steps, 300);
}

void drawBlobbyCircleSet(float x, float y, float min_r, float max_r, int r_steps, float blobbyness) {
  pushMatrix();
  translate(x, y);
  for (float f = 0; f <1; f+=(1.0/r_steps)) {
    float r = map(f, 0, 1, min_r, max_r);
    drawBlobbyCircle(millis()+(f*300), r, r+(f*blobbyness));
  }
  popMatrix();
}

void drawBlobbyCircle(float time, float min_r, float max_r ) {
  noFill();
  beginShape();
  for (float a = 0; a<TWO_PI; a=a+(TWO_PI/resolution)) {

    float r= map(noise(time*speed, map(cos(a), -1, 1, 0, noiseLevel), map(sin(a), -1, 1, 0, noiseLevel)), 0, 1, min_r, max_r);
    float x = cos(a)*r;
    float y = sin(a)*r;
    vertex(x, y);
  }
  endShape(CLOSE);
}
