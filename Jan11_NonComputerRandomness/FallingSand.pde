int[] sandHeight;
int[] numRemoved;

final float sandFallDuration = 1f;
int sandFallFrames = (int)(sandFallDuration * desiredFramerate);
int sandStayFrames = sandFallFrames * 3;
float sandFallAcceleration;

ArrayList<Sand> sand = new ArrayList<Sand>();

void initializeSand() {
  sandHeight = new int[width];
  float sandFallTime = sandFallDuration * desiredFramerate;
  sandFallAcceleration = height * 2 / (sandFallTime * sandFallTime);
}

void stepSand() {
  numRemoved = new int[width];
  
  for(int sandIndex = 0; sandIndex < sand.size(); ++sandIndex) {
    Sand s = sand.get(sandIndex);
    if(s.falling) {
      s.yPos += s.yVel;
      s.yVel += sandFallAcceleration;
      s.y = round(s.yPos);

      if (height - s.y < sandHeight[s.x]) {
        s.falling = false;
        s.dieFrame = frameCount + sandStayFrames;

        boolean searching = true;
        int radius = sandHeight[s.x];
        while(searching) {
          for(int i = 0; i <= radius; i++) {
            //check x + radius - i, y + i
            if(s.x + radius - i < width && sandHeight[s.x + radius - i] <= i) { 
              sandHeight[s.x] = radius; 
              s.x += radius - i; 
              searching = false; 
              break;
            } else if(i != radius && s.x - radius + i >= 0 && sandHeight[s.x - radius + i] <= i) { 
              sandHeight[s.x] = radius; 
              s.x -= radius - i; 
              searching = false; 
              break;
            }
          }
          radius++;
        }

        sandHeight[s.x]++;
        s.y = height - sandHeight[s.x];
      }
    } else if(frameCount == s.dieFrame) { // Idling for too long
      ++numRemoved[s.x];
    }
  }
  
  for(int sandIndex = 0; sandIndex < sand.size(); ++sandIndex) {
    Sand s = sand.get(sandIndex);
    s.y += numRemoved[s.x];
    if(s.y >= height) {
      --sandHeight[s.x];
      if(sandHeight[s.x] < 0)
        sandHeight[s.x] = 0;
      sand.remove(sandIndex--);
    } else {
      set(s.x, s.y + 1, color(s.hue, 255, 200));  
    }
  }
}

class Sand {
  int dieFrame = Integer.MAX_VALUE;
  boolean falling = true;
  
  int x, y;
  float yPos, yVel = 0;
  
  float hue;
  
  public Sand(int x, int y, float h) {
    this.x = x;
    this.y = y;
    this.yPos = y;
    this.hue = h;
  }
}
