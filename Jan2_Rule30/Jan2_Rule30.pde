import peasy.*;

// 111 110 101 100 011 010 001 000
//  0   0   0   1   1   1   1   0

public static boolean[][] cellPattern = new boolean[][] 
  { { true, true, true }, { true, true, false }, { true, false, true },
    { true, false, false}, { false, true, true }, { false, true, false },
    { false, false, true }, { false, false, false } };

Timeline timeline;

float cellSize = 8f;
float cellDistance = 10f;
color cellColor;

int totalWidth = 1;

float xShift = 0;
float xSpeed = 0.05f;

PeasyCam cam;

void setup() {
  size(600, 200, P3D);
  perspective(PI / 3.0, width/height, 10, 100000);
  colorMode(HSB);
  cellColor = color(0, 255, 255);
  
  timeline = new Timeline();
  
  //cam = new PeasyCam(this, 100);
  //cam.setMinimumDistance(1);
  //cam.setMaximumDistance(10000);
  //cam.setYawRotationMode();
}

void keyPressed() {
  if(key == ' ')
    timeline.advanceAll();
}

void draw() {
  background(0);
  translate(width / 2, height / 2, 0);
  
  rotateY(map(mouseX, 0, width, 0, PI));
  
  if(keyPressed) {
    if(key == 'a') xShift -= xSpeed * totalWidth;
    if(key == 'd') xShift += xSpeed * totalWidth;
  }
  
  translate(0, -cellDistance * timeline.getHeight() / 2f, -cellDistance * totalWidth / 2f - xShift);
  //float size = 100 * cellSize / (float)cam.getDistance();
  
  timeline.drawAll(cellSize, cellDistance, cellColor);
  
  saveFrame("frames/" + frameCount);
}
