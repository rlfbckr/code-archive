void initGUIControls() {
  cp5 = new ControlP5(this);
  PFont pfont = createFont("Consolas", 20, true); // use true/false for smooth/no-smooth
  ControlFont font = new ControlFont(pfont, 20);

  cp5.setColorForeground(color(70, 70, 70));
  cp5.setColorBackground(color(128, 128, 128));
  cp5.setColorActive(color(90, 95, 95));

  cp5.addSlider("ANGLE", 1, 90, 20, 120, 328, 30).setFont(font);
  cp5.addSlider("STEP", 1, 10, 20, 160, 328, 30).setFont(font);
  cp5.addSlider("ANGELCHANGE", 0.5, 5, 20, 200, 328, 30).setFont(font);
  cp5.addSlider("MAXDEPTH", 1, 100, 20, 240, 328, 30).setFont(font);
  cp5.addSlider("MAXTRIES", 1, 50, 20, 280, 328, 30).setFont(font);

  cp5.addSlider("COLOR_HUE_FROM", 0, 255, 20, 340, 250, 30).setFont(font);
  cp5.addSlider("COLOR_SAT_FROM", 0, 255, 20, 380, 250, 30).setFont(font);
  cp5.addSlider("COLOR_BRT_FROM", 0, 255, 20, 420, 250, 30).setFont(font);
  cp5.addSlider("COLOR_HUE_TO", 0, 255, 20, 460, 250, 30).setFont(font);
  cp5.addSlider("COLOR_SAT_TO", 0, 255, 20, 500, 250, 30).setFont(font);
  cp5.addSlider("COLOR_BRT_TO", 0, 255, 20, 540, 250, 30).setFont(font);

  cp5.addScrollableList("MODE")
    .setPosition(20, 30)
    .setSize(200, 4*30)
    .setBarHeight(30)
    .setItemHeight(30)
    .addItem("RECT", RECT)
    .addItem("CIRCLE", CIRCLE)
    .addItem("TYPE", TYPE)

    .setFont(font)
    .close()
    ;

  cp5.addButton("savedefaults", 10, 20, 600, 150, 30).setCaptionLabel("save default").setFont(font);
  cp5.addButton("loaddefaults", 10, 190, 600, 150, 30).setCaptionLabel("load default").setColorBackground(color(0, 100, 50)).setFont(font);

  cp5.addButton("saveseta", 10, 20, 640, 150, 30).setCaptionLabel("save setA").setFont(font);
  cp5.addButton("loadseta", 10, 190, 640, 150, 30).setCaptionLabel("load setA").setColorBackground(color(0, 100, 50)).setFont(font);

  cp5.addButton("savesetb", 10, 20, 680, 150, 30).setCaptionLabel("save setB").setFont(font);
  cp5.addButton("loadsetb", 10, 190, 680, 150, 30).setCaptionLabel("load setB").setColorBackground(color(0, 100, 50)).setFont(font);


  cp5.setAutoDraw(false);
  loaddefaults();
}


void drawGui() {
  fill(0, 255, 255);
  text("ftp: "+int(frameRate), width-90, 20);
  text("frames:"+frameCount, width-90, 50);
  hint(DISABLE_DEPTH_TEST);
  colorMode(RGB);
  noStroke();
  fill(80, 80, 80, 120);
  rect(10, 10, 500, 800);
  colorMode(HSB, 255, 255, 255);
  noStroke();
  fill(COLOR_HUE_FROM, COLOR_SAT_FROM, COLOR_BRT_FROM);
  rect(460, 350, 30, 30);
  fill(COLOR_HUE_TO, COLOR_SAT_TO, COLOR_BRT_TO);
  rect(460, 470, 30, 30);
  colorMode(RGB);
  cp5.draw();
  hint(ENABLE_DEPTH_TEST);
}



void saveseta( ) {
  println("saveseta");
  cp5.saveProperties(("setA.json"));
}

void loadseta( ) {
  cp5.loadProperties("setA.json");
  cp5.getProperties().print();
  delay(100);
  restart = true;
}
void savesetb( ) {
  println("savesetb");
  cp5.saveProperties("setB.json" );
}

void loadsetb( ) {
  cp5.loadProperties(("setB.json"));
  cp5.getProperties().print();
  delay(100);
  restart = true;
}

void savedefaults( ) {
  cp5.saveProperties("default.json");
}

void loaddefaults( ) {
  cp5.loadProperties(("default.json"));
  cp5.getProperties().print();
  delay(100);
  restart = true;
}
