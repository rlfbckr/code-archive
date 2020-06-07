class Particle {
  ArrayList <PVector> echo = new ArrayList();
  PVector pos = new PVector(random(width), random(height));
  int random_alpha = 0;
  int id = -1;
  public Particle(int _id, float x, float y) {
    id = _id;
    pos.x =x;
    pos.y =y;
    random_alpha = (int)random(128, 255);
  }


  void update() {
    // hier wird das verhalten des partikels beschrieben.
    // brownien movement!
    // pos.x +=random(-1,1);
    // pos.y +=random(-1,1);
    // if (globel_iterations % 50 == 0) {
    if (echo.size() < particle_echo_length) {
      echo.add(new PVector(pos.x, pos.y));
    } else if (echo.size()>= particle_echo_length) {
      echo.remove(0);
      echo.add( new PVector(pos.x, pos.y));
    }
    //if (id == 0) println(echo.size());
    //}
    for (int i = 0; i< attractors.size(); i++) {
      Attractor a = attractors.get(i);
      float dist_zum_attraktor = dist(pos.x, pos.y, a.pos.x, a.pos.y);
      // die attraktion nimmt proportional zur enfernung ab..
      float attraction = map(dist_zum_attraktor, 0, max_attraction_dist, 0.999, 0.991);

      if (dist_zum_attraktor < max_attraction_dist) {
        float new_x = (pos.x*attraction) + (a.pos.x*(1-attraction));
        float new_y = (pos.y*attraction) + (a.pos.y*(1-attraction));
        boolean collisons = false;
        // collision detection...
        // das hier mache es dann sehr langsam

        for (int j = 0; j< particles.size(); j++) {
          Particle other = particles.get(j);
          if (this != other) { // alle ausser ich
            if (dist(new_x, new_y, other.pos.x, other.pos.y) <5) {
              collisons = true; // DONT MOVE
            }
          }
        }
        if (collisons == false) {
          pos.x= new_x;
          pos.y= new_y;
        }
      }
    }
  }


  void draw() {

    //draw echo
    noFill();
    stroke(88, 128);
    beginShape();
    for (int i = 0; i< echo.size(); i++) {
      PVector e = echo.get(i);
      vertex(e.x, e.y);
    }
    vertex(pos.x, pos.y);
    endShape();
    noStroke();
    fill(255, random_alpha);
    ellipse(pos.x, pos.y, 4, 4);
  }
}
