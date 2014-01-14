class LineGraph {
  // Set by constructors
  int w, h;
  int x, y;
  int max, min;

  // Private
  int[] values;
  int position = 0;  // What value in values we're currently on/last updated
  color cFill = color(255);
  color cStroke = color(0);
  color cLine = color(255, 0, 0);
  color cText = color(40, 40, 40);
  boolean first = true;
  boolean dynamic = false;

  LineGraph(int x, int y, int min_val, int max_val, int steps) {
    w = 700;
    h = 200;
    max = max_val;
    min = min_val;
    this.x = x;
    this.y = y;
    values = new int[steps];
  }

  LineGraph(int x, int y, int min_val, int max_val, int steps, int width, int height) {
    w = width;
    h = height;
    max = max_val;
    min = min_val;
    this.x = x;
    this.y = y;
    values = new int[steps];
  }

  void display() {
    // Draw background
    fill(cFill);
    stroke(cStroke);
    stroke(color(0));
    rect(x, y, w, h);

    // Draw graph line
    float xSize = (float)w/values.length;
    float ySize = (float)h/(max-min);

    for (int i = 0; i < position-1; i++) {
      // Draw line from current value to next
      stroke(cLine);
      line(x+i*xSize, y+h-(values[i]-min)*ySize, x+(i+1)*xSize, y+h-(values[i+1]-min)*ySize);
    }

    // Draw text
    fill(0, 0, 0);
    textSize(20);
    text(values[position == 0 ? 0:position-1], x+5, y+20);
  }

  /*
  void displayOverDraw() {
   // Draw background
   if (first) {
   fill(cFill);
   stroke(cStroke);
   stroke(color(0));
   rect(x, y, w, h);
   first = false;
   }
   
   // Draw graph line
   float xSize = (float)w/values.length;
   float ySize = (float)h/(max-min);
   
   for (int i = 0; i < position-1; i++) {
   // Draw background
   noStroke();
   fill(cFill);
   rect(x+i*xSize, y, xSize, y+h);
   // Draw line from current value to next
   stroke(cLine);
   line(x+i*xSize, y+h-(values[i]-min)*ySize, x+(i+1)*xSize, y+h-(values[i+1]-min)*ySize);
   }
   }
   */

  void addValue(int value) {
    position = position%values.length;
    values[position] = value;
    if (dynamic) {
      if (value > max) {
        max = value;
      }
      else if (value < min) {
        min = value;
      }
    }

    position++;
  }

  void setDynamic(boolean set) {
    dynamic = set;
  }
}

