import processing.serial.*;

int NUMBER_OF_SENSORS = 2;
GraphContainer graphC = new GraphContainer(10, // x position
10, // y position
0, // minimum value of input data
255, // maximum value of input data
NUMBER_OF_SENSORS, // number of sensors (length of input array)
700);// width of graph container (pixels)

// Add variables related to Serial here
Serial serial;

void setup() {
  size(1000, 1000);

  // Init serial
  println(Serial.list());
  serial = new Serial(this, Serial.list()[0], 9600);
}

void draw() {
  // Get data from sensor(s) here, with Serial
  while (serial.available () > 0) {
    try {
      byte[] bytes;      

      float[] newData = new float[NUMBER_OF_SENSORS];
      for (int i = 0; i < NUMBER_OF_SENSORS; i++) {
        bytes  = serial.readBytesUntil((byte)10);
        newData[i] = parseFloat(new String(bytes));
      }
      graphC.addValues(newData);
      //print(new String(bytes));



      // Send data to graphs: input is a float array with one float for each sensor
      // uncomment code below and use maybe
      //      float[] newData = new float[NUMBER_OF_SENSORS];
      //      for (int i = 0; i < NUMBER_OF_SENSORS; i++) {
      //        newData[i] =  parseFloat(recievedBytes[i]);
      //      }
      //
      //      println(newData[0]);
      //      graphC.addValues(newData);
    }
    catch(Exception e) {
      //println(e);
    }
  }
  graphC.display();
}
//ttyACM0

