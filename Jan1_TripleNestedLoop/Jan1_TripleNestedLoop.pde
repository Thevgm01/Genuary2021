final int maxTorusSegments = 50;
final int maxLargeCircleSegments = 20;
final int maxCircleSegments = 10;

int torusSegments = 0;
int largeCircleSegments = 0;
int circleSegments = 0;

final int torusRadius = 100;
final int largeCircleRadius = 50;
final int circleRadius = 5;

float torusFrac = 0;
float largeCircleFrac = 0;
float circleFrac = 0;

float torusSpeed = 0.0125f;
float largeCircleSpeed = 0.025f;
float circleSpeed = 0.05f;

float torusAngle = 0;
float largeCircleAngle = 0;
float circleAngle = 0;

float torusAngleSpeed = 0.025;
float largeCircleAngleSpeed = 0.05;
float circleAngleSpeed = 0.1f;

void setup() {
  size(400, 400, P3D); 
}

void draw() {
  background(0);
  
  noFill();
  stroke(255);
  strokeWeight(1);
  
  translate(width/2, height/2, 0);
  rotateY(torusAngle);
  for(int i = 0; i < torusSegments; ++i) {
    pushMatrix();
    rotateY(TWO_PI * i / maxTorusSegments);
    translate(torusRadius, 0, 0);
    rotateZ(largeCircleAngle);
    for(int j = 0; j <= largeCircleSegments; ++j) {
      pushMatrix();
      rotateZ(TWO_PI * j / maxLargeCircleSegments);
      translate(largeCircleRadius, 0, 0);
      rotateZ(circleAngle);
      beginShape();
      for(int k = 0; k <= circleSegments; ++k) {
        float angle = TWO_PI * k / maxCircleSegments;
        vertex(cos(angle) * circleRadius, sin(angle) * circleRadius);
      }
      endShape();
      popMatrix();
    }
    popMatrix();
  }
  saveFrame("frames/" + frameCount);
  
  torusFrac       += torusSpeed;
  largeCircleFrac += largeCircleSpeed;
  circleFrac      += circleSpeed;
  
  torusAngle       += torusAngleSpeed;
  largeCircleAngle += largeCircleAngleSpeed;
  circleAngle      += circleAngleSpeed;
  
  torusSegments       = ceil(maxTorusSegments        * (cos(torusFrac) + 1) / 2);
  largeCircleSegments = ceil(maxLargeCircleSegments  * (cos(largeCircleFrac) + 1) / 2) - 1;
  circleSegments      = ceil((maxCircleSegments - 1) * (cos(circleFrac) + 1) / 2) + 1;
}
