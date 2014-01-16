class GraphContainer {
  // Set by constructors
  int w, h;
  int x, y;
  int max, min;
  int numberOfSensors;

  // Private
  float lineGraphWPercent = 0.7;
  float lineGraphHPercent = 0.16;
  float barGraphWPercent = 0.3;
  float barGraphHPercent = lineGraphHPercent;
  float tiltGraphWPercent = barGraphWPercent;
  int lineGraphW, lineGraphH, barGraphW, barGraphH, tiltGraphW;
  int padding = 10;
  boolean dynamic = false;

  BarGraph barGraph;
  LineGraph[] lineGraphs;
  TiltGraph tiltGraph;
  int steps = 700;

  Style style = new Style();

  GraphContainer(int x, int y, int min_val, int max_val, int numberOfSensors, int width) {
    w = width;

    max = max_val;
    min = min_val;
    this.x = x;
    this.y = y;
    this.numberOfSensors = numberOfSensors;
    lineGraphW = Math.round((width-padding*2)*lineGraphWPercent);
    lineGraphH = Math.round((width-padding*2)*lineGraphHPercent);
    barGraphW = Math.round((width-padding*4)*barGraphWPercent);
    barGraphH = Math.round((width-padding*2)*barGraphHPercent);
    tiltGraphW = Math.round((width-padding*4)*tiltGraphWPercent);

    h = (int)Math.ceil(padding*2+numberOfSensors*lineGraphH+(numberOfSensors-1)*padding);

    barGraph = new BarGraph(x+padding+lineGraphW+padding, y+padding, min, max, numberOfSensors, barGraphW, barGraphH);
    tiltGraph = new TiltGraph(x+padding+lineGraphW+padding, y+2*padding+barGraphH, tiltGraphW, tiltGraphW, 3, 1, 0, 2);

    lineGraphs = new LineGraph[numberOfSensors-1];
    for (int i = 0; i < numberOfSensors-1; i++) {
      lineGraphs[i] = new LineGraph(x+padding, y+padding+i*(lineGraphH+padding), min, max, steps, lineGraphW, lineGraphH);
    }
  }

  void display() {
    // Draw background
    fill(style.GRAPH_BACKGROUND);
    stroke(style.GRAPH_BORDER);
    //rect(x, y, w, h);

    // Draw line graphs
    for (int i = 0; i < lineGraphs.length; i++) {
      lineGraphs[i].display();
    }

    barGraph.display();
    
    tiltGraph.display();
  }

  void addValues(int[] newValues) {
    // separate analogue/digital
    int[] analog = Arrays.copyOf(newValues, newValues.length-1);
    for (int i = 0; i < analog.length; i++) {
      lineGraphs[i].addValue(analog[i]);
    }
    barGraph.addValues(analog);
    
    // digital to tilt
    tiltGraph.setValue(newValues[newValues.length-1]);
  }

  /**
   * Whether to change the min/max values dynamically
   */
  void setDynamicInterval(boolean set) {
    // TODO: test
    dynamic = set;

    for (int i = 0; i < lineGraphs.length; i++) {
      lineGraphs[i].setDynamic(set);
    }
    barGraph.setDynamic(set);
  }
}  

