float divisionAngle = 0;
float divisionRadius = 100;

float offset = 10;
float xCut = 0;
float yCut = 0;

float translateX = 0, translateY = 0;
float scale = 1.0f;
float desiredScreenArea = 300 * 300;
float lerpSpeed = 0.05f;

Rectangle[] rects; // size should be a multiple of 4
int largestRectIndex;

void setup() {
  size(800, 800);
  rectMode(CORNERS);
  
  rects = new Rectangle[16];
  rects[0] = new Rectangle(-150, -150, 150, 150);
  largestRectIndex = 0;
}

void draw() {
  background(255);
  
  translate(width/2, height/2);
  
  Rectangle largest = rects[largestRectIndex];
  translateX = lerp(translateX, largest.cx, lerpSpeed);
  translateY = lerp(translateY, largest.cy, lerpSpeed);
  scale = lerp(scale, sqrt(desiredScreenArea / largest.a), lerpSpeed);
  
  scale(scale);
  translate(-translateX, -translateY);

  fill(0);
  noStroke();
  drawRects();
  moveApart(1/scale);
    
  xCut = cos(divisionAngle) * divisionRadius / scale + largest.cx;
  yCut = sin(divisionAngle) * divisionRadius / scale + largest.cy;
  divisionAngle += 0.01f;

  stroke(255);
  strokeWeight(3 / scale);
  float crossSize = 10/scale;
  line(xCut - crossSize, yCut, xCut + crossSize, yCut);
  line(xCut, yCut - crossSize, xCut, yCut + crossSize);
  //line(largest.cx, largest.cy, xCut, yCut);
  //circle(largest.cx, largest.cy, 10 / scale);
}

void drawRects() {
  for(int i = 0; i < rects.length; ++i) {
    if(rects[i] != null) rects[i].draw(); 
  }
}

void cut() {  
  
  Rectangle largest = rects[largestRectIndex];
  float x1 = largest.x1, y1 = largest.y1, 
        x2 = largest.x2, y2 = largest.y2;
        
  if(xCut <= x1 || xCut >= x2 || yCut <= y1 || yCut >= y2) {
    return; 
  }
  
  rects[largestRectIndex] = null;
  for(int i = rects.length - 1; i > 3; --i) {
    rects[i] = rects[i - 4]; 
  }
  
  rects[0] = new Rectangle(x1, y1, xCut, yCut);
  rects[1] = new Rectangle(xCut, y1, x2, yCut);
  rects[2] = new Rectangle(x1, yCut, xCut, y2);
  rects[3] = new Rectangle(xCut, yCut, x2, y2);
  
  float largestArea = 0;
  for(int i = 0; i < 4; ++i) {
    if(rects[i].a > largestArea) {
      largestRectIndex = i;
      largestArea = rects[i].a;
    }
  }
}

void moveApart(float speed) {
  for(int i = 0; i < rects.length; ++i) {
    if(i == largestRectIndex || rects[i] == null) continue;
    
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
  
  Rectangle(float x1, float y1, float x2, float y2) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.w = x2 - x1;
    this.h = y2 - y1;
    this.a = w * h;
    this.cx = (x1 + x2)/2;
    this.cy = (y1 + y2)/2;
  }
  
  void draw() {
    rect(x1, y1, x2, y2); 
  }
  
  void move(float x, float y) {
    x1 += x;
    y1 += y;
    x2 += x;
    y2 += y;
  }
}
