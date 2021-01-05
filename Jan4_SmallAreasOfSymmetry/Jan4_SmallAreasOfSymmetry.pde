PGraphics graphic;
PVector imageOffset;
PVector lineA, lineB;

PImage rainbow;

boolean mouseDown = false;
PVector mouseStart, mouseEnd;
int reflectDirection = 1;

float globalScale = 1;

enum ColorShift {
  STATIC,
  PER_REFLECT,
  PER_PIXEL
}
ColorShift colorShift = ColorShift.PER_PIXEL;

int lastHue = 0;
int hueChange = 20;
int sat = 150, brt = 255;

color backgroundColor = color(127);
color uiColor = color(0);

void setup() {
  size(600, 600); 
  colorMode(HSB);

  int squareSize = 100;
  graphic = createGraphics(10000, 10000);
  imageOffset = new PVector(graphic.width/2, graphic.height/2);
  graphic.beginDraw();
  graphic.fill(color(lastHue, sat, brt));
  graphic.noStroke();
  graphic.rect(imageOffset.x - squareSize/2, imageOffset.y - squareSize/2, squareSize, squareSize);
  graphic.endDraw();
  
  rainbow = loadImage("rainbow.jpg");
  rainbow.resize(width, height);
}

PVector getMousePos() {
  return new PVector(mouseX - width/2, mouseY - height/2).div(globalScale);
}

void mousePressed() {
  if(mouseButton == LEFT) {
  mouseDown = true;
  mouseStart = getMousePos();
  } else if(mouseButton == RIGHT) {
    reflectDirection = -reflectDirection;
  }
}

void mouseReleased() {
  if(mouseButton == LEFT) {
    mouseDown = false;
    if(lineA != null && lineB != null) {
      reflect(); 
    }
  }
}

void draw() {
  //background(backgroundColor);
  background(rainbow);
  fill(0, 127);
  noStroke();
  rect(0, 0, width, height);

  //globalScale = 1 / (frameCount * 0.001f + 1);
  if(globalScale * graphic.width > width) {
    globalScale *= 0.999f;
  }

  imageMode(CENTER);
  translate(width/2, height/2);
  scale(globalScale);
  image(graphic, 0, 0);

  noFill();
  stroke(uiColor);
  strokeWeight(2f / globalScale);
  float mouseRadius = 25 / globalScale;

  if(mouseDown) {
    mouseEnd = getMousePos();
    
    circle(mouseStart.x, mouseStart.y, mouseRadius * 2);
    
    if(PVector.dist(mouseStart, mouseEnd) < mouseRadius) {
      lineA = null;
      lineB = null;
      line(mouseStart.x, mouseStart.y, mouseEnd.x, mouseEnd.y);
    } else {
      PVector midpoint = PVector.add(mouseStart, mouseEnd).div(2);
      float slopeX = mouseEnd.x - mouseStart.x;
      float slopeY = mouseEnd.y - mouseStart.y;
      float scale = 1000f;
      lineA = new PVector(-scale * slopeX, -scale * slopeY).add(midpoint);
      lineB = new PVector( scale * slopeX,  scale * slopeY).add(midpoint);      
      line(lineA.x, lineA.y, lineB.x, lineB.y);
      
      PVector normal = new PVector(-slopeY, slopeX).setMag(50 * reflectDirection);
      line(midpoint.x, midpoint.y, midpoint.x + normal.x, midpoint.y + normal.y);
    }
  }
  
  saveFrame("frames/" + frameCount);
}

int getSide(PVector A, PVector B, float x, float y) {
  return sign((B.x - A.x) * (y - A.y) - (B.y - A.y) * (x - A.x));
}

int sign(float num) {
  if(num < 0) return -1;
  if(num > 0) return 1;
  return 0;
}

void reflect() {
  PVector midpoint = PVector.add(lineA, lineB).div(2f);
  float angle = atan2(lineB.y, lineB.x);

  // Delete all pixels on one side of the line
  // to prevent ugly overlapping

  // Shift the line that determines where pixels get cut off
  // to avoid the ugly seam that sometimes appears
  PVector lineShift = new PVector(-sin(angle), cos(angle)).mult(2 * reflectDirection);
  PVector shiftedLineA = PVector.add(lineA, lineShift);
  PVector shiftedLineB = PVector.add(lineB, lineShift);
  
  // Keep track of where the pixels started and ended to make copying easier
  int highestX = 0, highestY = 0, lowestX = graphic.width, lowestY = graphic.height;
  
  graphic.loadPixels();
  color empty = color(0, 0);
  for(int i = 0; i < graphic.pixels.length; ++i) {
    if(getAlpha(graphic.pixels[i]) > 0) { // If the pixel is non-transparent
      int x = i % graphic.width,
          y = i / graphic.width;
    
      if(x > highestX) highestX = x;
      if(x < lowestX) lowestX = x;
      if(y > highestY) highestY = y;
      if(y < lowestY) lowestY = y;
          
      if(getSide(shiftedLineA, shiftedLineB, x - imageOffset.x, y - imageOffset.y) == reflectDirection) {
        graphic.pixels[i] = empty;
      }
    }
  }

  /*
  // Attempt to speed up by searching a larger area at first
  int searchRadius = 10;
  for(int search_i = searchRadius; search_i < image.width; search_i += searchRadius) {
    for(int search_j = searchRadius; search_j < image.height; search_j += searchRadius) {
      if(((image.pixels[search_j * image.width + search_i] >> 24) & 0xff) > 0) { // If the pixel is non-transparent
        for(int i = search_i - searchRadius; i < search_i + searchRadius; ++i) {
          for(int j = search_j - searchRadius; j < search_j + searchRadius; ++j) {
            if(((image.pixels[j * image.width + i] >> 24) & 0xff) > 0) { // If the pixel is non-transparent
              if(i > highestX) highestX = i;
              if(i < lowestX) lowestX = i;
              if(j > highestY) highestY = j;
              if(j < lowestY) lowestY = j;
                  
              if(getSide(lineA, lineB, new PVector(i - offset.x, j - offset.y)) > 0) {
                image.pixels[j * image.width + i] = empty;
                //image.set(i, j, color(255, 0, 0, 255));
              }
            }
          }
        }
      }
    }
  }
  */
  graphic.updatePixels();

  // I can't for the LIFE of me figure out why this doesn't work
  // It works perfectly when I grab the entire screen, or even a defined area
  // But as soon as the region begins to change, it screws up
  
  //PImage reflection = image.get(lowestX, lowestY, highestX - lowestX + 1, highestY - lowestY + 1); // Breaks
  
  //PImage reflection = image.get(2000 - (int)random(300), 2000, 1000, 1000); // Breaks
  
  //int rand = (int)random(300);
  //PImage reflection = image.get(2000 - rand, 2000, 1000 + rand * 2, 1000); // ...Perfect? Doesn't need to be square...
  //PImage reflection = image.get(2000 - rand, 2000 - rand, 1000 + rand * 2, 1000 + rand * 2); // Perfect?
  //PImage reflection = image.get(2000, 2000 - rand, 1000, 1000 + rand * 2); // Also perfect, h not different from w
  
  //PImage reflection = image.get(2000, 2000, 1000, 1000); // Perfect
  //PImage reflection = image.get(); // Perfect
  //PImage reflection = image.copy(); // Perfect
  
  // Does the get *itself* need to be centered??
  
  float largestX = imageOffset.x - lowestX;
  if(highestX - imageOffset.x > largestX) largestX = highestX - imageOffset.x;
  float largestY = imageOffset.y - lowestY;
  if(highestY - imageOffset.y > largestY) largestY = highestY - imageOffset.y;
  PImage reflection = graphic.get(
    floor(imageOffset.x - largestX), 
    floor(imageOffset.y - largestY), 
    ceil(largestX * 2), 
    ceil(largestY * 2)); // PERFECT
    
  //println(reflection.width + ", " + reflection.height);
  //println(lowestX + ", " + lowestY + " x " + highestX + ", " + highestY);

  //println(floor(imageOffset.x - largestX));
  //println(lowestX);
  
  // I don't have a fuckin' clue, but it seems to work now, with the performance gain

  switch(colorShift) {
    case PER_REFLECT:
      lastHue += hueChange;
      color newColor = color(lastHue, sat, brt);
      for(int i = 0; i < reflection.pixels.length; ++i) {
        if(getAlpha(reflection.pixels[i]) > 0) {
          reflection.pixels[i] = color(newColor, getAlpha(reflection.pixels[i])); 
        }
      }
      break;
    case PER_PIXEL:
      for(int i = 0; i < reflection.pixels.length; ++i) {
        if(getAlpha(reflection.pixels[i]) > 0) {
          reflection.pixels[i] = color(hue(reflection.pixels[i]) + hueChange, sat, brt, getAlpha(reflection.pixels[i])); 
        }
      }
      break;
    default:
      break;
  }

  graphic.imageMode(CENTER);

  graphic.beginDraw();
  graphic.pushMatrix();
  graphic.translate(imageOffset.x, imageOffset.y);
  graphic.translate(midpoint.x, midpoint.y);
  graphic.rotate(angle);
  graphic.scale(1, -1);
  graphic.rotate(-angle);
  graphic.translate(-midpoint.x, -midpoint.y);
  graphic.image(reflection, 0, 0);
  graphic.popMatrix();
  graphic.endDraw();
}

int getAlpha(color c) {
  return (c >> 24) & 0xff;
}
