import peasy.PeasyCam;
PeasyCam cam;
// https://en.wikipedia.org/wiki/Z-fighting

public void setup() {
  fullScreen(OPENGL);
  cam = new PeasyCam(this, 400);
  rectMode(CENTER);
  ellipseMode(CENTER);
}

public void draw() {
  background(0);
  fill(255, 0, 0);
  rect(0, 0, 100, 100);
  fill(0, 255, 0);
  // translate(0,0,0.1);
  ellipse(0, 0, 100, 100);
}
