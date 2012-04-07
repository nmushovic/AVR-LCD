using System;
using Microsoft.SPOT;
using Microsoft.SPOT.Hardware;
using GHIElectronics.NETMF.FEZ;
using System.Threading;

namespace MFConsoleApplicationSample
{
    public class Program
    {

        public static void Main()
        {
            var LCD = new LCDDisplay((Cpu.Pin)FEZ_Pin.Digital.Di31, (Cpu.Pin)FEZ_Pin.Digital.Di29, (Cpu.Pin)FEZ_Pin.Digital.Di27, (Cpu.Pin)FEZ_Pin.Digital.Di25,
                            (Cpu.Pin)FEZ_Pin.Digital.Di23, (Cpu.Pin)FEZ_Pin.Digital.Di21);

            LCD.WriteToLCD("Hello World!");

            while (true)
            {

            }
        }


    }
}
