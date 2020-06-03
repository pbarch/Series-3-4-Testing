/* Test file to build messages for TLC5711
 * data structure is copied from https://github.com/adafruit/Adafruit_TLC59711/blob/master/Adafruit_TLC59711.cpp
 * 
 * data is 224-bit chunks to each register, sent in series, structured like this:
 * WRITE COMMAND | SETTINGS | BRIGHTNESS CONTROLS | GRAYSCALE DATA
 * 
 * WRITE COMMAND = 0x25 (6 bits)
 * SETTINGS = 0x16 (5 bits) (Adafruit settings: OUTTMG = 1, EXTGCK = 0, TMGRST = 1, DSPRPT = 1, BLANK = 0 -> 0x16)
 * BRIGHTNESS CONTROLS = 0x7F * 3 (7 bits * 3) (sets brightness through current control; 7F is 100%)
 * GRAYSCALE DATA = 12 channels * 16 bit unsigned integers
 *  data is sent MSB first - see sect. 8.5.4 from the data sheet: http://www.ti.com/lit/ds/symlink/tlc5971.pdf?HQS=TI-null-null-digikeymode-df-pf-null-wwe&ts=1590455684114
 * 
*/


import processing.io.*;
SPI spi;
const long spi_speed = 500000; // Hz 

// static settings sent to every TLC59711
int settings = 0;

TLC59711_chain output = new TLC59711_chain(1);



void setup() {
  // configure SPI
  spi = new SPI(SPI.list()[0]); // SPI bus 0
  spi.settings(spi_speed, SPI.MSBFIRST, SPI.MODE1);
  delay(500);

  // configure settings:
  // write instruction
  settings = 0x25;
  
  // OUTTMG = 1, EXTGCK = 0, TMGRST = 1, DSPRPT = 1, BLANK = 0 -> 0x16
  settings <<= 5;
  settings |= 0x16;

  // Brightness control bits
  settings <<= 7;
  settings |= 0x7F; // Red, 7F = full brightness
  settings <<= 7;
  settings |= 0x7F; // Green, 7F = full brightness
  settings <<= 7;
  settings |= 0x7F; // Blue, 7F = full brightness
}

void draw() {
  
  output.chain_link[0].set_channel(0, 0);
  output.chain_link[0].set_channel(1, 30);
  output.chain_link[0].set_channel(2, 45);
  output.chain_link[0].set_channel(3, 130);
  output.chain_link[0].set_channel(4, 255);
  output.chain_link[0].set_channel(5, 500);
  output.chain_link[0].set_channel(6, 1023);
  output.chain_link[0].set_channel(7, 2000);
  output.chain_link[0].set_channel(8, 10000);
  output.chain_link[0].set_channel(9, 40000);
  output.chain_link[0].set_channel(10, 60000);
  output.chain_link[0].set_channel(11, 65535);

  output.write();
  
  background(map(100, 0, 1023, 0, 255));
  delay(1000);
}
