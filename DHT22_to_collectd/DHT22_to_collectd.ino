#include <DHT.h>


#define DHTPIN 11
#define DHTTYPE DHT22
String nodeid = "GARAGE";

DHT dht(DHTPIN, DHTTYPE);
int errors=0;

void setup() {
  Serial.begin(115200); 
  dht.begin();
}

void loop() {
  // Reading temperature or humidity takes about 250 milliseconds!
  // Sensor readings may also be up to 2 seconds 'old' (its a very slow sensor)
  float h = dht.readHumidity();
  float t = dht.readTemperature();

  // check if returns are valid, if they are NaN (not a number) then something went wrong!
  if (isnan(t) || isnan(h)) {
//    Serial.println("Failed to read from DHT");
    errors = 1;
  } else {
    // We want json output, easier to parse later
//    { "sensor_name": "foo", "temp_c": 50, "temp_f": 80 }
    float temp_f = t * 1.8 + 32;
    Serial.print(" \{ \"sensor_name\": \"");
    Serial.print(nodeid);
    Serial.print("\", \"humidity\": ");
    Serial.print(h);
    Serial.print(", \"celsius\":");
    Serial.print(t);
    Serial.println("}");
  }
  delay(5000);
}
