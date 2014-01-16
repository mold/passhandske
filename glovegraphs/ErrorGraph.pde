class ErrorGraph {
  // Set by constructors
  public int w, h;
  public int x, y;
  float max = 1;
  float min = 0;
  float error;

  // Private
  private float[] v1;
  private float[] v2;
  Style style = new Style();
  private boolean first = true;
  private boolean dynamic = false;

  ErrorGraph(int x, int y, float[] v1, float[] v2, float error) {
    w = 700;
    h = 170;
    this.x = x;
    this.y = y;
    this.v1 = v1;
    this.v2 = v2;
    this.error = error;

    if (v1.length != v2.length)
      println("error graph AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
  }

  void display() {
    // Draw background
    fill(style.GRAPH_BACKGROUND);
    stroke(style.GRAPH_BORDER);
    rect(x, y, w, h);

    // Draw graph line
    float xSize = (float)w/v1.length;
    float ySize = (float)h/(max-min);
    float y1;

    for (int i = 0; i < v1.length - 1; i++) {
      float graphX = x+i*xSize; 
      //rect(x+i*xSize, y1, xSize, (y+h-(v2[i]-min)*ySize)-y1);

      // Draw line between lines to highlight difference    
      stroke(style.GRAPH_ERROR);
      line(graphX, y+h-(v1[i]-min)*ySize, graphX, y+h-(v2[i]-min)*ySize);

      // Draw line from current value to next
      y1 = y+h-(v1[i]-min)*ySize;
      stroke(style.GRAPH_CONTENTS);
      line(graphX, y+h-(v1[i]-min)*ySize, graphX+xSize, y+h-(v1[i+1]-min)*ySize);
      stroke(style.GRAPH_INPUT);
      line(graphX, y+h-(v2[i]-min)*ySize, graphX+xSize, y+h-(v2[i+1]-min)*ySize);
    }

    // Draw text
    fill(style.TEXT);
    textSize(20);
    text(error, x+5, y+20);
  }
}

