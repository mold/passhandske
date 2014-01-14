import processing.serial.*;

State activeState;

int NUMBER_OF_SENSORS = 5;
int BYTES_PER_SENSOR = 2;
GraphContainer graphC;

int KEY_ACTIVATE = 32;
boolean userInput = false;
boolean savingInput = false;

int SAMPLES_PER_SECOND = 20;
float[][] inputBuffer;
int inputBufferIndex = 0;  // Index for saving data to buffer

// Add variables related to Serial here
Serial serial;

void setup() {
  size(1000, 1000);
  activeState = State.SET;
  clearInputBuffer();
  graphC = newGraphC();

  // Init serial
  serial = new Serial(this, Serial.list()[0], 9600);
}

void draw() {
  background(color(255, 230, 200));  
  switch(activeState) {
  case SET:
    setPassword();
    break;
  case INPUT:
    inputPassword();
    break;
  case VERIFY:
    verifyPassword();
    break;
  default:
    break;
  }
}
/*
void keyPressed() {
 userInput = true;
 }
 void keyReleased() {
 userInput = false;
 }*/

void changeState(State s) {
  activeState = s;
  clearInputBuffer();
  graphC = newGraphC();
  userInput = false;
  savingInput = false;
  println("Active state: "+activeState);
}

void keyTyped() {
  switch(key) {   // Change state maybe?
  case '1':
    changeState(State.SET);
    break;
  case '2':
    changeState(State.INPUT);
    break;
  case '3':
    changeState(State.VERIFY);
    break;
  case 32:  // space toggles user input from glove
    userInput=!userInput;
    break;
  default:
    break;
  }
}

int twoBytesToInt(byte byte1, byte byte2) {
  return (byte1 & 0xff) | ((byte2 & 0xff) << 8 );
}

void printInputBuffer() {
  for (int i = 0; i < inputBuffer.length; i++) {
    print("Sensor "+i+": ");
    for (int j = 0; j < inputBuffer[0].length; j++) {
      print(inputBuffer[i][j]+ " ");
    }
    println();
  }
}

/**
 * Use user input to set the password!
 */
void setPassword() {
  drawTitle("SET PASSWORD");

  // check for input
  if (userInput) {  // User input is happening
    savingInput = true;  // save new password to buffer
    readSerial();
  }
  else {
    if (savingInput) {  // Done getting new password
      printInputBuffer();
      savingInput = false;
      // TODO: Save to password checker librrrarry
    }

    userInput = false;
  }

  graphC.display();
}

/**
 * User inputs a password to try and "log in"
 */
void inputPassword() {
  drawTitle("INPUT PASSWORD");

  // check for input
  if (userInput) {  // User input is happening
    savingInput = true;  // save new password to buffer
    readSerial();
  }
  else {
    if (savingInput) {  // Done getting new password
      printInputBuffer();
      savingInput = false;
      changeState(State.VERIFY);
    }

    userInput = false;
  }

  graphC.display();
}

/**
 * Verify password
 */
void verifyPassword() {
  drawTitle("VERIFYING PASSWORD");

  // Verify password
}

/**
 * Draw text at the top of the window (preferably state and/or instructions)
 */
void drawTitle(String text) {
  fill(0, 0, 0);
  textSize(20);
  text(text, 10, 30);
}

void clearInputBuffer() {
  inputBuffer = new float[NUMBER_OF_SENSORS][SAMPLES_PER_SECOND*100]; // 10 seconds
}

/**
 * Shortcut for getting a new graph container
 */
GraphContainer newGraphC() {
  GraphContainer x = new GraphContainer(10, // x position
  40, // y position
  300, // minimum value of input data
  400, // maximum value of input data
  NUMBER_OF_SENSORS, // number of sensors (length of input array)
  700);// width of graph container (pixels)
  x.setDynamicInterval(true);
  return x;
}

/**
 * Reads serial, saves to buffer and graph
 * MAMA LUIGI
 * HOPE SHE'S MADE LOTSA SPAGHEEEETTIIIIII
 * SPAGHEEEEEETTIIIII
 */
void readSerial() {
  while (serial.available () > NUMBER_OF_SENSORS*BYTES_PER_SENSOR) {
    if (inputBufferIndex >= inputBuffer[0].length) {
      inputBufferIndex = 0;
    }
    byte[] bytes = new byte[1];   
    // Data from one sampling
    float[] newData = new float[NUMBER_OF_SENSORS];

    try {
      bytes = serial.readBytesUntil((byte)10);  // Read until newline
      int readBytes = (bytes.length-1)/2;
      if (NUMBER_OF_SENSORS == readBytes) {
        for (int i = 0; i < NUMBER_OF_SENSORS; i++) {  // Get data for each sensor

            // Convert two bytes to one float
          float value = (float)twoBytesToInt(bytes[i*2+1], bytes[i*2]);
          // Save to newData and inputBuffer
          newData[i] = value;
          inputBuffer[i][inputBufferIndex] = value;
        } 

        inputBufferIndex++;
        // Add new data to display
        graphC.addValues(newData);
      }
    }
    catch(Exception e) {
      println(e);
      println(bytes);
    }
  }
}
//ttyACM0

