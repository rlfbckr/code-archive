ArrayList <Particle> particles = new ArrayList();
int anzahl = 100;

void setup() {
  size (1000, 1000, P2D);
  // 50 particle erzeugen...
  for (int i=0; i<anzahl; i++) {
    Particle p = new Particle(random(width), random(height));
    particles.add(p);
  }
}

void draw() {
  background(255);
  for (int i=0; i<anzahl; i++) {
    Particle p = particles.get(i);
    p.update();
    p.draw();
  }
}


class Particle {
  PVector pos;

  Particle(float x, float y) {
    pos = new PVector(x, y);
  }

  void update() {
    // neuberechnung der particle position

    float new_x = (pos.x*0.99) +(  mouseX *0.01);
    float new_y = (pos.y*0.99) +(  mouseY *0.01);

    boolean collision = false;
    for (int i=0; i<anzahl; i++) {
      Particle other_p = particles.get(i);
      if (this != other_p) {
        float dist = dist(new_x, new_y, other_p.pos.x, other_p.pos.y);
        if (dist < 10) {
          other_p.pos.x = other_p.pos.x+random(-60,60);
          other_p.pos.y = other_p.pos.y+random(-60,60);
          collision = true;
          break;
        }
      }
    }
    if (collision == false) {
      pos.x = new_x;
      pos.y = new_y;
      pos.x = pos.x+ random(-1, 1);
      pos.y = pos.y+ random(-1, 1);
    }
  }

  void draw() {
    fill(0, 40);
    ellipse(pos.x, pos.y, 10, 10);
  }
}
