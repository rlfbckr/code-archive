class Branch {
  RPoint pos;

  boolean dead = false;
  float angle;
  int ROTDIR = 1;
  int STEPS = 0;
  int depth = 0;
  float anglechange = 0;
  int tries = 0;

  ArrayList childs = new ArrayList();
  Branch parent = null;

  Branch(RPoint pos, float angle, int depth, Branch parent) {
    this.parent = parent;
    this.angle = angle;
    this.pos = pos;
    this.depth = depth;
    anglechange = ANGLE;
    ROTDIR = 1;
    if (int(random(2)) == 0)
      ROTDIR = 1;
    if (int(random(6)) == 0)
      ROTDIR = 0;
  }

  void update() {
    // pg.updatePixels();
    if (!dead) {
      anglechange = anglechange * ANGELCHANGE;
      STEPS++;
      angle = angle + (ROTDIR * anglechange);
      RPoint nextpos = new RPoint(pos.x + sin(radians(angle)) * STEP, pos.y + cos(radians(angle)) * STEP);
      if (isSpace(nextpos, (int)STEP )  && inRange(nextpos.x, nextpos.y)) {
        pg.stroke(map(depth, 0, MAXDEPTH, COLOR_HUE_FROM, COLOR_HUE_TO), map(depth, 0, MAXDEPTH, COLOR_SAT_FROM, COLOR_SAT_TO), map(depth, 0, MAXDEPTH, COLOR_BRT_FROM, COLOR_BRT_TO));
        pg.line(pos.x, pos.y, nextpos.x, nextpos.y);
        pos = nextpos;
        tries = 0;
      } else {
        tries++;
      }
      if (tries > MAXTRIES) {
        dead = true;
      }

      if (depth < MAXDEPTH && STEPS % 6 == 0) {
        if (childs.size() < int(map(depth, 0, MAXDEPTH, 5, 160))) {
          RPoint p = new RPoint(pos.x, pos.y);
          float a = angle + 90;
          Branch b = new Branch(p, a, (depth + 1), this);
          childs.add(b);
        }
      }
    }

    for (Iterator i = childs.iterator(); i.hasNext(); ) {
      Branch c = (Branch) i.next();
      if (c.childs.size() == 0 && c.dead) {
        i.remove();
      } else {
        c.update();
      }
    }
  }
}
