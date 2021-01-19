import controlP5.*;
import processing.serial.*;
int servopos = 0;
int servopos_last = 0;

Serial myPort;
ControlP5 cp5;

int poti = 0;
int lightintensity = 0;
String SERIALCOMMAND = "";

void setup() {
  size(500, 500);
  printArray(Serial.list()); 
  myPort = new Serial(this, Serial.list()[3], 115200);
  textAlign(CENTER, CENTER);
  cp5 = new ControlP5(this);
  cp5.addSlider("servopos")
    .setPosition(10, 50)
    .setRange(0, 180)
    .setSize(400, 50)
    ;
}

void draw() {
  if (servopos != servopos_last) {
    myPort.write("["+servopos+"]");
    servopos_last = servopos;
  }
  background(map(lightintensity, 100, 500, 0, 255));

  textSize(200);
  fill(map(poti, 0, 1023, 0, 255));
  text(lightintensity, width/2, height/2);
  while (myPort.available() > 0) {
    String in = myPort.readStringUntil(10);
    if (in != null) {
      String[] data = split(trim(in), " ");
      if (data.length == 2) {
        println("light="+data[0]+ " poti=" +data[1]);
        lightintensity = int(data[0]);
        poti = int(data[1]);
      }
    }
  }
}

void keyReleased() {
  if (key == '0') {
    myPort.write("[0]");
  }
  if (key == '1') {
    myPort.write("[180]");
  }
}
