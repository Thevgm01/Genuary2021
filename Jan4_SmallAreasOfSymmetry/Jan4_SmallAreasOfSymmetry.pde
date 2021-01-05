PGraphics image;
PVector lineA, lineB;

float speedMult = 1;

boolean mouseDown = false;

void setup() {
  size(600, 600); 
  
  int squareSize = 100;
  image = createGraphics(5000, 5000);
  image.beginDraw();
  image.fill(255);
  image.noStroke();
  image.rect(image.width/2 - squareSize/2, image.height/2 - squareSize/2, squareSize, squareSize);
  image.endDraw();
  
  imageMode(CENTER);
  image.imageMode(CENTER);
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

  float s = 1 / (frameCount * 0.001f + 1);

  translate(width/2, height/2);
  scale(s);
  image(image, 0, 0);

  float bobSpeed = 2f * speedMult;
  float bobScale = 100f / s;
  float yIntercept = sin(frameCount / (100f / bobSpeed)) * bobScale;
  float slopeX = mouseX - width/2;
  float slopeY = mouseY - height/2;
  float scale = 1000f;
  lineA = new PVector(-scale * slopeX, -scale * slopeY + yIntercept);
  lineB = new PVector( scale * slopeX,  scale * slopeY + yIntercept);
  PVector normal = new PVector(-slopeY, slopeX).setMag(50);

  if(mouseDown) {
    reflect();
    mouseDown = false; 
  }
  
  stroke(0);
  strokeWeight(2f / s);
  line(lineA.x, lineA.y, lineB.x, lineB.y);
  line(0, yIntercept, normal.x, normal.y + yIntercept);
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
  int highestX = 0, highestY = 0, lowestX = image.width, lowestY = image.height;
  
  color empty = color(0, 0);
  PVector offset = new PVector(image.width/2, image.height/2);
  for(int i = 0; i < image.pixels.length; ++i) {
    if(((image.pixels[i] >> 24) & 0xff) > 0) { // If the pixel is non-transparent
      int x = i % image.width,
          y = i / image.width;
          
      if(x > highestX) highestX = x;
      if(x < lowestX) lowestX = x;
      if(y > highestY) highestY = y;
      if(y < lowestY) lowestY = y;
          
      if(getSide(lineA, lineB, new PVector(x - offset.x, y - offset.y)) > 0) {
        image.pixels[i] = empty;
      }
    }
  }
  image.updatePixels();

  PImage reflection = image.get(lowestX, lowestY, highestX - lowestX, highestY - lowestY);
  //PImage reflection = image.get();
  
  PVector midpoint = lineA.add(lineB).div(2f);
  float angle = atan2(lineB.y, lineB.x);
  
  image.beginDraw();
  image.pushMatrix();
  image.translate(image.width/2 + midpoint.x, image.height/2 + midpoint.y);
  image.rotate(angle);
  image.scale(1, -1);
  image.rotate(-angle);
  image.translate(-midpoint.x, -midpoint.y);
  image.image(reflection, 0, 0);
  image.popMatrix();
  image.endDraw();
}
