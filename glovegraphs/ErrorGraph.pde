class ErrorGraph {
  // Set by constructors
  public int w, h;
  public int x, y;
  float max = 1;
  float min = 0;
  float error;

  // Private
  float[] v1;
  float[] v2;
  color cFill = color(255);
  color cStroke = color(0);
  color cLine = color(255, 0, 0);
  color cText = color(40, 40, 40);
  color cError = color(255, 0, 0);
  boolean first = true;
  boolean dynamic = false;

  ErrorGraph(int x, int y, float[] v1, float[] v2, float error) {
    w = 700;
    h = 200;
    this.x = x;
    this.y = y;
    this.v1 = v1;
    this.v2 = v2;
    this.error = error;
  }

  void display() {
    // Draw background
    fill(cFill);
    stroke(cStroke);
    stroke(color(0));
    rect(x, y, w, h);

    // Draw graph line
    float xSize = (float)w/v1.length;
    float ySize = (float)h/(max-min);
    float y1;

    for (int i = 0; i < v1.length - 1; i++) {
      // Draw line from current value to next
      fill(cError);
      y1 = y+h-(v1[i]-min)*ySize;
      //rect(x+i*xSize, y1, xSize, (y+h-(v2[i]-min)*ySize)-y1);
      line(x+i*xSize, y+h-(v1[i]-min)*ySize, x+(i+1)*xSize, y+h-(v1[i+1]-min)*ySize);
      line(x+i*xSize, y+h-(v2[i]-min)*ySize, x+(i+1)*xSize, y+h-(v2[i+1]-min)*ySize);
    }

    // Draw text
    fill(0, 0, 0);
    textSize(20);
    text(error, x+5, y+20);
  }

}
