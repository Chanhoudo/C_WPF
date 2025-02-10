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
    String command = Serial.readStringUntil('\n');

    if (command.startsWith("WRITE")) {
      parseAndSaveSettings(command);
      
    } else if (command.startsWith("READ_SETTINGS")) {
      sendSettings();
    } else if (command.startsWith("TEST_DEBUG")){
      testDebug();
    }
    
  }
}

void loadSettingsFromEEPROM() {
  EEPROM.get(0, deviceSettings);
}

void saveSettingsToEEPROM() {
  EEPROM.update(0, deviceSettings);
  Serial.println("Settings saved!");
}

void parseAndSaveSettings(String command) {
  int macIndex = command.indexOf("MAC=") + 4;
  int ipIndex = command.indexOf("IP=");
  int subnetIndex = command.indexOf("Subnet=");
  int gatewayIndex = command.indexOf("Gateway=");
  int dnsIndex = command.indexOf("DNS=");
  int serverIpIndex = command.indexOf("ServerIP=");
  int protocolIndex = command.indexOf("Protocol=");
  int portIndex = command.indexOf("Port=");

  if (macIndex < 4 || ipIndex < 0 || subnetIndex < 0 || gatewayIndex < 0 || dnsIndex < 0 || serverIpIndex < 0 || protocolIndex < 0 || portIndex < 0) {
    Serial.println("잘못된 명령 형식입니다.");
    return;
  }

  command.substring(macIndex, ipIndex - 1).toCharArray(deviceSettings.mac, ipIndex - macIndex);
  command.substring(ipIndex + 3, subnetIndex - 1).toCharArray(deviceSettings.ip, subnetIndex - ipIndex - 3);
  command.substring(subnetIndex + 7, gatewayIndex - 1).toCharArray(deviceSettings.subnet, gatewayIndex - subnetIndex - 7);
  command.substring(gatewayIndex + 8, dnsIndex - 1).toCharArray(deviceSettings.gateway, dnsIndex - gatewayIndex - 8);
  command.substring(dnsIndex + 4, serverIpIndex - 1).toCharArray(deviceSettings.dns, serverIpIndex - dnsIndex - 4);
  command.substring(serverIpIndex + 9, protocolIndex - 1).toCharArray(deviceSettings.serverIp, protocolIndex - serverIpIndex - 9);
  command.substring(protocolIndex + 9, portIndex - 1).toCharArray(deviceSettings.protocol, portIndex - protocolIndex - 9);
  deviceSettings.port = command.substring(portIndex + 5).toInt();

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

void testDebug(){
  Settings test;
  EEPROM.get(0, test);

  Serial.print("TEST: MAC=");
  Serial.print(test.mac);
  Serial.print(";IP=");
  Serial.print(test.ip);
  Serial.print(";Subnet=");
  Serial.print(test.subnet);
  Serial.print(";Gateway=");
  Serial.print(test.gateway);
  Serial.print(";DNS=");
  Serial.print(test.dns);
  Serial.print(";ServerIP=");
  Serial.print(test.serverIp);
  Serial.print(";Protocol=");
  Serial.print(test.protocol);
  Serial.print(";Port=");
  Serial.println(test.port);
}