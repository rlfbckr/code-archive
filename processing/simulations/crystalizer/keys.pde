void keyReleased() {
  if (key == ' ') {
    pause = !pause;
  }
  if (key == 's') {
    pause = false;
    restart = true;
    clear = false;
    println("restart");
  }
  if (key == 'd') {
    gui = !gui;
    if (gui) {
      cursor();
    } else {
      noCursor();
    }
  }
  if (key == 'i') {
    addseed = true;
  }
  if (key == 'r') {
    record = true;
  }
  if (key == 'h') {
    pause = true;
    restart = false;
    clear = true;
  }
}
