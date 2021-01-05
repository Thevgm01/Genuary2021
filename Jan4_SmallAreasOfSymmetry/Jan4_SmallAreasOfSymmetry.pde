PGraphics image;
PVector lineA, lineB;

float speedMult = 1;

boolean mouseDown = false;

void setup() {
  size(400, 400); 
  
  int squareSize = 100;
  image = createGraphics(5000, 5000);
  image.beginDraw();
  image.fill(255);
  image.noStroke();
  image.rect(image.width/2 - squareSize/2, image.height/2 - squareSize/2, squareSize, squareSize);
  image.endDraw();
  
  imageMode(CENTER);
}

void mousePressed() {  
  mouseDown = true;
}

void mouseReleased() {
  mouseDown = false; 
}

void keyPressed() {
  if(key == ' ') {
    if(speedMult > 0) speedMult = 0;
    else speedMult = 1;
  }
}

void draw() {
  background(127);

  pushMatrix();
  translate(width/2, height/2);
  float s = frameCount * 0.001f;
  scale(1 / (s + 1));
  image(image, 0, 0);
  popMatrix();

  float bobSpeed = 2f * speedMult;
  float bobScale = 100f;
  float yIntercept = sin(frameCount / (100f / bobSpeed)) * bobScale;
  float slopeX = mouseX - width/2;
  float slopeY = mouseY - height/2;
  float scale = 1000f;
  lineA = new PVector(width/2 + -scale * slopeX, height/2 + -scale * slopeY + yIntercept);
  lineB = new PVector(width/2 + scale * slopeX,  height/2 + scale * slopeY + yIntercept);

  if(mouseDown) {
    reflect();
    mouseDown = false; 
  }
  
  stroke(0);
  strokeWeight(2f);
  line(lineA.x, lineA.y, lineB.x, lineB.y);
}

int getSide(PVector A, PVector B, PVector point) {
  return sign((B.x - A.x) * (point.y - A.y) - (B.y - A.y) * (point.x - A.x));
}

int sign(float num) {
  if(num < 0) return -1;
  if(num > 0) return 1;
  return 0;
}

void reflect() {
  color empty = color(0, 0);
  PVector offset = new PVector(width/2 - image.width/2, height/2 - image.height/2);
  for(int i = 0; i < image.pixels.length; ++i) {
    if(image.pixels[i] != empty) {
      if(getSide(lineA, lineB, new PVector(i % image.width + offset.x, i / image.width + offset.y)) > 0) {
        image.pixels[i] = empty;
      }
    }
  }
  image.updatePixels();

  PImage reflection = image.copy();
  
  PVector midpoint = lineA.add(lineB).div(2).sub(offset);
  float angle = atan2(lineB.y, lineB.x);
  
  image.beginDraw();
  image.pushMatrix();
  image.translate(midpoint.x, midpoint.y);
  image.rotate(angle);
  image.scale(1, -1);
  image.rotate(-angle);
  image.translate(-midpoint.x, -midpoint.y);
  image.image(reflection, 0, 0);
  image.popMatrix();
  image.endDraw();
}
