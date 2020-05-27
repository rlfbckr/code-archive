
SerialCommunication sc = new SerialCommunication();
volatile PImage blabla;
volatile int  dataschit;

void setup() {
  size(1000, 1000); 
  sc.start();
} 

void draw() {
  background(0);
  // draw stuff here
  fill(255);
  noStroke();
  textAlign(CENTER,CENTER);
  textSize(100);
  text(millis(), width/2, height/2);
}
