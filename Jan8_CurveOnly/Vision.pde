class Vision {
  Circle[] circles;
  PVector[] originalViewPositions;
  float[] angles;
  
  PVector center;
  float angle;
   
  private int counter = -1;
  
  Vision(int rays) {
    circles = new Circle[rays];
    originalViewPositions = new PVector[rays];
    angles = new float[rays];
    
    center = new PVector(0, 0);
  }
  
  void addCircle(float x, float y) {
    addCircle(new PVector(x, y)); 
  }
  
  void addCircle(PVector center) {
    float radius = PVector.dist(this.center, center);
    circles[++counter] = new Circle(center.copy(), radius);
    
    PVector diff = PVector.sub(this.center, center);
    angles[counter] = atan2(diff.y, diff.x);
  }
  
  float getShortestAngle(Circle[] obstacles, int visionIndex) {
    float startAngle = angles[visionIndex];
    float shortest = 999;
    for(int i = 0; i < NUM_OBSTACLES; ++i) {
      Circle copiedObstacle = obstacles[i].copy();
      copiedObstacle.center.sub(center);
      float angle = getArcIntersectionAngle(copiedObstacle, circles[visionIndex], startAngle);
      if(angle < shortest)
        shortest = angle;
    }
    return shortest;
  }
  
  void drawVision(Circle[] obstacles) {
    pushMatrix();
    translate(center.x, center.y);
    for(int i = 0; i <= counter; ++i) {
      float startAngle = angles[i];
      float angle = getShortestAngle(obstacles, i);
      circles[i].draw(startAngle, angle);
    }
    popMatrix();
  }
  
  void drawVision(Circle[] obstacles, int ray) {
    pushMatrix();
    translate(center.x, center.y);
    float startAngle = angles[ray];
    float angle = getShortestAngle(obstacles, ray);
    circles[ray].draw(startAngle, angle);
    popMatrix();
  }
}
