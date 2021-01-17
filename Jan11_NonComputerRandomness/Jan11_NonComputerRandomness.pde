import processing.sound.*;

int desiredFramerate = 90;

Amplitude amp;
FFT fft;
SoundFile analysisSound;
SoundFile playSound;

int bands = 256;
float[] spectrum = new float[bands];
final float spectrumScale = 1000f;
float threshold;

int mode = 0;

boolean tryingToPlay = false;

void setup() {
  size(512, 512);
  //fullScreen(P2D);
  frameRate(desiredFramerate);
  colorMode(HSB);
  
  background(0);
  
  initializeSand();
  
  //String soundFile = "heart_afire.wav"; threshold = 0.025f;
  String soundFile = "funkorama.wav"; threshold = 0.005f;
  //String soundFile = "ticktock.wav"; threshold = 0.001f;
  analysisSound = new SoundFile(this, soundFile);
  playSound = new SoundFile(this, soundFile);
  
  Sound s = new Sound(this);
  s.volume(0.3f);
  
  amp = new Amplitude(this);
  fft = new FFT(this, bands);
  
  amp.input(analysisSound);
  fft.input(analysisSound);
  
  analysisSound.amp(1f / spectrumScale);
  analysisSound.cue(sandFallDuration);
}      

void draw() { 
  if(tryingToPlay) {
    if(!analysisSound.isPlaying())
      analysisSound.play();
    if(!playSound.isPlaying())
      playSound.play(); 
  }
  
  //background(0);
  fill(0, 50);
  rect(0, 0, width, height);
  
  if(analysisSound.isPlaying())
    getSpectrums();
  
  for(int i = 0; i < bands; ++i) {
    int hue = (frameCount + i) % 255;
    int y = -sandHeight[i];
    if(spectrum[i] > threshold) {
      switch(mode) {
        case 0:
          sand.add(new Sand(width/2 + i, y, hue)); 
          if(i > 0) sand.add(new Sand(width/2 - i, y, hue)); 
          break;
        case 1:
          sand.add(new Sand(i, y, hue)); 
          if(i > 0) sand.add(new Sand(width - i - 1, y, hue)); 
          break;
        case 2:
          sand.add(new Sand(i * 2, y, hue)); 
          sand.add(new Sand(i * 2 + 1, y, hue)); 
          break;
      }
    }
  }
  
  stepSand();
  
  //println(frameRate);
}

void keyPressed() {
  if(key == ' ') {
    if(analysisSound.isPlaying()) {
      spectrum = new float[bands];
      analysisSound.stop();
      playSound.stop();
      tryingToPlay = false;
    } else {
      tryingToPlay = true;
    }
  }
}

void mousePressed() {
  mode = (mode + 1) % 3;
}

void getSpectrums() {
  fft.analyze(spectrum);
  for(int i = 0; i < bands; ++i) {
    spectrum[i] = spectrum[i] * spectrumScale;
  }
}
