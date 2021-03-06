import processing.serial.*;
import java.util.*;
import guru.ttslib.*;
State activeState;

int NUMBER_OF_SENSORS = 6; // last sensor is always assumed to be the only digital
// bad I know, but hey
int BYTES_PER_SENSOR = 2;
GraphContainer graphC;
PasswordManager pwm;

int KEY_ACTIVATE = 32;
boolean userInput = false;
boolean savingInput = true;

int SAMPLES_PER_SECOND = 40;
int[][] inputBuffer;
int inputBufferIndex = 0;  // Index for saving data to buffer

boolean calibrated = false;
float[] sensorMinVal = new float[NUMBER_OF_SENSORS];
float[] sensorMaxVal = new float[NUMBER_OF_SENSORS];

Style style = new Style();
TTS tts; 
int voiceFrequency = 100;
Beeper beep = new Beeper();

// Add variables related to Serial here
Serial serial;

void setup() {
  size(displayWidth, displayHeight);
  println(style.TEXT);
  activeState = State.CALIBRATE;
  clearInputBuffer();
  graphC = newGraphC();
  resetCalib();

  tts = new TTS(); 
  tts.setPitch(voiceFrequency);
  // Set up passwordmanager
  pwm = new PasswordManager(SAMPLES_PER_SECOND);
  pwm.x = 10;
  pwm.y = 40;

  // Init serial
  serial = new Serial(this, Serial.list()[0], 9600);
}

void resetCalib() {
  for (int i = 0; i < NUMBER_OF_SENSORS; i++) {
    sensorMinVal[i] = 1000;
    sensorMaxVal[i] = 0;
  }

  sensorMinVal[5] =0;
  sensorMaxVal[5] =3;
}

void draw() {
  beep.update();
  style.backgroundGradient(0, 0, width, height);

  switch(activeState) {
  case CALIBRATE:
    calibrate();
    break;
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
  serial.clear();
  println("Active state: "+activeState);
}

void keyTyped() {
  switch(key) {   // Change state maybe?
  case '0':
    changeState(State.CALIBRATE);
    break;
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
  case 'c': // calibrtion done!
    if (activeState == State.CALIBRATE)
      calibrated = !calibrated;
    break; 
  case 'm': //mute
    if (beep.mute)
      beep.unmute();
    else
      beep.mute();
    break;
  case 'r':
    resetCalib();
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
    if (!savingInput) {
      // gonna start getting input so clear buffer!!!
      serial.clear();
    }
    savingInput = true;  // save new password to buffer
    readSerial();
  }
  else {
    if (savingInput) {  // Done getting new password
      savingInput = false;
      //println("input buffer");
      //printInputBuffer();

      pwm.savePassword(getTrimmedBuffer());
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
    if (!savingInput) {
      // gonna start getting input so clear buffer!!!
      serial.clear();
    }
    savingInput = true;  // save new password to buffer
    readSerial();
  }
  else {
    if (savingInput) {  // Done getting new password
      //printInputBuffer();
      savingInput = false;

      pwm.verifyPassword(getTrimmedBuffer());

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

  style.backgroundGradient(0, 0, width, height, pwm.correct);



  pwm.display();
}

/**
 * Draw text at the top of the window (preferably state and/or instructions)
 */
void drawTitle(String text) {
  fill(style.TEXT);
  textSize(20);
  text(text, 10, 30);
}

void clearInputBuffer() {
  inputBuffer = new int[NUMBER_OF_SENSORS][SAMPLES_PER_SECOND*20];
  inputBufferIndex = 0;
}

/**
 * trims AND NORMALIZES the buffer
 */
float[][] getTrimmedBuffer() {
  float[][] trimmed = new float[NUMBER_OF_SENSORS][inputBufferIndex];

  for (int i = 0; i < NUMBER_OF_SENSORS; i++) {
    for (int j = 0; j < inputBufferIndex; j++) {
      trimmed[i][j] = (inputBuffer[i][j]-sensorMinVal[i])/(sensorMaxVal[i]-sensorMinVal[i]);
      if (trimmed[i][j] < 0) {
        trimmed[i][j] =0;
      }
      if (trimmed[i][j] > 1) {
        trimmed[i][j] = 1;
      }
    }
  }

  return trimmed;
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
  1000);// width of graph container (pixels)
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
  while (serial.available () > NUMBER_OF_SENSORS*BYTES_PER_SENSOR && savingInput) {
    if (inputBufferIndex >= inputBuffer[0].length) {
      inputBufferIndex = 0;
    }
    byte[] bytes = new byte[1];   
    // Data from one sampling
    int[] newData = new int[NUMBER_OF_SENSORS];

    try {
      bytes = serial.readBytesUntil((byte)10);  // Read until newline
      int readBytes = (bytes.length-1)/2;
      if (NUMBER_OF_SENSORS == readBytes) {
        for (int i = 0; i < NUMBER_OF_SENSORS; i++) {  // Get data for each sensor
          // Convert two bytes to one float
          int value = twoBytesToInt(bytes[i*2+1], bytes[i*2]);

          //println(value);
          if (!calibrated) {
            sensorMinVal[i] = value < sensorMinVal[i] ? value : sensorMinVal[i];
            sensorMaxVal[i] = value > sensorMaxVal[i] ? value : sensorMaxVal[i];
          }

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
      //println(bytes);
    }
  }
}

/**
 * Calibration time, come on
 */
void calibrate() {
  drawTitle("CALIBRATION");
  savingInput=true;
  String s = "Calibrate the gloves by first clenching your fist (with the thumb "+
    "inside your fingers), then opening your hand as far as possible."+
    "\n\nWhen you've done this, press 'c' to save your min/max values and then '1' to begin.\n\n";
  s+="\n\nMin values: ";
  for (int i = 0; i < NUMBER_OF_SENSORS; i++) {
    s+=sensorMinVal[i]+" ";
  }

  s+="\nMax values: ";
  for (int i = 0; i < NUMBER_OF_SENSORS; i++) {
    s+=sensorMaxVal[i]+" ";
  }  
  if (calibrated) {
    fill(style.TEXT_RED);
  }
  else {
    fill(style.TEXT);
  }

  text(s, 10, 80, 500, 500);

  readSerial();
  

}
//ttyACM0

