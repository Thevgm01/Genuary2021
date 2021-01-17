TreeNode start;

void step() {
}

void setup() {
  size(600, 600); 
  colorMode(HSB);
  
  noFill();
  stroke(255);
  strokeWeight(3);
  
  start = new TreeNode(-PI/2, 60, 3, 100);
  start.branch(PI/5, 30f, 0.9f, 8);
}

void draw() {
  float windDirection = atan2(mouseY - height/2, mouseX - width/2);
  float strength = map(dist(mouseX, mouseY, width/2, height/2), 0, width, 0, 0.3f);
  start.step(windDirection, strength);

  background(0);
  //fill(0, 100);
  //noStroke();
  //rect(0, 0, width, height);
  
  fill(0);
  stroke(100);
  strokeWeight(2);
  line(width/2, height/2, mouseX, mouseY);
  circle(mouseX, mouseY, 20);
      
  translate(width/2, height/2 + 100);
  pushMatrix();
  translate(0, 100);
  start.draw();
  popMatrix();
  
  //saveFrame("frames/" + frameCount);
}

void keyPressed() {
  if(key == ' ') {
    start = generateTree();
  }
}

TreeNode generateTree() {
  float startLength = random(20) + 40;
  float startWeight = random(2) + 2;
  float startHue = random(255);
  TreeNode tree = new TreeNode(-PI/2, startLength, startWeight, startHue);
  float angleDiff = random(PI/4);
  float hueDiff = random(20) + 10;
  float scaleChange = random(0.2f) + 0.8f;
  int numBranches = (int)random(6) + 4;
  tree.branch(angleDiff, hueDiff, scaleChange, numBranches); 
  return tree;
}
