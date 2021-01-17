uniform mat4 transform;
uniform mat4 texMatrix;

attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform float value;

void main() {
  //angle = sin(constrain(offsetAngle - i * segmentOffset, 0, PI)) / flatness;
  float angle = (value + texCoord.x * 2) * 3.14159 * 2;
  float cos = cos(angle);
  float sin = sin(angle);
  
  vec4 delta = vec4(0, 0, sin * 5, 0);
  
  //vec4 delta = vec4(0, 0, texCoord.x * texCoord.x, 0) * 1000;
  gl_Position = transform * (position + delta);
    
  vertColor = color;
  vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
}
