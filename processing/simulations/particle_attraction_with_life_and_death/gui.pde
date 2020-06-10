void createGUI() {
  cp5 = new ControlP5(this);
  PFont pfont = createFont("Arial", 24, true); // use true/false for smooth/no-smooth
  ControlFont font = new ControlFont(pfont, 20);
  /*
  cp5.setColorForeground(color(255, 0, 255));
   cp5.setColorBackground(color(50, 50, 50));
   cp5.setColorActive(color(0, 0, 0));
   */
  cp5.addSlider("attractor_move_speed", 0.0, 0.0001, 20, 50, 350, 30).setFont(font);
  cp5.addSlider("max_attraction_dist", 1, 1000, 20, 90, 350, 30).setFont(font);
  cp5.addSlider("particle_echo_length", 1, 100, 20, 130, 350, 30).setFont(font);
  cp5.addSlider("max_particle", 1, 5000, 20, 170, 350, 30).setFont(font);
  cp5.addSlider("dead_dist", 1, 50, 20, 210, 350, 30).setFont(font);


  range_acceleration = cp5.addRange("acceleration")
    .setBroadcast(false) 
    .setPosition(20, 250)
    .setSize(350, 30)
    .setHandleSize(10)
    .setRange(1.0, 0.99)
    .setRangeValues(min_acceleration, max_acceleration)
    .setBroadcast(true)
    .setFont(font)
    ;

  cp5.setAutoDraw(false);
}


void drawGUI() {
  hint(DISABLE_DEPTH_TEST);
  fill(255);
  text("fps: "+frameRate+"\nparticle: "+current_particle, width-160, 40);

  cp5.draw();
  hint(ENABLE_DEPTH_TEST);
}


void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isFrom("acceleration")) {
    min_acceleration = theControlEvent.getController().getArrayValue(0);
    max_acceleration = theControlEvent.getController().getArrayValue(1);
  }
}
