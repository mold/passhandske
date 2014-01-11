import processing.serial.*;

int NUMBER_OF_SENSORS = 2;
int BYTES_PER_SENSOR = 2;
GraphContainer graphC = new GraphContainer(10, // x position
10, // y position
0, // minimum value of input data
3, // maximum value of input data
NUMBER_OF_SENSORS, // number of sensors (length of input array)
700);// width of graph container (pixels)

int KEY_ACTIVATE = 32;
boolean userInput = false;
boolean savingInput = false;

int SAMPLES_PER_SECOND = 20;
float[][] inputBuffer = new float[NUMBER_OF_SENSORS][SAMPLES_PER_SECOND*100]; // 10 seconds
int inputBufferIndex = 0;  // Index for saving data to buffer

// Add variables related to Serial here
Serial serial;

void setup() {
  size(1000, 1000);

  // Init serial
  println(Serial.list());
  serial = new Serial(this, Serial.list()[0], 9600);
}

void draw() {
  // check for input
  if (userInput) {
    // User input is happening
    savingInput = true;
    while (serial.available () > NUMBER_OF_SENSORS*BYTES_PER_SENSOR+1
          && inputBufferIndex < inputBuffer[0].length    ) {
      byte[] bytes;   
      float[] newData = new float[NUMBER_OF_SENSORS];

      try {
        bytes = serial.readBytesUntil((byte)10);

        for (int i = 0; i < NUMBER_OF_SENSORS; i++) { 
          // read bytes, make into values
          float value = (float)twoBytesToInt(bytes[i*2+1], bytes[i*2]);
          newData[i] = value;
          inputBuffer[i][inputBufferIndex] = value;
        }
        inputBufferIndex++;
        graphC.addValues(newData);
      }
      catch(Exception e) {
        println(e);
      }
    }
  }
  else {
    if(savingInput){
    printInputBuffer();
    }
    savingInput = false;
    userInput = false;
  }

  graphC.display();
}
/*
void keyPressed() {
  userInput = true;
}
void keyReleased() {
  userInput = false;
}*/

void keyTyped(){
 userInput=!userInput; 
}

int twoBytesToInt(byte byte1, byte byte2) {
  return (int)(byte1 | byte2 << 8);
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
//ttyACM0

