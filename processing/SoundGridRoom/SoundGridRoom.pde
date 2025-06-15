import processing.sound.*;

AudioIn mic;
FFT fft;
int bands = 512;
float[] spectrum = new float[bands];

int gridSize = 10;       // number of cells per wall side
float cellSize = 40;     // pixel size of each cell

color frontColor = color(200, 50, 50);
color backColor = color(50, 200, 50);
color leftColor = color(50, 50, 200);
color rightColor = color(200, 200, 50);
color topColor = color(200, 50, 200);
color bottomColor = color(50, 200, 200);

void setup() {
  size(800, 600, P3D);
  mic = new AudioIn(this, 0);
  mic.start();
  fft = new FFT(this, bands);
  fft.input(mic);
  rectMode(CENTER);
}

void draw() {
  background(0);
  lights();
  translate(width/2, height/2, 0);
  rotateX(-PI/6);
  rotateY(PI/3);
  fft.analyze(spectrum);

  float low = avg(0, 50); // low frequency range
  float mid = avg(50, 200); // mid frequency range
  float high = avg(200, bands); // high frequency range

  drawWall(0, 0, -gridSize*cellSize/2, 0, 0, 0, frontColor, low);      // front
  drawWall(0, 0, gridSize*cellSize/2, PI, 0, 0, backColor, mid);       // back
  drawWall(-gridSize*cellSize/2, 0, 0, 0, -HALF_PI, 0, leftColor, mid); // left
  drawWall(gridSize*cellSize/2, 0, 0, 0, HALF_PI, 0, rightColor, high); // right
  drawWall(0, -gridSize*cellSize/2, 0, -HALF_PI, 0, 0, topColor, high);  // top
  drawWall(0, gridSize*cellSize/2, 0, HALF_PI, 0, 0, bottomColor, low);  // bottom
}

float avg(int start, int end) {
  float sum = 0;
  for (int i = start; i < end; i++) {
    sum += spectrum[i];
  }
  return sum / (end - start);
}

void drawWall(float tx, float ty, float tz, float rx, float ry, float rz, color c, float amp) {
  pushMatrix();
  translate(tx, ty, tz);
  rotateX(rx);
  rotateY(ry);
  rotateZ(rz);
  stroke(c);
  noFill();
  float offset = map(amp, 0, 0.5, 0, cellSize);
  for (int x = -gridSize/2; x < gridSize/2; x++) {
    for (int y = -gridSize/2; y < gridSize/2; y++) {
      pushMatrix();
      translate(x*cellSize, y*cellSize, offset);
      rect(-cellSize/2, -cellSize/2, cellSize, cellSize);
      popMatrix();
    }
  }
  popMatrix();
}
