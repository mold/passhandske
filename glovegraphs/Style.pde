class Style {


  // Background gradient
  public color BG_START = color(0x53, 0x38, 0x60);
  public color BG_END = color(0x33, 0x33, 0x33);


  public final color GRAPH_BORDER = color(0x98, 0xFF, 0x5C);
  public final color GRAPH_BACKGROUND = BG_START;
  public final color GRAPH_CONTENTS = GRAPH_BORDER; // for lines and  bars
  public final color TEXT =GRAPH_BORDER;
  public final color GRAPH_ERROR = color(255, 100, 150);
  public final color GRAPH_INPUT = color(100, 100, 255); // mmmagenta
  public final color TEXT_RED = GRAPH_ERROR;

  public color BG_CORRECT_START = GRAPH_BORDER;
  public color BG_INCORRECT_START =GRAPH_ERROR;

  public final int STROKE_WEIGHT = 2;

  public void backgroundGradient(int x, int y, int w, int h) {
    gradient(x, y, w, h, BG_START, BG_END);
  }

  public void backgroundGradient(int x, int y, int w, int h, boolean correct) {
   if(correct)
   gradient(x, y, w, h, BG_CORRECT_START, BG_END);
   else
   gradient(x, y, w, h, BG_INCORRECT_START, BG_END);
  }

  public void gradient(int x, int y, int w, int h, color c1, color c2) {
    for (int i = y; i < y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }

  public void styleLine(float x1, float y1, float x2, float y2) {
    strokeWeight(STROKE_WEIGHT);
    line(x1, y1, x2, y2);
    strokeWeight(1);
  }

  public Style() {
  }
}

