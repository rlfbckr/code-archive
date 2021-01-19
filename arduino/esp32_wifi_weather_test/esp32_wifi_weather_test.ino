#include <WiFi.h>
#include <WiFiMulti.h>
#include <ArduinoJson.h>

#define USE_DISPLAY
#ifdef USE_DISPLAY
#include <U8x8lib.h>
#endif

String apiKey = "5aa90cdbed5ef7be8425759d1c11eca1";
//the city you want the weather for
String location = "Bremen,DE";
int status = WL_IDLE_STATUS;
char server[] = "api.openweathermap.org";
#ifdef USE_DISPLAY
// the OLED used
U8X8_SSD1306_128X64_NONAME_SW_I2C u8x8(/* clock=*/ 15, /* data=*/ 4, /* reset=*/ 16);
#endif
String temp;
WiFiMulti WiFiMulti;

void setup() {
  Serial.begin(115200);
  delay(10);

  // We start by connecting to a WiFi network
  // WiFiMulti.addAP("nodata", "Kuechenlappen");

  WiFiMulti.addAP("virus.exe", "wurst.com");
#ifdef USE_DISPLAY
  u8x8.begin();
  u8x8.setFont(u8x8_font_chroma48medium8_r);
  u8x8.drawString(0, 0, "Hello World!");
#endif
  Serial.println();
  Serial.println();
  Serial.print("Waiting for WiFi... ");

  while (WiFiMulti.run() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

//delay(500);
  u8x8.clear();

}


void loop() {
#ifdef USE_DISPLAY
  u8x8.setCursor(0, 0);
  u8x8.print("Temp = ");
  u8x8.print(temp);
#endif

  //    const uint16_t port = 80;
  //    const char * host = "192.168.1.1"; // ip or dns
  const uint16_t port = 80;
  //    const char * host = "api.openweathermap.org"; // ip or dns
  const char * host = "api.openweathermap.org"; // ip or dns

  Serial.print("Connecting to ");
  Serial.println(host);

  // Use WiFiClient class to create TCP connections
  WiFiClient client;

  if (!client.connect(host, port)) {
    Serial.println("Connection failed.");
    Serial.println("Waiting 5 seconds before retrying...");
    delay(5000);
    return;
  }

  client.print("GET /data/2.5/forecast?");
  client.print("q=" + location);
  client.print("&appid=" + apiKey);
  client.print("&cnt=3");
  client.println("&units=metric");
  client.println("Host: api.openweathermap.org");
  client.println("Connection: close");
  client.println();




  int maxloops = 0;

  //wait for the server's reply to become available
  while (!client.available() && maxloops < 1000)
  {
    maxloops++;
    delay(1); //delay 1 msec
  }
  if (client.available() > 0)
  {
    //read back one line from the server
    String line = client.readStringUntil('\r');
    Serial.println(line);
    StaticJsonDocument<5000> doc;
    auto error = deserializeJson(doc, line);
    if (error) {
      Serial.print(F("deserializeJson() failed with code "));
      Serial.println(error.c_str());
      return;
    } else {
      Serial.println("Parsing OK");
      //get the data from the json tree

      String tempc =  doc["list"][0]["main"]["temp"];
      temp = String(tempc);

      Serial.print("temp : ");
      Serial.println(temp);
    }


  } else {
    Serial.println("client.available() timed out ");
  }

  Serial.println("Closing connection.");
  client.stop();

  Serial.println("Waiting 20 seconds before restarting...");
  delay(30000);
}
