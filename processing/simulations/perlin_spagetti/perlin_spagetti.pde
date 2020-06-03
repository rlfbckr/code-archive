int anazahl = 500;
float speed = 0.0001;

void setup() {
  size(1000, 1000, P2D); // opengl
  ellipseMode(CENTER);
  smooth(8);
}

void draw() {
  background(255);
  curveTightness(map(mouseX, 0, width, -5, 5));
  speed = map(mouseY, 0, height, 0.001, 0.00001);
  curveDetail(20);
  noFill();
  stroke(50, 48);
  beginShape();
  long now = millis();
  for (int i = 0; i<anazahl; i++) {
    float x = noise(now*speed, i*10, 0)*width;
    float y = noise(now*speed, i*10, 1)*height;
    curveVertex(x, y);
  }
  endShape(CLOSE);
  noStroke();
  fill(0);
  for (int i = 0; i<anazahl; i++) {
    float x = noise(now*speed, i*10, 0)*width;
    float y = noise(now*speed, i*10, 1)*height;
    ellipse(x, y, 7, 7);
  }
}
