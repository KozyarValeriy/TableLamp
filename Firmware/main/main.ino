/*
   Управление
  - (1, n{0...255})               - заливка цветом
  - (2, 1)                        - радуга
  - (2, 2, FIRE_PALETTE{0...3})   - огонь (4 режима)
  - (2, 3, FIRE{0...2})           - огонек (обычный, цветной, радужный) 
  - (2, 4)                        - светлячки
  - (2, 5)                        - смена цветов
  - (2, 6)                        - конфети
  - (2, 7)                        - залить белым
  - (3, Timer{5...245})           - Установка таймера
  - (9)                           - вкл/выкл
  - (0, brightness{0...255})      - изменение яркости
*/

#include <EEPROMex.h>       // Библиотека для сохранения

#define NUM_LEDS 10         // Кол-во светодиодов в отрезке ленты
#define LED_PIN 6           // Пин ленты
#define KEEP_SETTINGS 1     // хранить ВСЕ настройки в памяти
#define CURRENT_LIMIT 2000  // лимит по току в миллиамперах, автоматически управляет яркостью
#define NUM_STRIPS 4        // количество отрезков ленты (в параллели)

bool gReverseDirection = false;
boolean powerDirection = true;
boolean loadingFlag = true;

#include <FastLED.h>
CRGBPalette16 gPal;
CRGB leds[NUM_LEDS];

int n = 125, buf;
int Timer = 20;               // скорость семны режимов в мс
unsigned long last_time;
byte brightness = 50, second_mode = 1, main_mode = 2;
byte FIRE_PALETTE = 0;        // Выбор типа пламени
byte FIRE = 0;                // Выбор типа огонька

void setup() {
    FastLED.addLeds<WS2811, LED_PIN, GRB>(leds, NUM_LEDS);
    FastLED.setBrightness(brightness);
    modes();
    Serial.begin(9600);
    // Ограничение по току
    if (CURRENT_LIMIT > 0) FastLED.setMaxPowerInVoltsAndMilliamps(5, CURRENT_LIMIT / NUM_STRIPS);
    // в 100 ячейке хранится число 100. Если нет - значит это первый запуск системы
    if (KEEP_SETTINGS) {
        if (EEPROM.read(100) != 100) {
            EEPROM.write(100, 100);
            updateEEPROM();
        } else {
            readEEPROM();
        }
    }

}

void loop() { 
    bluetooth();      
    modes();    
}

void modes() {
    if (millis() - last_time >= Timer) {
        last_time = millis();
        if (main_mode == 1)
            colors(); 
        else if (main_mode == 2) {
            switch (second_mode) {
                case 1: rainbow();            
                    break;
                case 2: fire();     
                    break;
                case 3: lighter();     
                    break;
                case 4: lightBugs();     
                    break;
                case 5: colors_change();     
                    break;
                case 6: sparkles();     
                    break;
                case 7: fillAll(CRGB::White);   
                    break;            
            }  
        }
    }
    FastLED.show();
}

void bluetooth() {
    if (Serial.available()) {  
        buf = Serial.read() - '0';
        if (buf < 10 and buf >= 0) {     
            if (buf == 1) {
                n = Serial.parseInt();
                main_mode = buf;
            } else if (buf == 2) {
                delay(5);
                second_mode = Serial.read() - '0';
                    if (second_mode == 2) {
                        delay(5);
                        FIRE_PALETTE = Serial.read() - '0';
                        if (FIRE_PALETTE == 0) gPal = HeatColors_p;
                        else if (FIRE_PALETTE == 1) gPal = CRGBPalette16( CRGB::Black, CRGB::Red, CRGB::Yellow, CRGB::White);
                        else if (FIRE_PALETTE == 2) gPal = CRGBPalette16( CRGB::Black, CRGB::Blue, CRGB::Aqua,  CRGB::White);
                        else gPal = CRGBPalette16( CRGB::Black, CRGB::Red, CRGB::White);                             
                    } else if (second_mode == 3) {
                        delay(5);
                        FIRE = Serial.read() - '0'; 
                    }              
                main_mode = buf; 
            } else if (buf == 3) {
                Timer = Serial.parseInt();
            } else if (buf == 0) {
                brightness = Serial.parseInt(); 
            } else if (buf == 9) {
                powerDirection = !powerDirection;    
            }
            FastLED.clear();
        }       
        FastLED.setBrightness(brightness * powerDirection);
        updateEEPROM();
    }  
} 

void updateEEPROM() {
    EEPROM.updateByte(1, main_mode);
    EEPROM.updateByte(2, second_mode);
    EEPROM.updateByte(3, brightness);
    EEPROM.updateByte(4, FIRE_PALETTE);
    EEPROM.updateByte(5, FIRE);
    EEPROM.updateInt(6, n);
    EEPROM.updateInt(10, Timer);
}
void readEEPROM() {
    main_mode = EEPROM.readByte(1);
    second_mode = EEPROM.readByte(2);
    brightness = EEPROM.readByte(3);
    FIRE_PALETTE = EEPROM.readByte(4);
    FIRE = EEPROM.readByte(5);
    n = EEPROM.readByte(6);
    Timer = EEPROM.readByte(10);
}

