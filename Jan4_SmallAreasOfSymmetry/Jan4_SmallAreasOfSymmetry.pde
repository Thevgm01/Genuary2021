PImage img;
PVector lineA, lineB;

float speedMult = 1;

void setup() {
  size(400, 400); 
  
  int startSquareSize = 100;
  img = createImage(400, 400, ARGB);
  color whiteColor = color(255);
  PImage white = createImage(startSquareSize, startSquareSize, ARGB);
  for(int i = 0; i < white.pixels.length; ++i)
    white.pixels[i] = whiteColor;
  img.set(img.width/2 - white.width/2, img.width/2 - white.height/2, white);
}

void mousePressed() {
  PVector midpoint = lineA.add(lineB).div(2);
  float angle = atan2(lineB.y, lineB.x);
  println(angle);
  float cosAngle = cos(angle), sinAngle = sin(angle);
  
  color white = color(255, 255);
  color empty = color(0, 0);
  for(int i = 0; i < img.pixels.length; ++i) {
    if(img.pixels[i] != empty) {
      if(getSide(lineA, lineB, new PVector(i % img.width, i / img.width)) > 0) {
        //img.pixels[i] = white;
        float x = i % img.width - midpoint.x, y = i / img.width - midpoint.y;
        float newX = x * cosAngle - y * sinAngle, newY = x * sinAngle + y * cosAngle;
        newY = -newY;
        x = newX * -cosAngle - newY * -sinAngle + midpoint.x;
        y = newX * -sinAngle + newY * -cosAngle + midpoint.y;
        img.set(round(x), round(y), white);
        //img.pixels[round(newY * img.width + newX)] = white;
      } else {
        //img.pixels[i] = empty; 
      }
    }
  }
  img.updatePixels();
}

void keyPressed() {
  if(key == ' ') {
    if(speedMult > 0) speedMult = 0;
    else speedMult = 1;
  }
}

void draw() {
  background(127);
    
  //translate(width/2, height/2);
  //translate(-sym.width/2, -sym.height/2); // Both zero?
    
  float bobSpeed = 2f * speedMult;
  float bobScale = 100f;
  float yIntercept = sin(frameCount / (100f / bobSpeed)) * bobScale;
  float slopeX = mouseX - width/2;
  float slopeY = mouseY - height/2;
  float scale = 1000f;
  lineA = new PVector(width/2 + -scale * slopeX, height/2 + -scale * slopeY + yIntercept);
  lineB = new PVector(width/2 + scale * slopeX,  height/2 + scale * slopeY + yIntercept);

  image(img, 0, 0);
  
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
