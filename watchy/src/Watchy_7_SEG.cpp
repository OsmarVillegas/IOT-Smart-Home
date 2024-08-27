#include "Watchy_7_SEG.h"
#include <PubSubClient.h>
#include <WiFi.h>

const char* mqtt_server = "broker.emqx.io";
const int mqtt_port = 1883;
const char* mqtt_user = "";
const char* mqtt_password = "";


const char* ssid = lastSSID;
const char* password = lastPASS;

WiFiClient espClient;
PubSubClient client(espClient);

#define DARKMODE true

const uint8_t BATTERY_SEGMENT_WIDTH = 7;
const uint8_t BATTERY_SEGMENT_HEIGHT = 11;
const uint8_t BATTERY_SEGMENT_SPACING = 9;
const uint8_t WEATHER_ICON_WIDTH = 48;
const uint8_t WEATHER_ICON_HEIGHT = 32;

void Watchy7SEG::drawWatchFace(){
    display.fillScreen(DARKMODE ? GxEPD_BLACK : GxEPD_WHITE);
    display.setTextColor(DARKMODE ? GxEPD_WHITE : GxEPD_BLACK);
    drawTime();
    drawDate();
    drawSteps();
    drawWeather();
    drawBattery();
    connectMQTT();
    display.drawBitmap(116, 75, WIFI_CONFIGURED ? wifi : wifioff, 26, 18, DARKMODE ? GxEPD_WHITE : GxEPD_BLACK);
    if(BLE_CONFIGURED){
        display.drawBitmap(100, 73, bluetooth, 13, 21, DARKMODE ? GxEPD_WHITE : GxEPD_BLACK);
    }
    #ifdef ARDUINO_ESP32S3_DEV
    if(USB_PLUGGED_IN){
      display.drawBitmap(140, 75, charge, 16, 18, DARKMODE ? GxEPD_WHITE : GxEPD_BLACK);
    }
    #endif
}

void Watchy7SEG::drawTime(){
    display.setFont(&DSEG7_Classic_Bold_53);
    display.setCursor(5, 53+5);
    int displayHour;
    if(HOUR_12_24==12){
      displayHour = ((currentTime.Hour+11)%12)+1;
    } else {
      displayHour = currentTime.Hour;
    }
    if(displayHour < 10){
        display.print("0");
    }
    display.print(displayHour);
    display.print(":");
    if(currentTime.Minute < 10){
        display.print("0");
    }
    display.println(currentTime.Minute);
}

void Watchy7SEG::drawDate(){
    display.setFont(&Seven_Segment10pt7b);

    int16_t  x1, y1;
    uint16_t w, h;

    String dayOfWeek = dayStr(currentTime.Wday);
    display.getTextBounds(dayOfWeek, 5, 85, &x1, &y1, &w, &h);
    if(currentTime.Wday == 4){
        w = w - 5;
    }
    display.setCursor(85 - w, 85);
    display.println(dayOfWeek);

    String month = monthShortStr(currentTime.Month);
    display.getTextBounds(month, 60, 110, &x1, &y1, &w, &h);
    display.setCursor(85 - w, 110);
    display.println(month);

    display.setFont(&DSEG7_Classic_Bold_25);
    display.setCursor(5, 120);
    if(currentTime.Day < 10){
    display.print("0");
    }
    display.println(currentTime.Day);
    display.setCursor(5, 150);
    display.println(tmYearToCalendar(currentTime.Year));// offset from 1970, since year is stored in uint8_t
}

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Mensaje recibido en topic: ");
  Serial.println(topic);
  Serial.print("Mensaje: ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();
}

void Watchy7SEG::drawSteps(){
    // reset step counter at midnight
    if (currentTime.Hour == 0 && currentTime.Minute == 0){
      sensor.resetStepCounter();
    }
    uint32_t stepCount = sensor.getCounter();

    display.drawBitmap(10, 165, steps, 19, 23, DARKMODE ? GxEPD_WHITE : GxEPD_BLACK);
    display.setCursor(35, 190);
    display.println(stepCount);
}
void Watchy7SEG::drawBattery(){
    //connectMQTT();
    display.drawBitmap(158, 73, battery, 37, 21, DARKMODE ? GxEPD_WHITE : GxEPD_BLACK);
    display.fillRect(163, 78, 27, BATTERY_SEGMENT_HEIGHT, DARKMODE ? GxEPD_BLACK : GxEPD_WHITE);//clear battery segments
    int8_t batteryLevel = 0;
    float VBAT = getBatteryVoltage();

    if(VBAT > 4.0){
        batteryLevel = 3;
    }
    else if(VBAT > 3.6 && VBAT <= 4.0){
        batteryLevel = 2;
    }
    else if(VBAT > 3.20 && VBAT <= 3.6){
        batteryLevel = 1;
    }
    else if(VBAT <= 3.20){
        batteryLevel = 0;
    }

    for(int8_t batterySegments = 0; batterySegments < batteryLevel; batterySegments++){
        display.fillRect(163 + (batterySegments * BATTERY_SEGMENT_SPACING), 78, BATTERY_SEGMENT_WIDTH, BATTERY_SEGMENT_HEIGHT, DARKMODE ? GxEPD_WHITE : GxEPD_BLACK);
    }
}

void Watchy7SEG::drawWeather(){
    weatherData currentWeather = getWeatherData();

    int8_t temperature = currentWeather.temperature;
    int16_t weatherConditionCode = currentWeather.weatherConditionCode;

    display.setFont(&DSEG7_Classic_Regular_39);
    int16_t  x1, y1;
    uint16_t w, h;
    display.getTextBounds(String(temperature), 0, 0, &x1, &y1, &w, &h);
    if(159 - w - x1 > 87){
        display.setCursor(159 - w - x1, 150);
    }else{
        display.setFont(&DSEG7_Classic_Bold_25);
        display.getTextBounds(String(temperature), 0, 0, &x1, &y1, &w, &h);
        display.setCursor(159 - w - x1, 136);
    }
    display.println(temperature);
    display.drawBitmap(165, 110, currentWeather.isMetric ? celsius : fahrenheit, 26, 20, DARKMODE ? GxEPD_WHITE : GxEPD_BLACK);
    const unsigned char* weatherIcon;

    if(WIFI_CONFIGURED){
      //https://openweathermap.org/weather-conditions
      if(weatherConditionCode > 801){//Cloudy
        weatherIcon = cloudy;
      }else if(weatherConditionCode == 801){//Few Clouds
        weatherIcon = cloudsun;
      }else if(weatherConditionCode == 800){//Clear
        weatherIcon = sunny;
      }else if(weatherConditionCode >=700){//Atmosphere
        weatherIcon = atmosphere;
      }else if(weatherConditionCode >=600){//Snow
        weatherIcon = snow;
      }else if(weatherConditionCode >=500){//Rain
        weatherIcon = rain;
      }else if(weatherConditionCode >=300){//Drizzle
        weatherIcon = drizzle;
      }else if(weatherConditionCode >=200){//Thunderstorm
        weatherIcon = thunderstorm;
      }else 
      return;
    }else{
      weatherIcon = chip;
    }
    
    display.drawBitmap(145, 158, weatherIcon, WEATHER_ICON_WIDTH, WEATHER_ICON_HEIGHT, DARKMODE ? GxEPD_WHITE : GxEPD_BLACK);
}

void Watchy7SEG::connectMQTT(){
  weatherData currentWeather = getWeatherData();

  int8_t temperature = currentWeather.temperature;
  int16_t weatherConditionCode = currentWeather.weatherConditionCode;

  char bufferTemp[16];    // Buffer para almacenar la cadena resultante
  // Convertir int8_t a const char*
  itoa(temperature, bufferTemp, 10);  // Convertir el número a una cadena en base 10
  const char* temp = bufferTemp;  // Convertir el buffer a const char*

  uint32_t stepCount = sensor.getCounter();
  char bufferStep[16];    // Buffer para almacenar la cadena resultante
  // Convertir int8_t a const char*
  itoa(stepCount, bufferStep, 10);  // Convertir el número a una cadena en base 10
  const char* stepC = bufferStep;  // Convertir el buffer a const char*

  float VBAT = getBatteryVoltage();

  char bufferBVP[20];  // Buffer para almacenar la cadena resultante
  // Convertir float a const char*

  float BVP = 0.0;

  if (VBAT > 4.0) {
    BVP = 100.0;
  } else if (VBAT > 3.6 && VBAT <= 4.0) {
    BVP = ((VBAT - 3.6) / (4.0 - 3.6)) * 50.0 + 50.0;
  } else if (VBAT > 3.20 && VBAT <= 3.6) {
    BVP = ((VBAT - 3.20) / (3.6 - 3.20)) * 50.0;
  } else {
    BVP = 0.0;
  }

  dtostrf(BVP, 6, 2, bufferBVP);  // Convertir el número flotante a una cadena
  const char* bvpLevel = bufferBVP; // Convertir el buffer a const char*



  if(WIFI_CONFIGURED && WiFi.status() != WL_CONNECTED){
      WiFi.begin(ssid, password);
      Serial.print("Conectando a la red Wi-Fi");
      
      int attempts = 0;
      while (WiFi.status() != WL_CONNECTED && attempts < 20) {
        delay(500);
        Serial.print(".");
        attempts++;
      }

      if (WiFi.status() == WL_CONNECTED) {
        Serial.println("\nConectado a la red Wi-Fi");
        Serial.print("IP: ");
        Serial.println(WiFi.localIP());
        client.setServer(mqtt_server, mqtt_port);
      } else {
        Serial.println("\nNo se pudo conectar a la red Wi-Fi");
      }
      
      while (!client.connected()) {
        if (client.connect("WatchyClient")) {
          Serial.println("Conectado al broker MQTT");
        } else if(WiFi.status() != WL_CONNECTED) {
          Serial.println("No estas conectado a una red Wi-Fi");
          break;
        } else {
          delay(1000);
        }
      }
    }
    disconnectMQTT();

    while (!client.connected()) {
      if (client.connect("WatchyClient")) {
        Serial.println("Conectado al broker MQTT");
      } else if(WiFi.status() != WL_CONNECTED) {
        Serial.println("No estas conectado a una red Wi-Fi");
        break;
      } else {
        delay(1000);
      }
    }
    

    if(client.connected()) {
      client.publish("wearable/paso/data", stepC, true);
    }

    disconnectMQTT();

    while (!client.connected()) {
      if (client.connect("WatchyClient")) {
        Serial.println("Conectado al broker MQTT");
      } else if(WiFi.status() != WL_CONNECTED) {
        Serial.println("No estas conectado a una red Wi-Fi");
        break;
      } else {
        delay(1000);
      }
    }

    if(client.connected()) {
      client.publish("wearable/batteria/data", bvpLevel, true);
    }

    disconnectMQTT();

    while (!client.connected()) {
      if (client.connect("WatchyClient")) {
        Serial.println("Conectado al broker MQTT");
        if(WIFI_CONFIGURED){
          //https://openweathermap.org/weather-conditions
          if(weatherConditionCode > 801){//Cloudy
            client.publish("wearable/clima/data", "Cloudy", true);
          }else if(weatherConditionCode == 801){//Few Clouds
            client.publish("wearable/clima/data", "Few Clouds", true);
          }else if(weatherConditionCode == 800){//Clear
            client.publish("wearable/clima/data", "Clear", true);
          }else if(weatherConditionCode >=700){//Atmosphere
            client.publish("wearable/clima/data", "Atmosphere", true);
          }else if(weatherConditionCode >=600){//Snow
            client.publish("wearable/clima/data", "Snow", true);
          }else if(weatherConditionCode >=500){//Rain
            client.publish("wearable/clima/data", "Rain", true);
          }else if(weatherConditionCode >=300){//Drizzle
            client.publish("wearable/clima/data", "Drizzle", true);
          }else if(weatherConditionCode >=200){//Thunderstorm
            client.publish("wearable/clima/data", "Thunderstorm", true);
          }
        }
      } else if(WiFi.status() != WL_CONNECTED) {
        Serial.println("No estas conectado a una red Wi-Fi");
        break;
      } else {
        delay(1000);
      }
    }

    disconnectMQTT();

    while (!client.connected()) {
      if (client.connect("WatchyClient")) {
        Serial.println("Conectado al broker MQTT");
      } else if(WiFi.status() != WL_CONNECTED) {
        Serial.println("No estas conectado a una red Wi-Fi");
        break;
      } else {
        delay(1000);
      }
    }

    if(client.connected()) {
      client.publish("wearable/temperatura/data", temp, true);
    }

    disconnectMQTT();
}

void Watchy7SEG::disconnectMQTT(){
  if(client.connected()) {
    client.disconnect();
    while(client.connected()){
    }
    Serial.println("Desconectado el broker MQTT");
  }
}