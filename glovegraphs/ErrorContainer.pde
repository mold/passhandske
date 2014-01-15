class ErrorContainer {
  // Set by constructors
  int w, h;
  int x, y;
  float max, min;
  int numberOfSensors;

  // Private
  float lineGraphWPercent = 0.7;
  float lineGraphHPercent = 0.18;
  float barGraphWPercent = 0.3;
  float barGraphHPercent = lineGraphHPercent;
  int lineGraphW, lineGraphH, barGraphW, barGraphH;
  int padding = 10;
  boolean dynamic = false;

  ErrorGraph[] errorGraphs;

  color cFill = color(255);
  color cStroke = color(0);
  
  float[][] password1;
  float[][] password2;
  float[] errors;

  ErrorContainer(int x, int y, int width, float[][] p1, float[][] p2, float[] errors) {
    w = width;

    this.x = x;
    this.y = y;
    this.numberOfSensors = p1.length;
    
    password1 = p1;
    password2 = p2;
    this.errors = errors;

    lineGraphW = 700;
    lineGraphH = 200;

    h = (int)Math.ceil(padding*2+numberOfSensors*lineGraphH+(numberOfSensors-1)*padding);

    errorGraphs = new ErrorGraph[numberOfSensors];
    for (int i = 0; i < numberOfSensors; i++) {
      errorGraphs[i] = new ErrorGraph(x+padding, y+padding+i*(lineGraphH+padding), password1[i], password2[i], errors[i]);
    }
  }

  void display() {
    // Draw background
    fill(cFill);
    stroke(cStroke);
    rect(x, y, w, h);

    // Draw line graphs
    for (int i = 0; i < numberOfSensors; i++) {
      errorGraphs[i].display();
    }
  }
  
}  
