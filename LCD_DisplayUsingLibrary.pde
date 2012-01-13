#include <LiquidCrystal.h>

//Pins
const int rs = 2;
const int enable = 3;
const int d0 = 4;
const int d1 = 5;
const int d2 = 6;
const int d3 = 7;

//Init the LCD object with pins
LiquidCrystal lcd = LiquidCrystal(rs, enable, d0, d1, d2, d3);

void setup()
{

	//Setup 16x2 LCD
  	lcd.begin(16, 2);
	//Setup a cursor
	lcd.cursor();
	//Blink cursor
	lcd.blink();

}

void loop()
{

	//Write Hello World
	lcd.print("HELLO WORLD");

	//Move to Second Line
	lcd.setCursor(0,1);

	//Write I'm an AVR
	lcd.print("I'm an AVR!");

	//Loop Forever
	while(1) {};
}
