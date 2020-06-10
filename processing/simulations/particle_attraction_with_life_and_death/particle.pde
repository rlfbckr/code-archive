class Particle {
  boolean dead = false;
  ArrayList <PVector> echo = new ArrayList();
  PVector pos = new PVector(random(width), random(height));
  int random_alpha = 0;
  int id = -1;

  public Particle(float x, float y) {
    pos.x =x;
    pos.y =y;
    random_alpha = (int)random(128, 255);
    
  }


  void update() {
    // hier wird das verhalten des partikels beschrieben.
    // brownien movement!
    if (echo.size() < particle_echo_length) {
      echo.add(new PVector(pos.x, pos.y));
    } else if (echo.size()>= particle_echo_length) {
      echo.remove(0);
      echo.add( new PVector(pos.x, pos.y));
    }
    for (int i = 0; i< attractors.size(); i++) {
      Attractor a = attractors.get(i);
      float dist_zum_attraktor = dist(pos.x, pos.y, a.pos.x, a.pos.y);
      if (dist_zum_attraktor < dead_dist) {
        dead = true;
      }
      // die attraktion nimmt proportional zur enfernung ab..
      float attraction = map(dist_zum_attraktor, 0, max_attraction_dist, max_acceleration, min_acceleration);

      if (dist_zum_attraktor < max_attraction_dist) {
        float new_x = (pos.x*attraction) + (a.pos.x*(1-attraction));
        float new_y = (pos.y*attraction) + (a.pos.y*(1-attraction));
        boolean collisons = false;
        // collision detection...
        // das hier macht es dann  langsam
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
      } else {
        pos.x+=random(-0.2, 0.2);
        pos.y+=random(-0.2, 0.2);
      }
    }
  }


  void draw() {
    //draw echo
    noFill();
    stroke(60, 128);
    beginShape();
    for (int i = 0; i< echo.size(); i++) {
      PVector e = echo.get(i);
      vertex(e.x, e.y);
    }
    vertex(pos.x, pos.y);
    endShape();

    noStroke();
    fill(255, random_alpha);
    if (dead) {
      ellipse(pos.x, pos.y, 15, 15);
    } else {
      ellipse(pos.x, pos.y, 4, 4);
    }
  }
}
