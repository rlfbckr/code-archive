void drawGui() {
  fill(0,255,255);
  text(int(frameRate) + " fps ", width-80, 20);
  text(frameCount + " fms", width-80, 50);
  hint(DISABLE_DEPTH_TEST);
  colorMode(RGB);
  noStroke();
  fill(80, 80, 80, 120);
  rect(10, 10, 500, 800);
  colorMode(HSB, 255, 255, 255);
  noStroke();
  fill(COLOR_HUE_FROM, COLOR_SAT_FROM, COLOR_BRT_FROM);
  rect(20, 600, 30, 30);
  fill(COLOR_HUE_TO, COLOR_SAT_TO, COLOR_BRT_TO);
  rect(70, 600, 30, 30);
  colorMode(RGB);
  cp5.draw();
  hint(ENABLE_DEPTH_TEST);
}
