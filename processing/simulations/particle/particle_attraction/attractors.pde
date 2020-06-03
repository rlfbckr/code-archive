class Attractor {
  PVector pos = new PVector(random(width), random(height));
  PVector pos_target = new PVector(random(width), random(height));
  int id = 0;
  public Attractor(float x, float y, int _id) {
    pos.x =x;
    pos.y =y;
    id = _id;
  }


  void update() {
    // hier wird das verhalten des partikels beschrieben.

    pos.x = map(noise(millis()*attractor_move_speed, id*100, 0),0.1,0.9,0,width);
    pos.y = map(noise(millis()*attractor_move_speed, id*100, 1000),0.1,0.9,0,height);

    // etwas brownian noise on top
    pos.x +=random(-1, 1);
    pos.y +=random(-1, 1);
  }

  void draw() {
    noStroke();
    fill(255, 255, 0, 200);
    ellipse(pos.x, pos.y, 12, 12);
  }
}
