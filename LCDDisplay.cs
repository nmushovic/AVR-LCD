using System;
using Microsoft.SPOT;
using Microsoft.SPOT.Hardware;
using GHIElectronics.NETMF.FEZ;
using System.Threading;
using System.Text;

namespace MFConsoleApplicationSample
{
    public class LCDDisplay
    {
        private OutputPort _registerSelect;
        private OutputPort _enable;
        private OutputPort _db0;
        private OutputPort _db1;
        private OutputPort _db2;
        private OutputPort _db3;
        private const byte command = 0x00;
        private const byte dataOp = 0x01;

        //Commands
        private const byte ENTRYMODE = 0x04;
        private const byte DECREMENT =0x00;
        private const byte INCREMENT =0x02;
        private const byte SHIFTOFF  =0x00;
        private const byte SHIFTON   =0x01;
        private const byte SETDDRAM  =0x80;

        public LCDDisplay(Cpu.Pin registerSelect, Cpu.Pin enable, 
            Cpu.Pin db0, Cpu.Pin db1, Cpu.Pin db2, Cpu.Pin db3)
        {
            _registerSelect = new OutputPort(registerSelect, false);
            _enable = new OutputPort(enable, false);
            _db0 = new OutputPort(db0, false);
            _db1 = new OutputPort(db1, false);
            _db2 = new OutputPort(db2, false);
            _db3 = new OutputPort(db3, false);

            //Let the LCD Power On
            Thread.Sleep(30);

            set8BitMode();
            DelayMicroSeconds(4500);
            set8BitMode();
            set8BitMode();

            set4BitMode();

            WriteToLCD(command, 0x20 | 0x08);

            WriteToLCD(command, 0x08 | 0x04 | 0x02 | 0x01);

            WriteToLCD(command, 0x01);

            DelayMicroSeconds(2000);

            WriteToLCD(command, ENTRYMODE | INCREMENT | SHIFTOFF);
        
        }

        public void WriteToLCD(string data)
        {
            WriteToLCD(dataOp, data);
        }

        public void WriteToLCD(byte registerType, byte data)
        {
            
            _registerSelect.Write(registerType == 0x01);

            //Set High Nibble
            _db3.Write((data >> 7 & 0x01) == 0x01);
            _db2.Write((data >> 6 & 0x01) == 0x01);
            _db1.Write((data >> 5 & 0x01) == 0x01);
            _db0.Write((data >> 4 & 0x01) == 0x01);

            pulseEnable();

            _db3.Write((data >> 3 & 0x01) == 0x01);
            _db2.Write((data >> 2 & 0x01) == 0x01);
            _db1.Write((data >> 1 & 0x01) == 0x01);
            _db0.Write((data & 0x01) == 0x01);

            pulseEnable();

        }

        public void WriteToLCD(byte registerType, string data)
        {
            var buffer = Encoding.UTF8.GetBytes(data);

            foreach (byte dataByte in buffer)
	        {
                WriteToLCD(registerType, dataByte);
	        }

        }

        public void set8BitMode()
        {
            //Set Low for Command Register
            _registerSelect.Write(false);

            //Set 8 Bit Mode
            _db3.Write(false);
            _db2.Write(false);
            _db1.Write(true);
            _db0.Write(true);

            pulseEnable();
        }

        public void set4BitMode()
        {
            _registerSelect.Write(false);

            _db3.Write(false);
            _db2.Write(false);
            _db1.Write(true);
            _db0.Write(false);

            pulseEnable();
        }

        public void pulseEnable()
        {
            _enable.Write(false);
            //DelayMicroSeconds(1);
            _enable.Write(true);
            //DelayMicroSeconds(1);
            _enable.Write(false);
            DelayMicroSeconds(100);
        }

        private void DelayMicroSeconds(int microSeconds)
        {
            DateTime start = DateTime.Now;

            //Each tick is 100 nanoseconds, 1000 nanoseconds is 1 microsecond
            int stop = microSeconds * 10; 

            TimeSpan elapsedTicks = DateTime.Now - start;

            while (elapsedTicks.Ticks < stop)
            {
                elapsedTicks = DateTime.Now - start;
            }
        }
    }
}
