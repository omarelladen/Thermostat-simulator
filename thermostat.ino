#include <LiquidCrystal.h>

#include "defines.h"


LiquidCrystal lcd(PIN_LCD_RS, PIN_LCD_EN, PIN_LCD_D4, PIN_LCD_D5, PIN_LCD_D6, PIN_LCD_D7);

bool g_light_is_on = true;

int8_t g_prev_bt_state = BT_NONE;
unsigned long g_bt_delay = 0;

int8_t g_temp_now = 15;
int8_t g_temp_target = 25;

unsigned long g_time_last_regulation = 0;


void printTempTarget()
{
	lcd.setCursor(0, 0);
	lcd.print(F("Tt: "));
		
	lcd.setCursor(4, 0);
	lcd.print(g_temp_target);

	if (g_temp_target < 10)
	{
		lcd.setCursor(5, 0);
		lcd.print(F(" "));
	}
}

void printTempNow()
{
	lcd.setCursor(0, 1);
	lcd.print(F("Tn: "));
	
	lcd.setCursor(4, 1);
	lcd.print(g_temp_now);

	if (g_temp_now < 10)
	{
		lcd.setCursor(5, 1);
		lcd.print(F(" "));
	}
}

void printCooling(int8_t v)
{
	lcd.setCursor(8, 0);
	lcd.print(F("c: "));
	
	lcd.setCursor(11, 0);
	lcd.print(v);
}

void printHeating(int8_t v)
{
	lcd.setCursor(8, 1);
	lcd.print(F("h: "));
	
	lcd.setCursor(11, 1);
	lcd.print(v);
}

void setup()
{
    pinMode(PIN_LCD_LIGHT, INPUT);

    lcd.begin(16, 2);

    printTempNow();
    printTempTarget();
}

void toggleLight()
{
    if (g_light_is_on)
    {
        pinMode(PIN_LCD_LIGHT, OUTPUT);
        digitalWrite(PIN_LCD_LIGHT, LOW);
        g_light_is_on = false;
    }
    else
    {
        pinMode(PIN_LCD_LIGHT, INPUT);
        g_light_is_on = true;
    }
}

void btUp()
{
	if (g_temp_target < TEMP_MAX_TARGET)
	{
		g_temp_target++;
		printTempTarget();
	}
}

void btDown()
{
	if (g_temp_target > TEMP_MIN_TARGET)
	{
		g_temp_target--;
		printTempTarget();
	}
}

void btSelect()
{
	toggleLight();
}

void btReleased(int8_t bt)
{
    if (bt == BT_DOWN)
        btDown();
    else if (bt == BT_UP)
        btUp();
    else if (bt == BT_SELECT)
    	btSelect();
}

int8_t checkButtonPress()
{
    int8_t bt;
    const int16_t bt_analog_value = analogRead(PIN_SHIELD_BTS);

    if (bt_analog_value < RIGHT_THRESHOLD)
        bt = BT_RIGHT;
    else if (bt_analog_value < DOWN_THRESHOLD)
        bt = BT_UP;
    else if (bt_analog_value < UP_THRESHOLD)
        bt = BT_DOWN;
    else if (bt_analog_value < LEFT_THRESHOLD)
        bt = BT_LEFT;
    else if (bt_analog_value < SEL_THRESHOLD)
        bt = BT_SELECT;
    else
        bt = BT_NONE;

    return bt;
}

void handleButtonPress(const int8_t bt)
{
    if ((millis() - g_bt_delay) > DEBOUNCE_TIME)
    {
        if ((bt == BT_NONE) && (g_prev_bt_state != BT_NONE))
        {
            btReleased(g_prev_bt_state);
            g_bt_delay = millis();
        }
    }
    g_prev_bt_state = bt;
}

int8_t passed_regulation_interval()
{
	unsigned long time_now = millis();
	if (time_now - g_time_last_regulation >= REGULATION_INTERVAL)
	{
		g_time_last_regulation = time_now;
		return 1;
	}
	return 0;
}

void loop()
{
    // Increase or decrease target temperature
    const int8_t bt_pressed = checkButtonPress();
	handleButtonPress(bt_pressed);
	
	// Show if is cooling 
    if (g_temp_now >= g_temp_target)
    	printCooling(1);
    else
    	printCooling(0);
    
	// Show if it is heating
    if (g_temp_now <= g_temp_target)
    	printHeating(1);
    else
    	printHeating(0);

	// Regulate temperature
	if (passed_regulation_interval())
	{
		if (g_temp_now < g_temp_target)
	    {
			g_temp_now++;
	    	printTempNow();
	    }
		else if (g_temp_now > g_temp_target)
	    {
	    	g_temp_now--;
	    	printTempNow();
	    }
	}
}
