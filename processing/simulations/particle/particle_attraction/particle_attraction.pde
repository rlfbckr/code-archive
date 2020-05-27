ArrayList<Particle> particles = new ArrayList();
ArrayList<Attractor> attractors = new ArrayList();

float attractor_move_speed = 0.999; // geschwindigkeit der attraktoren
float max_attraction_dist = 150; // je kleinder desto schneller..
float particle_echo_length = 30; // particle pos history... oder so
long globel_iterations = 0;
void setup() {
//  size(2000, 1000, P2D);
  fillscreen(P2D);
  for (int i = 0; i<1000; i++) {
    Particle p = new Particle(i,random(0, width), random(0, height));
    particles.add(p); // aufs array schmeissen...
  }


  for (int i = 0; i<30; i++) {
    Attractor a = new Attractor(random(0, width), random(0, height));
    attractors.add(a); // aufs array schmeissen...
  }

  ellipseMode(CENTER);
  textSize(50);
  frameRate(100);
}


void draw() {
  background(0);

  for (int i = 0; i< attractors.size(); i++) {

    Attractor a = attractors.get(i);
    a.update(); // berechne neue attraktor position...
    a.draw();
  }

  for (int i = 0; i< particles.size(); i++) {
    Particle p = particles.get(i);
    if ((int)random(15) == 0) { // nur ab und zu mal neu berechnen... 1:6 wahrscheinlichkeit.. 
      p.update(); // berechne neue partikel position...
    }
    p.draw();
  }



  fill(255);
  text("fps: "+frameRate, 40, 40);
  globel_iterations++;
}
