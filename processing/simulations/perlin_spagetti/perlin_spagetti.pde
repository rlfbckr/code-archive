int rand = 100;

void setup() {
  size(1000, 1000, P2D); // opengl
}

void draw() {
  background(255);
  float t = map(mouseX, 0, width, -5, 5);
  curveTightness(t);
  curveDetail(20);
  strokeWeight(2.5);
  noFill();
  stroke(0,48);
  beginShape();
  for (int i = 0; i<10000; i++) {
    float x = noise(millis()*0.0001, i*10, 0)*width;
    float y = noise(millis()*0.0001, i*10, 1)*height;
    curveVertex(x, y);
  }
  endShape(CLOSE);
}
