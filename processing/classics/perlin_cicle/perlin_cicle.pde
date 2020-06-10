float radius = 600;
float smoothness = 5;
float speed = 0.0001;


void setup() {
  size(1000, 1000, P2D);
}


void draw() {
  background(0);
  stroke(255);
  noFill();
  pushMatrix();
  translate(width/2, height/2);

  beginShape();
  for (float a = 0; a < 360; a=a+2) {
    float x_off = cos(radians(a))+1;
    float y_off = sin(radians(a))+1;
    float r = noise(x_off*smoothness, y_off*smoothness, millis()*speed)*radius;

    float x = cos(radians(a))*r;
    float y = sin(radians(a))*r;

    vertex(x, y);
  }
  endShape(CLOSE);
  popMatrix();
}
