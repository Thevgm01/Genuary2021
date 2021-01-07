color fillColor = color(0);
color backgroundColor = color(255);

int counter = 0;
int swaps = 0;
int framesToRotateBack = 90;
int framesToSlice = 10;

void setup() {
  size(400, 400); 
}

void keyPressed() {
  frameRate(50);
  if(key == ' ') {
    counter = 0;
  }
}

void draw() {
  if(counter > framesToRotateBack) swap();

  background(backgroundColor);
  
  translate(width/2, height/2);
  
  scale(1 - (2 * (swaps % 2)), 1);

  pushMatrix();

  // Left half
  pushMatrix();
  translate(-counter * 2f, (counter * counter - counter * 20) / 20f);
  scale(142f);
  translate(-0.175, 0.175);
  rotate(3*PI/4);
  rotate(counter / -20f);
  drawTriangle();
  popMatrix();
  
  pushMatrix();
  float frac = (float)counter / framesToRotateBack;
  frac = easeFunc(frac, 3f);
  scale(lerp(142, 200, frac));
  float trans = lerp(0.175, 0, frac);
  translate(trans, trans);
  rotate(lerp(-3 * PI / 4, 0, frac));
  //translate(getSpinDir(0) * sin(frac * PI) / 2, getSpinDir(swaps) * sin(frac * PI) / 2);
  translate(sin(frac * PI) / 4, -sin(frac * PI) / 2);
  drawTriangle();
  popMatrix();
  
  popMatrix();
  /*
  float sliceFrac = (float)counter / framesToSlice;
  if(sliceFrac < 1) {
    pushMatrix();
    scale(100f);
    fill(fillColor, 255 * (1f - sliceFrac));
    drawSlice();
    popMatrix();
  }
  */
  ++counter;
  
  saveFrame("frames/" + frameCount);
}

int getSpinDir(int offset) {
   switch((swaps + offset) % 8) {
     case 0: return 1;
     case 1: return 1;
     case 2: return 0;
     case 3: return 0;
     case 4: return -1;
     case 5: return -1;
   }
   return 0;
}

void swap() {
  counter = 0;
  
  color temp = backgroundColor;
  backgroundColor = fillColor;
  fillColor = temp;
  
  ++swaps;
}

void drawTriangle() {
  fill(fillColor);
  noStroke();
  beginShape();
  vertex(-0.5f, 0.25f);
  vertex(0f, -0.25f);
  vertex(0.5f, 0.25f);
  endShape(CLOSE);
}

void drawSlice() {
  noStroke();
  beginShape();
  vertex(-0.1f, 0f);
  vertex(0f, -5f);
  vertex(0.1f, 1f);
  vertex(0f, 0.1f);
  endShape(CLOSE);
}

float easeFunc(float t, float strength) {
  return pow(t, strength)/(pow(t, strength)+pow((1-t), strength));
}
