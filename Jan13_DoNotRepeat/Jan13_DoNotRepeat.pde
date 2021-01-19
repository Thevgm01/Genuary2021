float G = 1;
Body[] bodies;

float timeScale = 0f;
float maxTimescale = 1f;

String text = "Do not repeat.";
int textHeight = 55;
int textWidth;
int textSeparation = 10;

void setup() {
  size(400, 400);
  frameRate(90);
  colorMode(HSB);
  
  PFont font = null;
  String[] fontList = PFont.list();
  for(int i = 0; i < fontList.length; ++i) {
    if(fontList[i].contains("Sugarpunch")) {
      font = createFont(fontList[i], textHeight);
      break;
    }
  }
  //PFont font = createFont("BalsamiqSans-Regular.ttf", textHeight);
  //PFont font = createFont("Cute Notes.ttf", textHeight);
  textFont(font);
  //textSize(textHeight);
  textAlign(CENTER, CENTER);
  textWidth = round(textWidth(text));
  
  resetBodies();
  
  background(0);
}

void resetBodies() {
  String[] words = text.split(" ");
  
  bodies = new Body[words.length];
  float textWidth = textWidth(text);
  float startX = -textWidth/2 + 12.5f;
  for(int i = 0; i < bodies.length; ++i) {
    String s = words[i];
        
    bodies[i] = new Body(2, startX, 0, 0, random(2) - 1);
    bodies[i].x *= 1f;
    bodies[i].vy *= 5;
    bodies[i].text = s;
    //bodies[i].col = color(map(i, 0, bodies.length, 0, 255), 255, 255);
    bodies[i].col = color(map(i, 0, bodies.length - 1, 100, 255));
    //bodies[i].col = color(random(128) + 128);
    //bodies[i].col = color(255);

    bodies[i].w = textWidth(s);
    startX += bodies[i].w * 2 - 25;
  }
}

void draw() {
  for(int i = 0; i < bodies.length - 1; ++i) {
    for(int j = i + 1; j < bodies.length; ++j) {
      float xDiff = bodies[j].x - bodies[i].x;
      float yDiff = bodies[j].y - bodies[i].y;
      float rSquared = xDiff * xDiff + yDiff * yDiff;
      float force = timeScale * G * bodies[i].mass * bodies[j].mass / rSquared;
      bodies[i].vx += xDiff * force;
      bodies[i].vy += yDiff * force;
      bodies[j].vx -= xDiff * force;
      bodies[j].vy -= yDiff * force;
    }
  }
  
  //fill(0, map(timeScale, 0, 1, 50, 10));
  fill(0, 40);
  noStroke();
  rect(0, 0, width, height);
  translate(width/2, height/2);
  
  for(int i = 0; i < bodies.length; ++i) { 
    bodies[i].x += bodies[i].vx * timeScale;
    bodies[i].y += bodies[i].vy * timeScale;
    
    //edgeWrap(bodies[i]);
    edgeBounce(bodies[i]);

    fill(bodies[i].col);
    text(bodies[i].text, bodies[i].x, bodies[i].y);
  }
  
  if(timeScale < maxTimescale) {
    timeScale = tan(frameCount / 1500f);
    if(timeScale > maxTimescale) timeScale = maxTimescale;
  }
  
  saveFrame("frames/" + frameCount);
  if(frameCount >= 90 * 30) exit();
}

void edgeWrap(Body b) {
  int edge = 30;
  if(b.x < -width/2 - edge) b.x += width + edge;
  else if(b.x >= width/2 + edge) b.x -= width + edge;
  if(b.y < -height/2 - edge) b.y += height + edge;
  else if(b.y >= height/2 + edge) b.y -= height + edge;
}

void edgeBounce(Body b) {
  if(b.x < -width/2 + b.w/2 || b.x + b.w/2 >= width/2) b.vx *= -1;
  if(b.y - textHeight/2f < -height/2 || b.y + textHeight/2f >= height/2) b.vy *= -1;
}

class Body {
  float mass;
  float x, y, vx, vy;
  String text;
  color col;
  float w;
  
  Body(float mass, float x, float y, float vx, float vy) {
    this.mass = mass;
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
  }
}
