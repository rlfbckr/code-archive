#include "Streaming.h"
#include "SerialReceiver.h"

SerialReceiver receiver = SerialReceiver();

void setup() {
    Serial.begin(9600);
}

void loop() {
    int myInt;
    float myFloat;

    while (Serial.available() > 0) {
        receiver.process(Serial.read());
        if (receiver.messageReady()) {
            Serial << "Message Ready" << endl;
            Serial << "-------------" << endl;
            myInt = receiver.readInt(0);
            myFloat = receiver.readFloat(1);
            Serial << "myInt = " << _DEC(myInt) << endl;
            Serial << "myFloat = " << myFloat << endl;
            Serial << "-------------" << endl;
            Serial << endl;
            receiver.reset();
        }
    }
}

