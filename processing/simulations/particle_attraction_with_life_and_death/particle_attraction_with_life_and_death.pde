import java.util.List; 
import java.util.ArrayList; 
import java.util.Iterator; 
import controlP5.*;

ArrayList<Particle> particles = new ArrayList();
ArrayList<Attractor> attractors = new ArrayList();

float attractor_move_speed = 0.00001; // geschwindigkeit der attraktoren
float max_attraction_dist =500; // je kleinder desto schneller..
float particle_echo_length = 60; // particle pos history... oder so
long globel_iterations = 0;
int max_particle = 1500;
int dead_dist = 2;
int current_particle = 0;

boolean DEBUG = false;
boolean CLEAR = true;

ControlP5 cp5;

void setup() {
  size(1500, 1500, P2D);
  //fullScreen(P2D);
  for (int i = 0; i<25; i++) {
    Attractor a = new Attractor(random(0, width), random(0, height), i);
    attractors.add(a); // aufs array schmeissen...
  }

  ellipseMode(CENTER);
  textSize(20);
  frameRate(100);
  blendMode(LIGHTEST); // add up overlapping lines - looks cool
  createGUI();
}


void draw() {
  if (CLEAR) {
    background(0);
  }

  for (int i = 0; i< attractors.size(); i++) {
    Attractor a = attractors.get(i);
    a.update(); // berechne neue attraktor position...
    if (DEBUG) a.draw();
  }
  
  Iterator pitr = particles.iterator(); 
  while (pitr.hasNext()) { 
    Particle p = (Particle)pitr.next(); 
    if (p.dead) {
      pitr.remove();
      current_particle--;
    }
    if ((int)random(5) == 0) { // nur ab und zu mal neu berechnen... 1:6 wahrscheinlichkeit.. 
      p.update(); // berechne neue partikel position...
    }
    p.draw();
  }

  if ( current_particle < max_particle) {
    // spawn new particles
    Particle p = new Particle( random(0, width), random(0, height));
    particles.add(p); // aufs array
    current_particle++;
  }

  if (DEBUG) {
    drawGUI();
  }
  globel_iterations++;
}
