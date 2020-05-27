class Attractor {
  PVector pos = new PVector(random(width), random(height));
  PVector pos_target = new PVector(random(width), random(height));

  public Attractor(float x, float y) {
    pos.x =x;
    pos.y =y;
  }


  void update() {
    // hier wird das verhalten des partikels beschrieben.
    // die attraktoren bewegen sich züfallig von punkt zu punkt...
    pos.x = (pos.x*attractor_move_speed) + (pos_target.x*(1-attractor_move_speed));
    pos.y = (pos.y*attractor_move_speed) + (pos_target.y*(1-attractor_move_speed));

    if (dist(pos.x, pos.y, pos_target.x, pos_target.y) < 1) {
      pos_target.x =random(width);
      pos_target.y =random(height);
    }
    // etwas brownian noise on top
    pos.x +=random(-1, 1);
    pos.y +=random(-1, 1);
    //
  }

  void draw() {
    noStroke();
    fill(125, 0, 0, 200);
    ellipse(pos.x, pos.y, 12, 12);
  }
}
