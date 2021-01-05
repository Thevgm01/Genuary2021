PShape sym;

void setup() {
  size(400, 400); 
  
  sym = createShape();
  sym.beginShape();
  
  sym.fill(255);
  sym.stroke(0);
  sym.strokeWeight(5);

  sym.vertex(-50, -50);
  sym.vertex(-50, 50);
  sym.vertex(50, 50);
  sym.vertex(50, -50);
  sym.endShape(CLOSE);
}

void draw() {
  background(127);
    
  translate(width/2, height/2);
  //translate(-sym.width/2, -sym.height/2); // Both zero?
  shape(sym);
  
  float bobSpeed = 2f;
  float bobScale = 100f;
  float yIntercept = sin(frameCount / (100f / bobSpeed)) * bobScale;
  float slopeX = mouseX - width/2;
  float slopeY = mouseY - height/2;
  float scale = 1000f;
  PVector lineStart = new PVector(-scale * slopeX, -scale * slopeY + yIntercept);
  PVector lineEnd = new PVector(scale * slopeX, scale * slopeY + yIntercept);

  stroke(0);
  strokeWeight(2f);
  line(lineStart.x, lineStart.y, lineEnd.x, lineEnd.y);
  
  fill(255);
  noStroke();
  for(int i = 0; i < sym.getVertexCount(); ++i) {
    PVector segmentA = sym.getVertex(i);
    PVector segmentB = sym.getVertex((i + 1) % sym.getVertexCount());
    PVector intersection =
      getIntersection(lineStart, lineEnd, segmentA, segmentB);
    if(intersection != null && pointOnLine(intersection, segmentA, segmentB))
      circle(intersection.x, intersection.y, 10);
  }
}

boolean pointOnLine(PVector p, PVector A, PVector B) {
   return abs(A.dist(p) + B.dist(p) - A.dist(B)) < 0.0001f;
}

PVector getIntersection(PVector A, PVector B, PVector C, PVector D) { 
  // Line AB represented as a1x + b1y = c1 
  float a1 = B.y - A.y; 
  float b1 = A.x - B.x; 
  float c1 = a1*(A.x) + b1*(A.y); 
   
  // Line CD represented as a2x + b2y = c2 
  float a2 = D.y - C.y; 
  float b2 = C.x - D.x; 
  float c2 = a2*(C.x)+ b2*(C.y); 
   
  float determinant = a1*b2 - a2*b1; 
   
  if (determinant == 0) 
  { 
    // The lines are parallel. This is simplified 
    // by returning a pair of FLT_MAX 
    return null;
  } 
  else
  { 
    float x = (b2*c1 - b1*c2)/determinant; 
    float y = (a1*c2 - a2*c1)/determinant; 
    return new PVector(x, y); 
  } 
} 

int getSide(PVector A, PVector B, PVector point) {
  return sign((B.x - A.x) * (point.y - A.y) - (B.y - A.y) * (point.x - A.x));
}

int sign(float num) {
  if(num < 0) return -1;
  if(num > 0) return 1;
  return 0;
}

PShape splitShape(PShape curShape, PVector lineStart, PVector lineEnd) {
  PShape newShape = createShape();
  newShape.beginShape();
  
  PVector segmentA;
  PVector segmentB = sym.getVertex(0);
  for(int i = 0; i < sym.getVertexCount(); ++i) {
    segmentA = segmentB;
    segmentB = sym.getVertex((i + 1) % sym.getVertexCount());
    
    newShape.vertex(segmentA.x, segmentA.y);
    
    if(getSide(segmentA, segmentB, lineStart) > 0) {
       
    }
    
    PVector intersection =
      getIntersection(lineStart, lineEnd, segmentA, segmentB);
    if(intersection != null && pointOnLine(intersection, segmentA, segmentB))
      circle(intersection.x, intersection.y, 10);
  }
  
  return newShape;
}

PVector reflect(PVector A, PVector B, PVector point) {
  //float d = (A.x + (A.y -  
  return null;
}
