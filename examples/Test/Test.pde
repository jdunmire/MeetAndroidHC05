/*
  Receives Test Events from your phone.
  After it gets a test message the led 13 will blink.
*/
 
#include <Arduino.h>
#include <MeetAndroid.h>
#include <HC05.h>

MeetAndroid meetAndroid;
int onboardLed = 13;

#ifdef HC05_SOFTWARE_SERIAL
#include <SoftwareSerial.h>
HC05 btSerial = HC05(A2, A5, A3, A4);  // cmd, state, rx, tx
#else
#error "Robot requires a software serial port for HC05. Reconfigure HC05.h"
#endif

void setup()  
{
  // use the baud rate your bluetooth module is configured to 
  // not all baud rates are working well, i.e. ATMEGA168 works best with 57600
  //Serial.begin(57600); 
  btSerial.findBaud();
  
  // register callback functions, which will be called when an associated event occurs.
  // - the first parameter is the name of your function (see below)
  // - match the second parameter ('A', 'B', 'a', etc...) with the flag on your Android application
  meetAndroid.registerFunction(testEvent, 'A');  

  pinMode(onboardLed, OUTPUT);
  digitalWrite(onboardLed, HIGH);

}

void loop()
{
  meetAndroid.receive(); // you need to keep this in your loop() to receive events
}

/*
 * This method is called constantly.
 * note: flag is in this case 'A' and numOfValues is 1 (since test event sends a random int)
 */
void testEvent(byte flag, byte numOfValues)
{
  // the test event in Amarino generates a random value between 0 and 255
  int randomValue = meetAndroid.getInt();
  
  flushLed(300);
  flushLed(300);
  flushLed(randomValue);
}

void flushLed(int time)
{
  digitalWrite(onboardLed, LOW);
  delay(time);
  digitalWrite(onboardLed, HIGH);
  delay(time);
}

