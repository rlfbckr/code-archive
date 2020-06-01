import processing.pdf.*;
import geomerative.*;
import controlP5.*;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.ListIterator;

/*
  c r y s t a l i z e r
 
 quick and dirty crystal like growth in 2D space
 (aka tron)
 
 (c) ralf baecker 2014
 
 */

PFont pfont;
PGraphics pg;
boolean pause = false;
boolean record = false;
boolean addseed = false;
boolean gui = true;
boolean restart = false;
boolean clear = false;

ArrayList toadd = new ArrayList();
static int RECT = 0;
static int CIRCLE = 1;
static int TYPE = 2;

int MAXTRIES = 6;
int MAXDEPTH = 30;
float ANGLE = 90;
float ANGELCHANGE = 1.1;
int MODE = RECT;
float STEP = 3.5;
float MIN_DIST = 6;
int AGENTS = 10;

int RANGE = 200;
int RANGE_X = 400;
int RANGE_Y = 400;

float COLOR_HUE_FROM = 255;
float COLOR_HUE_TO = 255;
float COLOR_SAT_FROM = 0;
float COLOR_SAT_TO = 0;
float COLOR_BRT_FROM = 255;
float COLOR_BRT_TO = 255;

int type_offset_x = 0;
int type_offset_y = 0;

int counter = 0;
ArrayList branches = new ArrayList();

RShape grp;
ControlP5 cp5;

void setup() {
  size(1500, 1500, P2D);
  //fullScreen(P3D);

  // for retia or HiDPI
  //pixelDensity(displayDensity());

  pg = createGraphics(width, height, JAVA2D);
  RG.init(this);
  grp = RG.getText("GROW", "tt0144m_.ttf", 450, CENTER);
  type_offset_x = width / 2;
  type_offset_y = (height / 2) + 150;
  RANGE_X = (width / 2) - 0;
  RANGE_Y = (height / 2) - 0;
  background(255);
  pg.smooth(8);
  initGUIControls();

  // reset canvas
  pg.beginDraw();
  pg.colorMode(RGB);
  pg.background(0);
  pg.endDraw();
}

void draw() {

  if (restart) {
    // reset canvas
    pg.beginDraw();
    pg.colorMode(RGB);
    pg.background(0);
    pg.endDraw();
    // empty braches
    branches = new ArrayList();
    GenerateBranch();
    restart = false;
  }
  if (clear == true) {
    pg.beginDraw();
    pg.colorMode(RGB);
    pg.background(0);
    pg.endDraw();
  }
  if (record) {
    beginRecord(PDF, "frame-####.pdf");
    colorMode(HSB, 255, 255, 255);
    strokeJoin(MITER);
    strokeCap(SQUARE);
  }
  if (addseed) {
    addRandomSeed(width / 2, height / 2, width / 2, height / 2, 0, null);
    addseed = false;
  }

  //background(50);
  pg.beginDraw();
  if (frameCount % 1 == 0) {
    //   pg.colorMode(RGB);
    //   pg.fill(40, 1);
    //  pg.rect(0, 0, width, height);
  }
  pg.colorMode(HSB, 255, 255, 255);
  pg.noFill();
  // pg.background(40);
  for (Iterator i = branches.iterator(); i.hasNext(); ) {
    Branch c = (Branch) i.next();
    if (c.childs.size() == 0 && c.dead) {
      //  toadd.add(new RPoint(c.pos.x, c.pos.y));
      i.remove();
    } else {
      if (!pause) c.update();
      // c.draw();
    }
  }
  for (Iterator i = toadd.iterator(); i.hasNext(); ) {
    RPoint  p = (RPoint) i.next();
    addRandomSeed(p.x, p.y, 5, 5, 0, null);
    i.remove();
  }
  //pg.stroke(0,255,255);
  //pg.line(20,height/2,1600,height/2);
  pg.endDraw();

  // pg.loadPixels();
  // isSpaceS(new RPoint(width / 2, height / 2), 5);
  //pg.updatePixels();
  image(pg, 0, 0);
  stroke(0, 255, 0);
  colorMode(RGB);

  if (MODE == TYPE) {
    pushMatrix();
    translate(type_offset_x, type_offset_y);
    RPoint m = new RPoint(mouseX - type_offset_x, mouseY - type_offset_y);
    if (grp.contains(m)) {
      grp.draw();
    }
    popMatrix();
  }
  //saveFrame("sticks-#####.png");
  counter++;

  if (record) {
    endRecord();
    record = false;
  }
  if (gui) drawGui();
}




boolean isSpace(RPoint test, int radius) {
  int start_x = (int) constrain((int) test.x - (radius), 0, width );
  int stop_x =  (int) constrain((int) test.x + (radius), 0, width );
  int start_y = (int) constrain((int) test.y - (radius), 0, height);
  int stop_y =  (int) constrain((int) test.y + (radius), 0, height);
  //println("x "+test.x+ "-->" + start_x + " -> " + stop_x);
  //println("y "+test.y+ "-->" + start_y + " -> " + stop_y);
  //println("pixels.length = " + pg.pixels.length);
  int t =  color(128, 128, 128);
  int f = color (255, 0, 0);
  for (int x = start_x; x < stop_x; x++) {
    for (int y = start_y; y < stop_y; y++) {
      //    println("x="+x+" y="s+y)
      int i = (y * width) + x;
      //println("i = " + i+ "("+pg.pixels.length+")");
      int c = pg.pixels[i];

      if (dist(test.x, test.y, x, y) < (radius)) {
        //  pg.pixels[i] = t;
        int r = c >> 16 & 0xFF;
        int g = c >> 8 & 0xFF;
        int b = c  & 0xFF;
        if (!(r == 0 && b == 0 && b == 0)) {
          return false;
        }
      }
    }
  }
  return true;
}



void addRandomSeed(float x, float y, float rangex, float rangey, int depth, Branch parent) {
  RPoint p = new RPoint(random(x - rangey, x + rangey), random(y - rangey, y + rangey));
  int c = 0;
  while (!inRange(p.x, p.y) && c < 20) {
    println("c=" + c);
    p =  new RPoint(random(x - rangex, x + rangex), random(y - rangey, y + rangey));
    c++;
  }
  float a = random(360 / ANGLE) * ANGLE;
  branches.add(new Branch(p, a, depth, parent));
}

void GenerateBranch() {
  if (MODE != TYPE) {
    addRandomSeed(width / 2, height / 2, 10, 10, 0, null);
  } else {
    // if typography start with mulible brachnes in each letters
    for (int i = 0; i < grp.countChildren(); i++) {
      RPoint c = grp.children[i].getCenter();
      addRandomSeed(c.x + type_offset_x, c.y + type_offset_y, 150, 150, 0, null);
    }
  }
}


boolean inRange(float x, float y) {
  if (MODE == CIRCLE) {
    if (dist(x, y, width / 2, height / 2) < (RANGE * 2)) {
      return true;
    } else {
      return false;
    }
  } else if (MODE == RECT) {
    if ( (x > ((width / 2) - RANGE_X)) && (x < ((width / 2) + RANGE_X)) && (y > ((height / 2) - RANGE_Y)) && (y < ((height / 2) + RANGE_Y)) ) {
      return true;
    } else {
      return false;
    }
  } else if (MODE == TYPE) {
    if (grp.contains(new RPoint(x - type_offset_x, y - type_offset_y))) {
      return true;
    }
  }
  return false;
}
