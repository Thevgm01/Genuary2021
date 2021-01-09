Vision vision;
Circle[] obstacles;

final int NUM_RAYS = 150;
final int LOOPS = 3;
final int ITERATIONS_PER_LOOP = 50;
final float RAY_DISTANCE = 150;
int NUM_OBSTACLES = 0;

int oneAtATime = -1;

void setup() {
  size(600, 600);
  ellipseMode(CENTER);
  
  initializeTrigTable();
  
  vision = new Vision(NUM_RAYS);
  PVector visionHelper = new PVector(RAY_DISTANCE, 0);
  for(int i = 0; i < NUM_RAYS; ++i) {
    vision.addCircle(visionHelper);
    visionHelper.rotate(2 * PI / NUM_RAYS);
  }
  
  randomizeObstacles(5);
}

void randomizeObstacles(int num) {
  NUM_OBSTACLES = 5;
  obstacles = new Circle[NUM_OBSTACLES];
  for(int i = 0; i < obstacles.length; ++i) {
    obstacles[i] = new Circle(random(width) - width/2, random(height) - height/2, random(80) + 20);
  }
}

void keyPressed() {
  if(key == ' ') {
    randomizeObstacles(5); 
  } else if(key == 'd') {
    ++oneAtATime;
  } else if(key == 'a') {
    --oneAtATime;
    if(oneAtATime < -1) oneAtATime = -1;
  }
}

void draw() {
  background(0);
  noFill();
  stroke(255);
  
  translate(width/2, height/2);
  vision.center.lerp(new PVector(mouseX - width/2, mouseY - height/2), 0.33f);

  strokeWeight(3);
  if(oneAtATime == -1) vision.drawVision(obstacles);
  else vision.drawVision(obstacles, oneAtATime);
  strokeWeight(3);
  if(NUM_OBSTACLES > 0)
    for(Circle c : obstacles)
      c.draw();
  
  translate(vision.center.x, vision.center.y);
  stroke(0);
  line(-10, 0, 10, 0);
  line(0, -10, 0, 10);
  
  //saveFrame("frames/" + frameCount);
}

// Go forward until you go inside (or outside) the circle
// then go back in smaller increments
// then go forward again in even smaller increments
float getArcIntersectionAngle(Circle c, Circle arc, float startAngle) {
  final float TOTAL_ANGLE = PI;
  if(PVector.dist(c.center, arc.center) > c.radius + arc.radius)
    return TOTAL_ANGLE;

  int startSide = 0;
  int[] tracker = new int[LOOPS];
  int trackerIndex = 0;
  while(tracker[trackerIndex] <= ITERATIONS_PER_LOOP) {
    float angle = startAngle +
      tracker[0] * TOTAL_ANGLE/ITERATIONS_PER_LOOP - 
      tracker[1] * TOTAL_ANGLE/(ITERATIONS_PER_LOOP * ITERATIONS_PER_LOOP) + 
      tracker[2] * TOTAL_ANGLE/(ITERATIONS_PER_LOOP * ITERATIONS_PER_LOOP * ITERATIONS_PER_LOOP);
      
    PVector testPoint = getTestPoint(arc, angle);
    if(oneAtATime >= 0) point(testPoint.x, testPoint.y);
    
    int newSide = c.getSide(testPoint);
    if(newSide == 0) return angle - startAngle;
    
    if(tracker[0] == 0) { // Only run this the first time
      startSide = newSide;
    } else if(newSide != startSide) {
      startSide = newSide;
      if(trackerIndex < LOOPS - 1) ++trackerIndex;
      else return angle - startAngle;
    }
    
    ++tracker[trackerIndex];
  }
  return TOTAL_ANGLE;
}

PVector getTestPoint(Circle c, float angle) {
  return new PVector(trigTable(cosTable, angle), trigTable(sinTable, angle)).mult(c.radius).add(c.center);
}

int sign(float num) {
  if(num < 0) return -1;
  if(num > 0) return 1;
  return 0;
}
