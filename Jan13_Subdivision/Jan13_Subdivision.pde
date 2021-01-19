float divisionAngle = 0;
float divisionRadius = 100;

float scale = 0.9f;
float offset = 10;
float xCut = 0;
float yCut = 0;

Rectangle[] rects;

void setup() {
  size(400, 400);
}

void draw() {
  background(255);
  
  translate(width/2, height/2);

  pushMatrix();
  scale(scale);
    
  fill(0);
  noStroke();
  //rect(-100, -100, 200, 200);
  
  scale *= 1.003f;
  popMatrix();
  
  stroke(255);
  strokeWeight(5);
  line(0, 0, cos(divisionAngle) * divisionRadius, sin(divisionAngle * divisionRadius));
}

void cut() {
  float cos = cos(divisionAngle);
  float sin = sin(divisionAngle);
  xCut = cos * divisionRadius;
  yCut = sin * divisionRadius;
  
  rects = new Rectangle[4];
  rects[0] = new Rectangle(-100, -100, xCut, yCut);
  rects[1] = new Rectangle(xCut, -100, 200 - xCut, yCut);
  rects[2] = new Rectangle(-100, yCut, xCut, 200 - yCut);
  rects[3] = new Rectangle(xCut, yCut, 200 - xCut, 200 - yCut);
}

class Rectangle {
  float x, y, w, h; 
  
  Rectangle(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void draw() {
    rect(x, y, w, h); 
  }
}
