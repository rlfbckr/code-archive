/*
  #include "DHT.h"
  const int DHTPIN = 2;
  #define DHTTYPE DHT11

  DHT dht(DHTPIN, DHTTYPE);
*/

const int FOTO1 = A0;
const int FOTO2 = A1;
const int FOTO3 = A2;

void setup() {
  Serial.begin(115200);
  //  dht.begin();
}

void loop() {
  /*
    float h = dht.readHumidity();
    float t = dht.readTemperature();
    if (isnan(h) || isnan(t)) {
    Serial.println("Fehler beim auslesen des Sensors!");
    return;
    }
  */
  Serial.print(analogRead(FOTO1));
  Serial.print(" ");
  Serial.print(analogRead(FOTO2));
  Serial.print(" ");
  Serial.print(analogRead(FOTO3));
  /*
    Serial.print(h);
    Serial.print(" ");
    Serial.print(t);
  */
  Serial.println();
  delay(80);
}
