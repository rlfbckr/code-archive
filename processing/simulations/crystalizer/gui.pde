void initGUIControls() {
  cp5 = new ControlP5(this);
  PFont pfont = createFont("Consolas", 20, true); // use true/false for smooth/no-smooth
  ControlFont font = new ControlFont(pfont, 20);

  cp5.setColorForeground(color(70, 70, 70));
  cp5.setColorBackground(color(128, 128, 128));
  cp5.setColorActive(color(90, 95, 95));

  cp5.addSlider("ANGLE", 1, 90, 20, 120, 328, 30).setFont(font);
  cp5.addSlider("STEP", 1, 30, 20, 160, 328, 30).setFont(font);
  cp5.addSlider("ANGELCHANGE", 0.5, 90, 20, 200, 328, 30).setFont(font);
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

  cp5.addButton("LOAD_PRESET", 10, 20, 640, 150, 30).setFont(font);
  cp5.addButton("SAVE_PRESET", 10, 190, 640, 150, 30).setColorBackground(color(0, 100, 50)).setFont(font);

  cp5.addScrollableList("PRESET")
    .setPosition(20, 600)
    .setSize(200, 9*30)
    .setBarHeight(30)
    .setItemHeight(30)
    .addItem("DEFAULT", 0)
    .addItem("PRESET 1", 1)
    .addItem("PRESET 2", 2)
    .addItem("PRESET 3", 3)
    .addItem("PRESET 4", 4)
    .addItem("PRESET 5", 5)
    .addItem("PRESET 6", 6)
    .addItem("PRESET 7", 7)
    .addItem("PRESET 8", 8)
    .setFont(font)
    .close()
    ;
  cp5.setAutoDraw(false);
  preset_selected = 0;
  LOAD_PRESET();
}
void controlEvent(ControlEvent theEvent) {
  if (disable_callbacks) return;
  if (theEvent.getController().getName().equals("MODE")) {
    MODE = (int)theEvent.getController().getValue();
    println("MODE selected = "+MODE);
  }
  if (theEvent.getController().getName().equals("PRESET")) {
    preset_selected =  (int)theEvent.getController().getValue();
    println("preset_slot "+preset_selected);
    /*
    pause = true;
     disable_callbacks = true;
     LOAD_PRESET();
     pause = false;
     disable_callbacks = false;
     restart = true;
     */
  }
}

void SAVE_PRESET() {
  String filename = "default.json";
  if (preset_selected>=1) {
    filename = "preset_"+preset_selected+".json";
  }
  cp5.saveProperties((filename));
}
void LOAD_PRESET() {
  String filename = "default.json";
  if (preset_selected>=1) {
    filename = "preset_"+preset_selected+".json";
  }
  println("loading preset[ "+preset_selected+" ]: "+filename);
  cp5.loadProperties(filename);
  //cp5.getProperties().print();
  delay(100);
  restart = true;
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
