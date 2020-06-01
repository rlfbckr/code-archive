int rows = 20;
int cols = 20;
int step_x, step_y;

void setup() {
  size(500, 500);
  step_x = width/cols;
  step_y = width/rows;
  frameRate(10);
  noStroke();
}

void draw() {
  background(0);
  stroke(255);
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      if (int(random(2)) == 0) {
        fill(255);
      } else {
        fill(0);
      }
      rect(x*step_x, y*step_y, step_x, step_y);
    }
  }
}
