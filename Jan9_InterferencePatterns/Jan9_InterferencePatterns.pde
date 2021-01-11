float MAIN_SCALE = 0.15f;
float MAIN_SPEED = 0.5f;
float angle = 0;

void setup() {
  size(400, 400); 
  
  initializeTrigTable();
}

void draw() {
  background(0);
  color white = color(255);
  
  loadPixels();
  for(int i = 0; i < pixels.length; ++i) {
    
    int x = i % width,
        y = i / width;

    int a = (int)
      map(sinTable(dist(
              cosTable(angle) * width/3 + width/2, 
              sinTable(angle) * height/3 + height/2,
              x, y) * MAIN_SCALE
          - angle * MAIN_SPEED),
      -1, 1, 0, 255);

    int b = (int)
      map(sinTable(dist(
              sinTable(angle * 2) * width/5 + width/2, 
              cosTable(angle * 2) * height/5 + height/2,
              x, y) * MAIN_SCALE
          - angle * MAIN_SPEED),
      -1, 1, 0, 255);

    if(a + b > map(sinTable(angle), -1, 1, 150, 350)) pixels[i] = white;
    //if(a + b >= 300) pixels[i] = white;
  }
  updatePixels();
  
  //println(frameRate);
  
  angle += TWO_PI / (60 * 8);
  saveFrame("frames/" + frameCount);
}
