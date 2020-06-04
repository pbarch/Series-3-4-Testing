/*
 * Taken from: https://forum.arduino.cc/index.php?topic=52111.0
 */

#include <SPI.h>

volatile bool data_received = false;

const uint8_t buffer_size = 28;
volatile uint8_t data_buffer[buffer_size];
volatile uint8_t buffer_position = 0;

int counter = 0;

void setup() {
  Serial.begin(115200);
  
 // turn on SPI in slave mode
 SPCR |= _BV(SPE);

 // SPI mode 1
 SPCR |= _BV(CPHA);
 
 // turn on interrupts
 SPCR |= _BV(SPIE);

  delay(100);

  Serial.print("printing spi register: ");
  int spi_register = SPCR;
  Serial.println(spi_register);
}

ISR (SPI_STC_vect)
{
  byte incoming_byte = SPDR;

//  Serial.println(incoming_byte);
  
  // add byte to data buffer 
  if(buffer_position < buffer_size){
    data_buffer[buffer_position] = incoming_byte;
    buffer_position++;
  }

  // signal a complete message has been received
  if(buffer_position == buffer_size){
    data_received = true;
  }
}

void loop() {

  if(data_received){
    Serial.println("---------------");
    for(counter = 0; counter < buffer_size; counter++){
      Serial.print(data_buffer[counter]);
      if(counter < buffer_size - 1){
        Serial.print(" | ");
      }
    }
    Serial.println("\n---------------");
    buffer_position = 0;
    data_received = false;
  }
  
}
