import peasy.*;
import http.requests.*;
import java.io.*;

PeasyCam cam;

PImage img;
PImage nextImg;
PShape page;
PShader shade;

void setup() {
  size(400, 400, P3D);
  
  cam = new PeasyCam(this, 100);
  cam.setYawRotationMode();
  
  page = createPage(100, 32, img);
  shade = loadShader("fragment.glsl", "vertex.glsl");
  
  loadNewImage();
  nextImage();
}

void draw() {
  background(0);
  
  resetShader();
  fill(0, 100, 0);
  noStroke();
  pushMatrix();
  translate(0, 200, 0);
  scale(500, 1, 500);
  box(10);
  popMatrix();
  
  translate(-50, 0, 0);
  
  noFill();
  stroke(255);
  strokeWeight(2000 / (float)cam.getDistance());
  line(-5, -50, -5, 200);
  
  //shade.set("value", (float)mouseX / width);
  shade.set("value", (frameCount % 60) / 60f);
  shader(shade);
    
  //rotateY(angle);
  //image(img, 0, 0);
  shape(page);  
  //angle += 0.01;
  
  saveFrame("frames/" + frameCount);
}

String downloadImage() {
  GetRequest imageUrl = new GetRequest("http://inspirobot.me/api?generate=true");
  imageUrl.send();
  //println(imageUrl.getContent());
  GetRequest image = new GetRequest(imageUrl.getContent());
  image.send();
  String name = "images/" + imageUrl.getContent().split("/")[4];
  String file = sketchPath(name);
  try {
    FileOutputStream fos = new FileOutputStream(file);
    BufferedOutputStream bos = new BufferedOutputStream(fos);
    DataOutputStream dos = new DataOutputStream(bos);
    dos.writeBytes(image.getContent());
    dos.close();
    bos.close();
    fos.close();
    System.out.println("Successfully saved Inspirobot image: " + name);
  }
  catch (IOException e) {
    e.printStackTrace();
  }
  return name;
}

void loadNewImage() {
  nextImg = loadImage(downloadImage());
}

void nextImage() {
  if(nextImg == null) return;
  img = nextImg;
  page = createPage(100, 32, img);
  nextImg = null;
  thread("loadNewImage");
}

void keyPressed() {
  if(key == ' ') nextImage();
}

PShape createPage(float scale, int detail, PImage tex) {
  float stripWidth = scale / detail;
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  sh.texture(tex);
  for (int i = 0; i <= detail; i++) {
    float u = (float)i / detail;
    sh.normal(0, 0, 1);
    sh.vertex(i * stripWidth, -scale/2, 0, u, 0);
    sh.vertex(i * stripWidth, +scale/2, 0, u, 1);    
  }
  sh.endShape(); 
  return sh;
}
