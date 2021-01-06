void setup() {
  size(400, 400);
}

void draw() {
  background(255);
  beginShape();
  for(int i = 0; i < 200; i += 2) {
    float angle = frameCount * i / 400f;
    vertex(cos(angle) * i + 200, sin(angle) * i + 200);
  }
  endShape();
}
