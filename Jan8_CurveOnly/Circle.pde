class Circle {
  PVector center;
  float radius;
  
  Circle(float x, float y, float r) {
    center = new PVector(x, y);
    radius = r; 
  }
  
  Circle(PVector c, float r) {
    center = c;
    radius = r;
  }
  
  int getSide(PVector point) {
    return sign(PVector.dist(center, point) - radius);
    //PVector diff = PVector.sub(center, point);
    //return sign(diff.x * diff.x + diff.y * diff.y - radius * radius);
  }
  
  void draw() {
    circle(center.x, center.y, radius * 2); 
  }
  
  void draw(float startAngle, float arcLength) {
    arc(center.x, center.y, radius * 2, radius * 2, startAngle, startAngle + arcLength);
  }
  
  Circle copy() {
    return new Circle(center.copy(), radius); 
  }
}
