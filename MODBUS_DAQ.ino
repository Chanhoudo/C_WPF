#include <EEPROM.h>
#include <Arduino.h>
#include "pico/stdlib.h"
#include "hardware/timer.h"

// Modbus 기본 설정
constexpr unsigned char SLAVE_ADDRESS = 0x01;
constexpr unsigned char FUNCTION_CODE = 0x03;
constexpr uint16_t REGISTER_START = 0x0100;
constexpr unsigned char REGISTER_COUNT = 4;
constexpr unsigned char RESPONSE_MAX_LEN = 32;
constexpr unsigned char RECEIVED_DATA_BYTE = 8;

// 저장 공간
constexpr int MAX_STORAGE_SIZE = 600;  // 5분 저장 (0.5초 간격 x 600)
constexpr int MAX_AVG_STORAGE_SIZE = 6; // 30분 저장 (5분 평균 x 6)

// 데이터 저장 공간
unsigned char dataStorage[MAX_STORAGE_SIZE][RECEIVED_DATA_BYTE]; 
unsigned char avgStorage[MAX_AVG_STORAGE_SIZE][RECEIVED_DATA_BYTE];

int dataIndex = 0;  // 현재 데이터 개수
int avgIndex = 0;   // 5분 평균 저장 개수

volatile bool requestFlag = false;
volatile bool avgCalcFlag = false;  // 평균 계산 플래그

repeating_timer_t modbusTimer;  // 0.5초마다 Modbus 요청
repeating_timer_t modbusAvgTimer;  // 5분마다 평균 계산

// 0.5초마다 실행 (Modbus 요청)
bool requestModbusData(repeating_timer_t *t) {
    requestFlag = true;
    return true;
}

// 5분마다 실행 (평균 계산)
bool calculateFiveMinAverageTimer(repeating_timer_t *t) {
    avgCalcFlag = true;
    return true;
}

void setup() {
    Serial.begin(115200);
    Serial1.begin(9600, SERIAL_8N1);
    Serial.println("Modbus Master - Auto Request Every 0.5s");

    // 0.5초마다 Modbus 데이터 요청
    add_repeating_timer_ms(500, requestModbusData, NULL, &modbusTimer);

    // 5분(300,000ms)마다 평균 계산
    add_repeating_timer_ms(300000, calculateFiveMinAverageTimer, NULL, &modbusAvgTimer);
}

void loop() {
    if (requestFlag) {
        requestFlag = false;
        sendModbusRequest();
        receiveModbusResponse();
    }

    if (avgCalcFlag) {
        avgCalcFlag = false;
        calculateFiveMinAverage();
    }
}

// ✅ Modbus 요청 패킷 생성 및 전송
void sendModbusRequest() {
    unsigned char request[8] = {
        SLAVE_ADDRESS, FUNCTION_CODE,
        (REGISTER_START >> 8) & 0xFF, REGISTER_START & 0xFF,
        (REGISTER_COUNT >> 8) & 0xFF, REGISTER_COUNT & 0xFF
    };

    uint16_t crc = calculateCRC(request, 6);
    request[6] = crc & 0xFF;
    request[7] = (crc >> 8) & 0xFF;

    Serial.print("🚀 Send Data: ");
    printHex(request, 8);

    for (int i = 0; i < 8; i++) {
        Serial1.write(request[i]);
    }
}

// ✅ Modbus 응답 패킷 수신 및 저장
void receiveModbusResponse() {
    unsigned char response[RESPONSE_MAX_LEN] = {0};
    int index = 0;
    unsigned long startTime = millis();

    while (millis() - startTime < 500) {
        if (Serial1.available()) {
            unsigned char byteReceived = Serial1.read();
            response[index++] = byteReceived;

            // 응답 길이 초과 방지
            if (index >= RESPONSE_MAX_LEN) {
                Serial.println("❌ Response Overflow! Clearing Buffer.");
                return;
            }

            // 올바른 패킷인지 검증
            if (index == 4 && (response[0] != SLAVE_ADDRESS || response[1] != FUNCTION_CODE || response[2] != RECEIVED_DATA_BYTE || response[3] != 0x33)) {
                Serial.println("❌ Invalid Start Sequence! Discarding Response...");
                index = -10;
                continue;
            }

            // 예상 길이 도달하면 중단
            if (index >= 5 && index >= response[2] + 5) break;
        }
    }

    // CRC 검증
    if (!validateModbusResponse(response, index)) {
        Serial.println("CRC Error: Response Invalid!");
        return;
    }

    Serial.print("✅ Check Ok! 📦 Received Data: ");
    printHex(response, index);

    // 8바이트 데이터 저장
    if (dataIndex < MAX_STORAGE_SIZE) {
        memcpy(dataStorage[dataIndex], response + 3, RECEIVED_DATA_BYTE);
        dataIndex++;
    }
}

// ✅ 5분 단위 평균 계산
void calculateFiveMinAverage() {
    Serial.println("📊 Calculating 5-Minute Average...");

    if (dataIndex == 0) {
        Serial.println("⚠️ No data to average!");
        return;
    }

    unsigned char tempAverage[RECEIVED_DATA_BYTE] = {0};

    // 모든 데이터를 더함
    for (int i = 0; i < dataIndex; i++) {
        for (int j = 0; j < RECEIVED_DATA_BYTE; j++) {
            tempAverage[j] += dataStorage[i][j];
        }
    }

    // 데이터 개수만큼 나누어 평균 계산
    for (int j = 0; j < RECEIVED_DATA_BYTE; j++) {
        tempAverage[j] /= dataIndex;
    }

    // 5분 평균 저장
    if (avgIndex < MAX_AVG_STORAGE_SIZE) {
        memcpy(avgStorage[avgIndex], tempAverage, RECEIVED_DATA_BYTE);
        avgIndex++;
    }

    Serial.print("✅ 5-Minute Average: ");
    printHex(tempAverage, RECEIVED_DATA_BYTE);

    // 5분 데이터 초기화
    dataIndex = 0;

    // 30분 평균 계산
    if (avgIndex >= MAX_AVG_STORAGE_SIZE) {
        calculateThirtyMinAverage();
        avgIndex = 0;
    }
}

// ✅ 30분 단위 평균 계산
void calculateThirtyMinAverage() {
    Serial.println("📊 Calculating 30-Minute Average...");

    if (avgIndex == 0) {
        Serial.println("⚠️ No 5-Min averages to process!");
        return;
    }

    unsigned char thirtyMinAverage[RECEIVED_DATA_BYTE] = {0};

    for (int i = 0; i < avgIndex; i++) {
        for (int j = 0; j < RECEIVED_DATA_BYTE; j++) {
            thirtyMinAverage[j] += avgStorage[i][j];
        }
    }

    for (int j = 0; j < RECEIVED_DATA_BYTE; j++) {
        thirtyMinAverage[j] /= avgIndex;
    }

    Serial.print("✅ 30-Minute Average: ");
    printHex(thirtyMinAverage, RECEIVED_DATA_BYTE);
}

// ✅ Modbus 응답 검증 (CRC 체크)
bool validateModbusResponse(unsigned char *response, int length) {
    if (length < 5) return false;

    uint16_t receivedCRC = (response[length - 1] << 8) | response[length - 2];
    uint16_t calculatedCRC = calculateCRC(response, length - 2);

    Serial.print("🔍 CRC Check: Received = 0x");
    Serial.print(receivedCRC, HEX);
    Serial.print(", Calculated = 0x");
    Serial.println(calculatedCRC, HEX);

    return receivedCRC == calculatedCRC;
}

// ✅ Modbus CRC 계산
uint16_t calculateCRC(unsigned char *data, unsigned char length) {
    uint16_t crc = 0xFFFF;
    for (unsigned char i = 0; i < length; i++) {
        crc ^= data[i];
        for (unsigned char j = 0; j < 8; j++)
            crc = (crc & 1) ? (crc >> 1) ^ 0xA001 : crc >> 1;
    }
    return crc;
}

// ✅ 데이터 출력 함수 (HEX 형식)
void printHex(unsigned char *data, int length) {
    for (int i = 0; i < length; i++) {
        Serial.print("0x");
        if (data[i] < 0x10) Serial.print("0");
        Serial.print(data[i], HEX);
        Serial.print(" ");
    }
    Serial.println();
}
