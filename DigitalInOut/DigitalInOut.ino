const int dPins[]  = {
  8,  // tilt sensor 1A
  9  // tilt sensor 1B
};

const int bPins[] = {
  A0,  // thumb
  A1,  // index
  A2,  // middle
  A3,  // ring
  A4  // pinky
};

int dNoPins = sizeof(dPins)/sizeof(int);
int bNoPins = sizeof(bPins)/sizeof(int);
int SAMPLES_PER_SECOND = 15;

int buttonPin = 12;

void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600); 
  // set pin modes for digital pins
  for(int i = 0; i < dNoPins; i++){
    pinMode(dPins[i], INPUT); 
  }
  for(int i = 0; i < bNoPins; i++){
    pinMode(bPins[i], INPUT); 
    digitalWrite(bPins[i], HIGH);
  }
}

void loop() {
  //  // read and send digital value
  //  for(int i = 0; i < dNoPins; i++){
  //    sendInt16AsBytes(digitalRead(dPins[i]));
  //    digitalWrite(dPins[i], LOW);
  //  }
  //
  //  digitalWrite(buttonPin, HIGH);
  //
  //  if(digitalRead(buttonPin)){
  //    // Combine the tilt sensor values to one int
  //    //int tiltValue = (int)(digitalRead(dPins[0]) << 1 | digitalRead(dPins[1]));
  //    //sendInt16AsBytes(tiltValue);
  //
  //    // End transmission with a linebreak (sortof)
  //    Serial.write(10);
  //  }

  for(int i = 0; i < bNoPins; i++){
    //int value = analogRead(bPins[i]);
    int value = map(analogRead(bPins[i]), 0, 1023, 0, 1000);
    //Serial.print(value);
    sendInt16AsBytes(value);
  //Serial.println(value);
  }
 // Serial.println();
  // End transmission with a linebreak (sortof)
  Serial.write(10);
  // wait 
  // for the analog-to-digital converter to settle
  // after the last reading:
  delay(1000/SAMPLES_PER_SECOND);                     
}

/**
 * Sends an int as two bytes (over Serial)
 */
void sendInt16AsBytes(int data){
  Serial.write(highByte(data));
  Serial.write(lowByte(data));
}






