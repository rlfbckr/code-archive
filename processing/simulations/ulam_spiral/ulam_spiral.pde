import controlP5.*;

ControlP5 cp5;

long steps = 1000000;
float r_step = 1;
float a_step = 1;
long t = 0;
float z = 0.005;
void setup() {
  size(900, 900, OPENGL);
  cp5 = new ControlP5(this);
  cp5.addSlider("r_step")
    .setPosition(20, 20)
    .setSize(350, 10)
    .setRange(0.01, 12)
    ;
  cp5.addSlider("a_step")
    .setPosition(20, 50)
    .setSize(350, 10)
    .setRange(0.01, 12)
    ;
}


void draw() {
  background(0);
  stroke(255, 80);
  pushMatrix();
  translate(width/2, height/2);

float r = 0;
float a = 0;
  for (long i = 0; i<steps; i++) {
    if (i%2 == 0) { //isPrime(i)) {
      point(sin(radians(a))*r, cos(radians(a))*r);
    }


    r=r+r_step*z;
     a=a+map(i, 0, steps, 10, a_step*z);
  }
  popMatrix();
  t++;
 // z=z*1.01;
  // saveFrame("ulam-######.png");
  println("t="+t);
}

boolean isPrime(long num) {
  if (num < 2) return false;
  if (num == 2) return true;
  if (num % 2 == 0) return false;
  for (int i = 3; i * i <= num; i += 2)
    if (num % i == 0) return false;
  return true;
}