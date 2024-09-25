#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <WiFi.h>
#include <FirebaseESP32.h>
#include <TimeLib.h>
#include <WiFiUdp.h>

// Wi-Fi credentials
const char* ssid = "AdjiDjatiDimar"; // replace with your Wi-Fi SSID
const char* password = "OnMgs511"; // replace with your Wi-Fi password

// Firebase Realtime Database
const char* firebaseHost = "up2btangki-default-rtdb.asia-southeast1.firebasedatabase.app"; // Firebase host without "https://"
const char* firebaseAuth = "16PpVFU8xxWU0uiy0mUfQWXIwr51BLt0UySuIpMF";

FirebaseData firebaseData;
FirebaseConfig firebaseConfig;
FirebaseAuth auth;

LiquidCrystal_I2C lcd(0x27, 16, 2);

#define echoPin 12 // Pin Echo
#define trigPin 13 // Pin Trigger

long duration;
float jarak;

float tinggiWadah = 9.5; // Tinggi wadah (jarak dasar dengan sensor) dalam cm
float lebarWadah = 13; // Lebar wadah dalam cm
float panjangWadah = 16; // Panjang wadah dalam cm
float luasAlaswadah = 208; // Luas alas wadah dalam cm2
float tinggiAir;
float volume;
float volumeLiter;

unsigned long lastFailTime = 0; // Time of the last failed attempt
const unsigned long failDurationLimit = 60000; // 1 minute in milliseconds

float initialVolume = -1;
float finalVolume = -1;

const int timeZone = 7; // Time zone offset for GMT+7

WiFiUDP ntpUDP;

void setup() {
  Serial.begin(115200); // Baudrate komunikasi dengan serial monitor
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  lcd.init();
  lcd.backlight();

  // Connect to Wi-Fi
  connectWiFi();

  // Initialize Firebase
  firebaseConfig.host = firebaseHost;
  firebaseConfig.signer.tokens.legacy_token = firebaseAuth;
  Firebase.begin(&firebaseConfig, &auth);
  Firebase.reconnectWiFi(true);

  // Synchronize time from NTP server
  configTime(timeZone * 3600, 0, "pool.ntp.org");
  if (!syncTime()) {
    Serial.println("Failed to synchronize time with NTP server");
  }
}

void loop() {
  // Update time
  time_t now = time(nullptr);
  struct tm *localTime = localtime(&now);

  // Mengukur jarak dengan sensor ultrasonik
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  jarak = duration * 0.034 / 2; // Konversi ke jarak sebenarnya (cm)

  // Menghitung volume wadah air (disesuaikan dengan karakteristik wadah Anda)
  tinggiAir = tinggiWadah - jarak;
  volume = tinggiAir * luasAlaswadah;
  volumeLiter = volume / 1000.0; // Konversi volume dari ml ke liter

  // Menampilkan hasil di LCD
  lcd.setCursor(0, 0);
  lcd.print("T air:");
  lcd.print(tinggiAir);
  lcd.print(" cm");
  lcd.setCursor(0, 1);
  lcd.print("V air:");
  lcd.print(volumeLiter, 3); // Menampilkan volume dalam liter dengan 3 decimal places
  lcd.print(" L");

  // Upload volume liter ke Firebase
  String path = "/fuelinformation/tankVolume"; // Your desired path in Firebase
  if (Firebase.setFloat(firebaseData, path.c_str(), volumeLiter)) {
    Serial.println("Data uploaded to Firebase");
    lastFailTime = 0; // Reset the fail time on successful upload
  } else {
    Serial.print("Failed to upload data to Firebase: ");
    Serial.println(firebaseData.errorReason());

    if (lastFailTime == 0) {
      lastFailTime = millis(); // Set the time of the first failure
    } else if (millis() - lastFailTime > failDurationLimit) {
      // Reconnect to Wi-Fi if failures exceed the limit
      connectWiFi();
      lastFailTime = 0; // Reset the fail time after reconnection attempt
    }
  }

  // Check for initial and final volume recording times
  int currentHour = localTime->tm_hour;
  int currentMinute = localTime->tm_min;
  int currentSecond = localTime->tm_sec;

  // Extract the date from the current time
  char dateKey[11]; // Buffer to hold the formatted date string
  snprintf(dateKey, sizeof(dateKey), "%04d_%02d_%02d",
           localTime->tm_year + 1900, localTime->tm_mon + 1, localTime->tm_mday);

  // Initialize initialVolume if it hasn't been set yet
  if (initialVolume == -1) {
    initialVolume = volumeLiter;
    String initialPath = "/fuelinformation/zhistory/" + String(dateKey) + "/awal";
    Firebase.setFloat(firebaseData, initialPath, initialVolume);
    Serial.print("Initial Volume set: ");
    Serial.println(initialVolume);
  }

  if (currentHour == 23 && currentMinute == 59 && currentSecond == 59 && finalVolume == -1) {
    finalVolume = volumeLiter;
    String finalPath = "/fuelinformation/zhistory/" + String(dateKey) + "/akhir";
    Firebase.setFloat(firebaseData, finalPath, finalVolume);
    Serial.print("Final Volume at 11:59 PM: ");
    Serial.println(finalVolume);

    // Calculate the difference between initial and final volumes
    float volumeDifference = finalVolume - initialVolume;
    String diffPath = "/fuelinformation/zhistory/" + String(dateKey) + "/konsum";
    Firebase.setFloat(firebaseData, diffPath, volumeDifference);
    Serial.print("Volume Difference: ");
    Serial.println(volumeDifference);

    // Reset initial and final volumes for the next day
    initialVolume = -1;
    finalVolume = -1;
  }

  // Ensure new date key is generated correctly for the next day
  if (currentHour == 0 && currentMinute == 0 && currentSecond == 1) {
    initialVolume = volumeLiter;
    String initialPath = "/fuelinformation/zhistory/" + String(dateKey) + "/awal";
    Firebase.setFloat(firebaseData, initialPath, initialVolume);
    Serial.print("New Day Initial Volume set: ");
    Serial.println(initialVolume);
  }

  delay(3000);
}

void connectWiFi() {
  WiFi.begin(ssid, password);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(1000);
  }
  Serial.println();
  Serial.println("Connected to Wi-Fi");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());
}

bool syncTime() {
  configTime(timeZone * 3600, 0, "pool.ntp.org");
  time_t now = time(nullptr);
  int retry = 0;
  const int retryCount = 10;
  while (now < 8 * 3600 * 2 && retry < retryCount) {
    delay(1000);
    now = time(nullptr);
    retry++;
  }
  if (retry == retryCount) {
    return false;
  }
  setTime(now);
  Serial.println("Time synchronized successfully");
  return true;
}
