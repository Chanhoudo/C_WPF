#include <EEPROM.h>

struct Settings {
  char mac[18];
  char ip[16];
  char subnet[16];
  char gateway[16];
  char dns[16];
  char serverIp[16];
  char protocol[4];
  int port;
};

Settings deviceSettings;

void setup() {
  Serial.begin(115200);
  loadSettingsFromEEPROM();
}

void loop() {
  if (Serial.available()) {
    String command = Serial.readStringUntil('\n');  // 줄바꿈을 기준으로 시리얼 포트에서 읽어오기

    if (command.startsWith("WRITE")) {
      parseAndSaveSettings(command);                //명령을 파싱하고 저장
      Serial.println("Settings saved!");
    } else if (command.startsWith("READ_SETTINGS")) {
      sendSettings();
    }
  }
}

void loadSettingsFromEEPROM() {
  EEPROM.get(0, deviceSettings);
}

void saveSettingsToEEPROM() {
  EEPROM.put(0, deviceSettings);
}

void parseAndSaveSettings(String command) {
  int macIndex = command.indexOf("MAC=") + 4;
  int ipIndex = command.indexOf("IP=") + 3;
  int subnetIndex = command.indexOf("Subnet=") + 7;
  int gatewayIndex = command.indexOf("Gateway=") + 8;
  int dnsIndex = command.indexOf("DNS=") + 4;
  int serverIpIndex = command.indexOf("ServerIP=") + 9;
  int protocolIndex = command.indexOf("Protocol=") + 9;
  int portIndex = command.indexOf("Port=") + 5;

  command.substring(macIndex, macIndex + 17).toCharArray(deviceSettings.mac, 18);
  command.substring(ipIndex, ipIndex + 15).toCharArray(deviceSettings.ip, 16);
  command.substring(subnetIndex, subnetIndex + 15).toCharArray(deviceSettings.subnet, 16);
  command.substring(gatewayIndex, gatewayIndex + 15).toCharArray(deviceSettings.gateway, 16);
  command.substring(dnsIndex, dnsIndex + 15).toCharArray(deviceSettings.dns, 16);
  command.substring(serverIpIndex, serverIpIndex + 15).toCharArray(deviceSettings.serverIp, 16);
  command.substring(protocolIndex, protocolIndex + 3).toCharArray(deviceSettings.protocol, 4);
  deviceSettings.port = command.substring(portIndex).toInt();

  saveSettingsToEEPROM();
}

void sendSettings() {
  Serial.print("MAC=");
  Serial.print(deviceSettings.mac);
  Serial.print(";IP=");
  Serial.print(deviceSettings.ip);
  Serial.print(";Subnet=");
  Serial.print(deviceSettings.subnet);
  Serial.print(";Gateway=");
  Serial.print(deviceSettings.gateway);
  Serial.print(";DNS=");
  Serial.print(deviceSettings.dns);
  Serial.print(";ServerIP=");
  Serial.print(deviceSettings.serverIp);
  Serial.print(";Protocol=");
  Serial.print(deviceSettings.protocol);
  Serial.print(";Port=");
  Serial.println(deviceSettings.port);
}
