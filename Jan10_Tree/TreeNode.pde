class TreeNode {
  TreeNode parent, childL, childR;
  
  float angle;
  private float targetAngle;
  float length;
  float weight;
  float hue;

  TreeNode(float a, float l, float w, float h) {
    targetAngle = a;
    angle = a;
    length = l;
    weight = w;
    if(h < 0) h += 255;
    if(h >= 255) h -= 255;
    hue = h;
  }
  
  TreeNode(TreeNode p, float a, float l, float w, float h) {
    this(a, l, w, h);
    parent = p;
  }
  
  void step(float windAngle, float windStrength) {
    angle -= sin(angle - windAngle) * windStrength;
    angle = lerp(angle, targetAngle, 0.1f);
    
    if(childL != null) childL.step(windAngle, windStrength);
    if(childR != null) childR.step(windAngle, windStrength);
  }
  
  void branch(float angleDiff, float hueDiff, float scale, int count) {
    childL = new TreeNode(this, angle - angleDiff, length * scale, weight * scale, hue - hueDiff);
    childR = new TreeNode(this, angle + angleDiff, length * scale, weight * scale, hue + hueDiff); 
    
    if(count > 0) {
      childL.branch(angleDiff * scale, hueDiff * scale, scale, count - 1);
      childR.branch(angleDiff * scale, hueDiff * scale, scale, count - 1);
    }
  }
  
  void draw() {    
    stroke(hue, 255, 255);
    //strokeWeight(weight);
    
    pushMatrix();
    if(parent == null) rotate(angle);
    else rotate(angle - parent.angle);
    //if(childL == null && childR == null) circle(length, 0, 10);
    line(0, 0, length, 0);
    translate(length, 0);
    
    if(childL != null) childL.draw();
    if(childR != null) childR.draw();
    popMatrix();
  }
}
