void keyReleased() {
  if (key == 'd') {
    DEBUG = !DEBUG;
    if (DEBUG) {
      cursor();
    } else {
      noCursor();
    }
  }
  if (key == 'r') {
    RESET = true;
  }
  if (key == 'c') {
    CLEAR =!CLEAR;
  }
}
