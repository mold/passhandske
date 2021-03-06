class BarGraph {
  // Set by constructors
  int w, h;
  int x, y;
  int max, min;
  int numberOfBars;

  // Private
  int[] barValues;
  color cBackground = color(255);
  color cStroke = color(0);
  color cBar = color(100, 100, 100);
  boolean dynamic = false;
  
  Style style = new Style();

  BarGraph(int x, int y, int min_val, int max_val, int numberOfBars, int width, int height) {
    this.x = x; 
    this.y = y; 
    min = min_val; 
    max = max_val; 
    w = width; 
    h = height;
    this.numberOfBars = numberOfBars-1;
    barValues = new int[this.numberOfBars];
  }
  BarGraph(int x, int y, int min_val, int max_val, int numberOfBars) {
    this.x = x; 
    this.y = y; 
    min = min_val; 
    max = max_val; 
    w = 300; 
    h = 200;
    this.numberOfBars = numberOfBars-1;
    barValues = new int[this.numberOfBars];
  }

  void display() {
    // Draw background
    fill(style.GRAPH_BACKGROUND);
    stroke(style.GRAPH_BORDER);
    rect(x, y, w, h);

    // Draw bars
    int margin = 10; 
    int padding = 7;
    float barW = (w-margin*2-padding*(numberOfBars-1))/(numberOfBars);
    fill(style.GRAPH_CONTENTS);
    for (int i = 0; i < numberOfBars; i++) {
      float barH = (barValues[i]-min)*((float)h/(max-min));
      rect(x+margin+i*(barW+padding), y+h-barH, barW, barH);
    }
  }

  void addValues(int[] barValues) {
    this.barValues = barValues;

    for (int i = 0; i < barValues.length; i++) {
      int val = barValues[i];
      if (val > max) {
        max = parseInt(val);
      }
      else if (val < min) {
        min = parseInt(val);
      }
    }
  }

  void setDynamic(boolean set) {
    dynamic = set;
  }
}

