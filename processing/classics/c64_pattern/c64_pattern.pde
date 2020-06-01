int rows = 50;
int cols = 50;
int step_x, step_y;

void setup() {
  size(1000, 1000);
  step_x = width/cols;
  step_y = width/rows;
  frameRate(25);
  noStroke();
}

void draw() {
  background(0,0,255);
  stroke(255);
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      if (noise(x*0.1,y*0.1,millis()*0.0001) > 0.5) {
        line(  x*step_x, 
          y*step_y, 
          (x*step_x)+step_x, 
          (y*step_y)+step_y);
      } else {
        line(  (x*step_x)+step_x, 
          y*step_y, 
          (x*step_x), 
          (y*step_y)+step_y);
      }
      //rect(x*step_x, y*step_y, step_x, step_y);
    }
  }
}
