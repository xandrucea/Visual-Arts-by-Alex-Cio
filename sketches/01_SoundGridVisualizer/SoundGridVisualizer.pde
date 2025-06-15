// SoundGridVisualizer.pde
// Visualize microphone input on the walls of a 3D room from the inside.

import processing.sound.*;

AudioIn in;
FFT fft;
final int BANDS = 512;
float[] spectrum = new float[BANDS];
float[] bandLevels = new float[5];

void setup() {
  size(800, 600, P3D);
  colorMode(HSB, 360, 100, 100);
  in = new AudioIn(this, 0);
  in.start();
  fft = new FFT(this, BANDS);
  fft.input(in);
}

void draw() {
  background(0);
  analyzeAudio();
  lights();
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateX(-PI/6);
  rotateY(PI/4);
  drawRoom();
  popMatrix();
}

void analyzeAudio() {
  fft.analyze(spectrum);
  int bandSize = BANDS / bandLevels.length;
  for (int i = 0; i < bandLevels.length; i++) {
    float sum = 0;
    for (int j = 0; j < bandSize; j++) {
      int index = i * bandSize + j;
      sum += spectrum[index];
    }
    bandLevels[i] = sum / bandSize;
  }
}

void drawRoom() {
  int grid = 10;
  float size = 300;
  float cell = size / grid;

  int[] hues = {0, 120, 240, 60, 180};

  // front wall
  pushMatrix();
  translate(0, 0, size/2);
  drawGrid(grid, grid, cell, hues[0], bandLevels[0]);
  popMatrix();

  // left wall
  pushMatrix();
  rotateY(-HALF_PI);
  translate(0, 0, size/2);
  drawGrid(grid, grid, cell, hues[1], bandLevels[1]);
  popMatrix();

  // right wall
  pushMatrix();
  rotateY(HALF_PI);
  translate(0, 0, size/2);
  drawGrid(grid, grid, cell, hues[2], bandLevels[2]);
  popMatrix();

  // ceiling
  pushMatrix();
  rotateX(HALF_PI);
  translate(0, 0, size/2);
  drawGrid(grid, grid, cell, hues[3], bandLevels[3]);
  popMatrix();

  // floor
  pushMatrix();
  rotateX(-HALF_PI);
  translate(0, 0, size/2);
  drawGrid(grid, grid, cell, hues[4], bandLevels[4]);
  popMatrix();
}

void drawGrid(int cols, int rows, float cell, int hue, float level) {
  float spacing = cell * 0.2;
  float barSize = cell - spacing;
  float maxDepth = cell * 3;
  float depth = constrain(level * 600, 0, maxDepth);

  fill(hue, 80, 60);
  stroke(hue, 80, 100);
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      pushMatrix();
      translate((x - cols/2.0 + 0.5) * cell, (y - rows/2.0 + 0.5) * cell, depth/2);
      box(barSize, barSize, max(depth, 1));
      popMatrix();
    }
  }
}
