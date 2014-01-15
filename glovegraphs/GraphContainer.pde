class GraphContainer {
  // Set by constructors
  int w, h;
  int x, y;
  int max, min;
  int numberOfSensors;

  // Private
  float lineGraphWPercent = 0.7;
  float lineGraphHPercent = 0.18;
  float barGraphWPercent = 0.3;
  float barGraphHPercent = lineGraphHPercent;
  int lineGraphW, lineGraphH, barGraphW, barGraphH;
  int padding = 10;
  boolean dynamic = false;

  BarGraph barGraph;
  LineGraph[] lineGraphs;
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

    h = (int)Math.ceil(padding*2+numberOfSensors*lineGraphH+(numberOfSensors-1)*padding);

    barGraph = new BarGraph(x+padding+lineGraphW+padding, y+padding, min, max, numberOfSensors, barGraphW, barGraphH);

    lineGraphs = new LineGraph[numberOfSensors];
    for (int i = 0; i < numberOfSensors; i++) {
      lineGraphs[i] = new LineGraph(x+padding, y+padding+i*(lineGraphH+padding), min, max, steps, lineGraphW, lineGraphH);
    }
  }

  void display() {
    // Draw background
    fill(style.GRAPH_BACKGROUND);
    stroke(style.GRAPH_BORDER);
    //rect(x, y, w, h);

    // Draw line graphs
    for (int i = 0; i < numberOfSensors; i++) {
      lineGraphs[i].display();
    }

    barGraph.display();
  }

  void addValues(int[] newValues) {
    for (int i = 0; i < numberOfSensors; i++) {
      lineGraphs[i].addValue(newValues[i]);
    }
    barGraph.addValues(newValues);
  }

  /**
   * Whether to change the min/max values dynamically
   */
  void setDynamicInterval(boolean set) {
    // TODO: test
    dynamic = set;

    for (int i = 0; i < numberOfSensors; i++) {
      lineGraphs[i].setDynamic(set);
    }
    barGraph.setDynamic(set);
  }
  
}  

