class TiltGraph {
  // Set by constructors
  int w, h;
  int x, y;
  int up, right, down, left;

  private int value;
  //private PShape triangle = createShape(TRIANGLE, 

  public TiltGraph(int x, int  y, int  w, int  h, int  u, int  r, int  d, int  l) {
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    up=u;
    right=r;
    down=d;
    left=l;
  }

  public void display() {
    // Draw background
    fill(style.GRAPH_BACKGROUND);
    stroke(style.GRAPH_BORDER);
    rect(x, y, w, h);

    // Draw rotation indicator
    fill(style.GRAPH_CONTENTS);
    ellipseMode(CORNER);
    if (value==up) {
      ellipse(x+w/3, y, w/3, h/3);
    }
    else if (value==right) {   
      ellipse(x+2*w/3, y+h/3, w/3, h/3);
    }
    else if (value==down) {
      ellipse(x+w/3, y+2*h/3, w/3, h/3);
    }
    else if (value==left) {
      ellipse(x, y+h/3, w/3, h/3);
    }
    else {
    }
  }

  public void setValue(int v) {
    this.value = v;
  }
}

