#include <Servo.h>
#include "Streaming.h"
#include "SerialReceiver.h"

int lightpin = A0;
int potipin = A1;
int servopin = 5;

SerialReceiver receiver = SerialReceiver();


Servo myservo;
void setup() {
  Serial.begin(115200);
  myservo.attach(servopin);
  myservo.write(0);
}

void loop() {
  messageCompleted();
  Serial.print(analogRead(lightpin));
  Serial.print(" ");
  Serial.println(analogRead(potipin));
  delay(20);
}

void messageCompleted() {
  // [0 - 180]
  while ( Serial.available() > 0 ) {
    receiver.process(Serial.read());
    if (receiver.messageReady()) {
      if (receiver.numberOfItems() == 1) {
        myservo.write(receiver.readInt(0));
        receiver.reset();
      }
    }
  }
}
