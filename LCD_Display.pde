//******1/10/2012***************************
//Just a quick program to demonstrate how the
//lcd works at a low level. No reason to
//do all this work because the Arduino project
//has an excellent LiquidCrystal library.

//Pins - Could use less memory by using define instead of variables....
const int rs = 2;		//Register Select
const int enable = 3;   //Used to signal LCD to read data pins
const int d0 = 4;		//In 4-bit mode, low nibble, read on 2nd pulse
const int d1 = 5;		//In 4-bit mode, low nibble, read on 2nd pulse
const int d2 = 6;		//In 4-bit mode, low nibble, read on 2nd pulse
const int d3 = 7;		//In 4-bit mode, low nibble, read on 2nd pulse
const int d4 = 4;		//In 4-bit mode, high nibble, read on 1st pulse
const int d5 = 5;		//In 4-bit mode, high nibble, read on 1st pulse
const int d6 = 6;		//In 4-bit mode, high nibble, read on 1st pulse
const int d7 = 7;		//In 4-bit mode, high nibble, read on 1st pulse
const int command = 0;  //Commands are Low on RS
const int dataOp = 1;   //Data operations are High on RS

//Commands
#define ENTRYMODE 0x04
#define DECREMENT 0x00
#define INCREMENT 0x02
#define SHIFTOFF  0x00
#define SHIFTON   0x01
#define SETDDRAM  0x80

void setup()
{
	//BEGIN INITILIZATION OF LCD

	//Setup our PINS as Outputs
	//Could set PINs simulutaneously with 
	//DDRD = DDRD | B11111100; 
	//or use a loop 
	//for(int x = 2; x < 8; x++) { pinMode(x, OUTPUT); }
	pinMode(rs, OUTPUT);
	pinMode(enable, OUTPUT);

	//these are also d4, d5, d6, d7
	pinMode(d0, OUTPUT);
	pinMode(d1, OUTPUT);
	pinMode(d2, OUTPUT);
	pinMode(d3, OUTPUT);

	//Power ON
	//Wait from more than 30ms for the LCD to Power on
	delay(30);

	//Initially the LCD is in 8 bit mode if LCD is powered on. 
	//It Could be in 4-bit mode if MicroController is reset, but LCD is
	//left on so we need to explicitly put LCD into 8-BIT mode first,
	//then switch it to 4-BIT mode.
	set8BitMode(); //1st Try
	delayMicroseconds(4500);
	set8BitMode(); //2nd Try
	set8BitMode(); //3rd Try

	//We should definatley be in 8-bit mode, so we will 
	//set to 4-bit mode
	set4BitMode();

	//Now we start the Initilization and we write 8-bit
	//data in 4-bit chunks. 
	//Function SET
	//4-Bit Mode 0x20
	//2-Line Mode 0x08
	//1-Line Mode 0x00
	//5x8 Mode 0x00
	//5x10 Mode 0x04
	WriteToLcd(command, 0x20 | 0x08); //OR the two commands to get 0x28

	//Display on/off Control
	//Display Command 0x08
	//Display On 0x04
	//Display OFF 0x00
	//Cursor On 0x02
	//Cursor OFF 0x00
	//Blink On 0x01
	//Blink Off 0x00
	WriteToLcd(command, 0x08 | 0x04 | 0x02 | 0x01); //0x0F

	//Clear Display
	WriteToLcd(command, 0x01);
	delayMicroseconds(2000);

	//Entry Mode Set
	//Could also have these codes as defines 
	//like so:
	WriteToLcd(command, ENTRYMODE | INCREMENT | SHIFTOFF);

	//ENDS Initilization
}

void loop()
{

	//Write Hellow World (Should use a loop, this is the long way)	
	WriteToLcd(dataOp, 'H');
	WriteToLcd(dataOp, 'E');
	WriteToLcd(dataOp, 'L');
	WriteToLcd(dataOp, 'L');
	WriteToLcd(dataOp, 'O');
	WriteToLcd(dataOp, ' ');
	WriteToLcd(dataOp, 'W');
	WriteToLcd(dataOp, 'O');
	WriteToLcd(dataOp, 'R');
	WriteToLcd(dataOp, 'L');
	WriteToLcd(dataOp, 'D');

	//Move to Second line
	//fist Column/second Line DDRAM Register 0x40
	WriteToLcd(0, SETDDRAM | 0x40);

	//Print a string to the LCD
	printString("I'm an AVR!");

	//Loop forever and do nothing
	while(1) {};

}

void printString(String value)
{
	//Each character in the string is an 8-bit/1byte
	//ASCII code, which compiler will translate for us
	for(int x = 0; x < value.length(); x++)
	{
		WriteToLcd(dataOp, value[x]);
	}
}

void set8BitMode()
{

	//Set low for Command
	digitalWrite(rs, LOW); 

	//Set 8 Bit Mode
	digitalWrite(d7, LOW);
	digitalWrite(d6, LOW);
	digitalWrite(d5, HIGH);
	digitalWrite(d4, HIGH);

	pulseEnable();
}

void set4BitMode()
{

	//Set low for Command
	digitalWrite(rs, LOW); 

	//Set 4-bit mode
	digitalWrite(d7, LOW);
	digitalWrite(d6, LOW);
	digitalWrite(d5, HIGH);
	digitalWrite(d4, LOW);

	pulseEnable();
}


void WriteToLcd(uint8_t reg_type, uint8_t data)
{

	//Select Register: Low = Command, HIGH = Data Operation
	digitalWrite(rs, reg_type);

	//Long Hand for clarity, but should be refactored using
	//loops

	//set High Nibble
	digitalWrite(d7, (data >> 7) & 0x01);
	digitalWrite(d6, (data >> 6) & 0x01);
	digitalWrite(d5, (data >> 5) & 0x01);
	digitalWrite(d4, (data >> 4) & 0x01);

	pulseEnable();

	//Set Low Nibble
	digitalWrite(d3, (data >> 3) & 0x01);
	digitalWrite(d2, (data >> 2) & 0x01);
	digitalWrite(d1, (data >> 1) & 0x01);
	digitalWrite(d0, (data & 0x01));

	pulseEnable();

}

void pulseEnable()
{
	digitalWrite(enable, LOW);
	delayMicroseconds(1);    
	digitalWrite(enable, HIGH);
	delayMicroseconds(1);
	digitalWrite(enable, LOW);
	delayMicroseconds(100); 

}


