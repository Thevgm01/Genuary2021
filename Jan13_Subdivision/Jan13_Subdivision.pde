float divisionAngle = 0;
float divisionRadius = 100;

float offset = 10;
float xCut = 0;
float yCut = 0;

float desiredScreenArea = 300 * 300;
float lerpSpeed = 0.02f;

float hue = 0, sat = 200, brt = 200;
int rectangleShadowSize = 20;

int lastCutFrame = -1000;
float lastCutX, lastCutY;

float backgroundShade = 0;
float foregroundShade = 255;

Rectangle[] rects; // size should be a multiple of 4
Rectangle largest;

void setup() {
  size(800, 800, P2D);
  rectMode(CORNERS);
  colorMode(HSB);
  
  rects = new Rectangle[16];
  rects[0] = new Rectangle(-150, -150, 150, 150, color(hue, sat, brt));
  largest = rects[0];
}

void draw() {
  background(backgroundShade);
  
  translate(width/2, height/2);
  
  float desiredScale = sqrt(desiredScreenArea / largest.a);
  
  scaleRects((desiredScale - 1) * lerpSpeed + 1);
  moveRects(-largest.cx * lerpSpeed, -largest.cy * lerpSpeed);
  moveRectsApart(1);
  
  drawRects();

  xCut = cos(divisionAngle) * divisionRadius + largest.cx;
  yCut = sin(divisionAngle) * divisionRadius + largest.cy;
  divisionAngle += PI/128;

  stroke(255);
  strokeWeight(3);
  float crossSize = 10;
  pushMatrix();
  //translate(xCut - largest.cx, yCut - largest.cy);
  translate(xCut, yCut);
  line(-crossSize, 0, crossSize, 0);
  line(0, -crossSize, 0, crossSize);
  popMatrix();
  
  float lastCutThickness = map(frameCount - lastCutFrame, 0, 10, 20, 0);
  if(lastCutThickness > 0) {
    fill(foregroundShade);
    noStroke();
    pushMatrix();
    translate(lastCutX - largest.cx * 0.67f, lastCutY - largest.cy * 0.67f);
    rect(-width, -lastCutThickness, width, lastCutThickness);
    rect(-lastCutThickness, -height, lastCutThickness, height);
    popMatrix();
  }
}

void cut() {  
  
  float x1 = largest.x1, y1 = largest.y1, 
        x2 = largest.x2, y2 = largest.y2;
        
  if(xCut <= x1 || xCut >= x2 || yCut <= y1 || yCut >= y2) {
    return; 
  }
  
  for(int i = rects.length - 1; i > 3; --i) {
    if(rects[i-4] != largest) {
      rects[i] = rects[i-4]; 
    }
  }
  
  hue = (hue + 20) % 256;
  
  rects[0] = new Rectangle(x1, y1, xCut, yCut, color(hue, sat, brt));
  rects[1] = new Rectangle(xCut, y1, x2, yCut, color(hue + 10, sat, brt));
  rects[2] = new Rectangle(x1, yCut, xCut, y2, color(hue + 20, sat, brt));
  rects[3] = new Rectangle(xCut, yCut, x2, y2, color(hue + 30, sat, brt));
  
  float largestArea = 0;
  for(int i = 0; i < 4; ++i) {
    if(rects[i].a > largestArea) {
      largest = rects[i];
      largestArea = rects[i].a;
    }
  }
  
  lastCutFrame = frameCount;
  lastCutX = xCut;
  lastCutY = yCut;
  
  float temp = backgroundShade;
  backgroundShade = foregroundShade;
  foregroundShade = temp;
}

void drawRects() {
  for(int i = rects.length - 1; i >= 0; --i) {
    if(rects[i] != null) rects[i].draw(); 
  }
}

void scaleRects(float amount) {
  for(int i = 0; i < rects.length; ++i) {
    if(rects[i] != null) rects[i].scale(amount); 
  }
}

void moveRects(float x, float y) {
  for(int i = 0; i < rects.length; ++i) {
    if(rects[i] != null) rects[i].move(x, y); 
  }
}

void moveRectsApart(float speed) {
  for(int i = 0; i < rects.length; ++i) {
    if(rects[i] == null || rects[i] == largest) continue;
    
    switch(i % 4) {
      case 0: rects[i].move(-speed, -speed); break;
      case 1: rects[i].move(speed, -speed); break;
      case 2: rects[i].move(-speed, speed); break;
      case 3: rects[i].move(speed, speed); break;
    }
  }
}

void keyPressed() {
  if(key == ' ') cut(); 
}

class Rectangle {
  float x1, y1, x2, y2, w, h, a, cx, cy;
  color c;
  
  Rectangle(float x1, float y1, float x2, float y2, color c) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.c  = c;
    calculateAttributes();
  }
  
  private void calculateAttributes() {
    w = x2 - x1;
    h = y2 - y1;
    a = w * h;
    cx = (x1 + x2)/2;
    cy = (y1 + y2)/2;
  }
  
  void draw() {
    fill(c);
    noStroke();
    rect(x1, y1, x2, y2); 
    
    noFill();
    strokeWeight(1);
    for(int i = 0; i < rectangleShadowSize; ++i) {
       stroke(c, map(i, 0, rectangleShadowSize - 1, 128, 0));
       rect(x1 - i, y1 - i, x2 + i, y2 + i);
    }
  }
  
  void scale(float amount) {
    x1 *= amount;
    y1 *= amount;
    x2 *= amount;
    y2 *= amount;
    calculateAttributes();
  }
  
  void move(float x, float y) {
    x1 += x;
    y1 += y;
    x2 += x;
    y2 += y;
    cx += x;
    cy += y;
  }
}
