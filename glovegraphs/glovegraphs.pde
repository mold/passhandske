import processing.serial.*;

int NUMBER_OF_SENSORS = 1;
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

int SAMPLES_PER_SECOND = 50;
float[][] inputBuffer = new float[NUMBER_OF_SENSORS][SAMPLES_PER_SECOND*10]; // 10 seconds
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
  while (serial.available () > NUMBER_OF_SENSORS*BYTES_PER_SENSOR+1) {
    byte[] bytes;   
    float[] newData = new float[NUMBER_OF_SENSORS];

    try {
      bytes = serial.readBytesUntil((byte)10);

      for (int i = 0; i < NUMBER_OF_SENSORS; i++) {
        // read bytes, make into values
        int value = twoBytesToInt(bytes[i*2+1], bytes[i*2]);
        newData[i] = (float)value;
      }

      graphC.addValues(newData);
    }
    catch(Exception e) {
      println(e);
    }
  }

  graphC.display();
}

void keyPressed() {
  userInput = true;
}
void keyReleased() {
  userInput = false;
}

int twoBytesToInt(byte byte1, byte byte2) {
  return (int)(byte1 | byte2 << 8);
}
//ttyACM0

