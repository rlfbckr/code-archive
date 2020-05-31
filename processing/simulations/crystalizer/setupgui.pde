void setupGUIControls() {
  cp5 = new ControlP5(this);
  PFont pfont = createFont("Consolas", 20, true); // use true/false for smooth/no-smooth
  ControlFont font = new ControlFont(pfont, 20);

  cp5.setColorForeground(color(70, 70, 70));
  cp5.setColorBackground(color(128, 128, 128));
  cp5.setColorActive(color(90, 95, 95));
  cp5.addDropdownList("MODE")
    //  cp5.addRadioButton("MODE")
    .setPosition(20, 30)
    .setFont(font)
    .setItemHeight(30)
    .setBarHeight(30)
    .addItem("RECT", RECT)
    .addItem("CIRCLE", CIRCLE)
    .addItem("TYPE", TYPE)
    ;

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

  cp5.setAutoDraw(false);
}
