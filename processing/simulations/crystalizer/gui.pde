void initGUIControls() {
  cp5 = new ControlP5(this);
  PFont pfont = createFont("Arial", 24, true); // use true/false for smooth/no-smooth
  ControlFont font = new ControlFont(pfont, 20);

  cp5.setColorForeground(color(255, 0, 255));
  cp5.setColorBackground(color(50, 50, 50));
  // cp5.setColorValue(color(255, 255, 0));
  cp5.setColorActive(color(0, 0, 0));
  cp5.addSlider("SCALE", 1, 10, 20, 80, 328, 30).setFont(font);

  cp5.addSlider("ANGLE", 1, 90, 20, 120, 328, 30).setFont(font);
  cp5.addSlider("STEP", 1, 30, 20, 160, 328, 30).setFont(font);
  cp5.addSlider("ANGELCHANGE", 0.5, 90, 20, 200, 328, 30).setFont(font);
  cp5.addSlider("MAXDEPTH", 1, 100, 20, 240, 328, 30).setFont(font);
  cp5.addSlider("MAXTRIES", 1, 50, 20, 280, 328, 30).setFont(font);

  cp5.addSlider("CHANCE_TURN", 0, 50, 20, 320, 328, 30).setFont(font);
  cp5.addSlider("CHANCE_RIGHT_LEFT", 0, 50, 20, 360, 328, 30).setFont(font);


  cp5.addSlider("COLOR_HUE_FROM", 0, 255, 20, 440, 250, 30).setFont(font);
  cp5.addSlider("COLOR_SAT_FROM", 0, 255, 20, 480, 250, 30).setFont(font);
  cp5.addSlider("COLOR_BRT_FROM", 0, 255, 20, 520, 250, 30).setFont(font);
  cp5.addSlider("COLOR_HUE_TO", 0, 255, 20, 590, 250, 30).setFont(font);
  cp5.addSlider("COLOR_SAT_TO", 0, 255, 20, 630, 250, 30).setFont(font);
  cp5.addSlider("COLOR_BRT_TO", 0, 255, 20, 670, 250, 30).setFont(font);

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

  cp5.addSlider("COLOR_BACKGROUND_R", 0, 255, 20, 740, 250, 30).setFont(font);
  cp5.addSlider("COLOR_BACKGROUND_G", 0, 255, 20, 780, 250, 30).setFont(font);
  cp5.addSlider("COLOR_BACKGROUND_B", 0, 255, 20, 820, 250, 30).setFont(font);


  cp5.addButton("LOAD_PRESET", 10, 20, 940, 150, 30).setColorBackground(color(0, 0, 255)).setFont(font);
  cp5.addButton("SAVE_PRESET", 10, 190, 940, 150, 30).setColorBackground(color(255, 0, 0)).setFont(font);

  cp5.addScrollableList("PRESET")
    .setPosition(20, 900)
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
  rect(10, 10, 600, 1000);
  colorMode(HSB, 255, 255, 255);
  noStroke();
  fill(COLOR_HUE_FROM, COLOR_SAT_FROM, COLOR_BRT_FROM);
  rect(510, 450, 30, 30);
  fill(COLOR_HUE_TO, COLOR_SAT_TO, COLOR_BRT_TO);
  rect(510, 570, 30, 30);
  colorMode(RGB);
  cp5.draw();
  hint(ENABLE_DEPTH_TEST);
}
