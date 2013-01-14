// Example testing sketch for various DHT humidity/temperature sensors
// Written by ladyada, public domain

#include "DHT.h"

#define DHTPIN 11     // what pin we're connected to
#define DHTTYPE DHT22 // DHT 22  (AM2302)
String nodeid = "RED";

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(115200); 
  dht.begin();
}

void loop() {
  // Reading temperature or humidity takes about 250 milliseconds!
  // Sensor readings may also be up to 2 seconds 'old' (its a very slow sensor)
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  int foo;

  // check if returns are valid, if they are NaN (not a number) then something went wrong!
  if (isnan(t) || isnan(h)) {
    // Serial.println("Failed to read from DHT");
  } 
  else {
    Serial.print(nodeid);
    Serial.print(" ");
    Serial.print(h);
    Serial.print(" ");
    Serial.print(t);
    Serial.print("\r\n");
  }
  delay(100); 
}



