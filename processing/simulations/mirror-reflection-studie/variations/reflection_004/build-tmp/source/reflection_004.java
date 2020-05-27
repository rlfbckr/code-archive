import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class reflection_004 extends PApplet {

int _MOUSE = 0;
int _ROT = 1;


int MAX_REFLECTION_DEPTH = 300;

boolean PAUSE = false;
boolean DEBUG = true;
boolean USE_BOUNDARY = false;

int MODE = _MOUSE;

PVector beamOrigin;
float beamRotation = 0;

ArrayList mirrors = new ArrayList();


public void setup() {
    
    beamOrigin = new PVector(width / 2, height / 2);

    // Some static mirrors for testing...
    /*
    mirrors.add(new Mirror( new PVector(250, 250),
                        new PVector(750, 280)
                      )
           );
    mirrors.add(new Mirror( new PVector(250, 750),
                        new PVector(750, 600)
                      )
           );
    mirrors.add(new Mirror( new PVector(150, 300),
                        new PVector(250, 600)
                      )
           );
    mirrors.add(new Mirror( new PVector(750, 300),
                        new PVector(950, 600)
                      )
           );
    */
    // create some mirrors.

    // walls
    mirrors.add(new Mirror( new PVector(0, 0), new PVector(width, 0), true));
    mirrors.add(new Mirror( new PVector(0, height), new PVector(width, height), true));
    mirrors.add(new Mirror( new PVector(0, 0), new PVector(0, height), true));
    mirrors.add(new Mirror( new PVector(width, 0), new PVector(width, height), true));


    float padding = 100;
    float msize = 40;
    for (int i = 0; i < 200; i++) {
        PVector pa = new PVector(random(padding, width - padding), random(padding, height - padding));
        float rangle = radians((int)random(8)* 22.5f);
        PVector pb = new PVector(pa.x + (cos(rangle) * msize), pa.y + (sin(rangle) * msize));
        if (findIntersection(pa, pb) == null) { // the mirror should not intersect with an existing one.
            Mirror m = new Mirror(pa, pb);
            mirrors.add(m);
        }
    }
}


public void draw() {
    background(0);
    if (DEBUG) {
        fill(255);

        text("d -> debug view", 20, 20);
        text("m -> angle by mouse", 20, 40);
        text("r -> autorotate", 20, 60);
        text("b -> use boundary", 20, 80);
        text("p -> pause", 20, 100);
    }
    text((int)frameRate + " fps", width - 60, height - 30);
    for (int i = 0; i < mirrors.size(); i++) {
        ((Mirror) mirrors.get(i)).draw();
    }

    if (MODE == _MOUSE) {
        beamRotation = fixAngle(PI - ((PI / 2.0f) + calcRotationAngle(new PVector(mouseX , mouseY ), beamOrigin)));
    } else if (MODE == _ROT) {
        if (!PAUSE) { beamRotation = beamRotation + 0.01f; }
    }
    compReflection(beamOrigin, beamRotation, 0, null);
}


public float fixAngle(float a) {
    if (a < 0) { a = (2 * PI) + a; }
    return a;
}

public float calcRotationAngle(PVector centerPt, PVector targetPt) {
    float theta = atan2(targetPt.y - centerPt.y, targetPt.x - centerPt.x);
    theta = ((PI / 2.0f) - theta) + PI ; //offset
    return theta;
}


public void keyReleased() {
    if (key == 'p') {
        println("PAUSE");
        PAUSE = !PAUSE;
    } else if (key == 'd') {
        println("DEBUG");
        DEBUG = !DEBUG;
    } else if (key == 'm') {
        println("USE_MOUSE");
        MODE = _MOUSE;
    } else if (key == 'r') {
        println("USE_AUTOROT");
        MODE = _ROT;
    } else if (key == 'b') {
        println("USE_BOUNDARY");
        USE_BOUNDARY = !USE_BOUNDARY;
    }
}
class Intersection {
    Mirror mirror;
    PVector p;
    Intersection(Mirror mirror, PVector p) {
        this.mirror = mirror;
        this.p = p;
    }
}


public Intersection findFirstIntersection(PVector start, PVector end, Mirror currentMirror) {  //closest intersection...
    ArrayList possibleIntersections = new ArrayList();
    for (int i = 0; i < mirrors.size(); i++) {
        Mirror m = (Mirror) mirrors.get(i);
        if (m.isBoundary() && USE_BOUNDARY == false) {
            continue;
        }
        if (m != currentMirror) {
            PVector testintersection = segIntersection(start.x, start.y, end.x, end.y, m.p1.x, m.p1.y, m.p2.x, m.p2.y);

            if (testintersection != null) {
                stroke( 255, 255, 0 );
                noFill();
                if (DEBUG) ellipse( testintersection.x, testintersection.y, 10, 10 );
                Intersection in =  new Intersection(m, testintersection);
                possibleIntersections.add(in);
            }
        }
    }

    if (possibleIntersections.size() == 1) {
        return (Intersection) possibleIntersections.get(0);
    }
    if (possibleIntersections.size() > 1) {
        // find the closest intersection
        Intersection closest = (Intersection) possibleIntersections.get(0);
        float closestdist = dist (start.x, start.y, closest.p.x, closest.p.y);
        for (int i = 1; i < possibleIntersections.size(); i++) {
            Intersection is = (Intersection) possibleIntersections.get(i);
            float isdist = dist (start.x, start.y, is.p.x, is.p.y);

            if (isdist < closestdist ) {
                closest = is;
                closestdist = isdist;
            }
        }
        return closest;
    }

    return null;
}



public Intersection findIntersection(PVector start, PVector end) {
    for (int i = 0; i < mirrors.size(); i++) {
        Mirror m = (Mirror) mirrors.get(i);
        PVector testintersection = segIntersection(start.x, start.y, end.x, end.y, m.p1.x, m.p1.y, m.p2.x, m.p2.y);

        if (testintersection != null) {
            stroke( 255, 255, 0 );
            ellipse( testintersection.x, testintersection.y, 10, 10 );
            return new Intersection(m, testintersection);
        }


    }
    return null;
}


public PVector segIntersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
    double bx = x2 - x1;
    double by = y2 - y1;

    double dx = x4 - x3;
    double dy = y4 - y3;
    double b_dot_d_perp = bx * dy - by * dx;
    if (b_dot_d_perp == 0) {
        return null;
    }
    double cx = x3 - x1;
    double cy = y3 - y1;
    double t = (cx * dy - cy * dx) / b_dot_d_perp;
    if (t < 0 || t > 1) {
        return null;
    }
    double u = (cx * by - cy * bx) / b_dot_d_perp;
    if (u < 0 || u > 1) {
        return null;
    }
    return new PVector( (float) (x1 + t * bx), (float) (y1 + t * by)) ;
}
class Mirror  {
    PVector p1;
    PVector p2;
    boolean isBoundayElement = false;
    Mirror(PVector p1, PVector p2) {
        this.p1 = p1;
        this.p2 = p2;
    }
    Mirror(PVector p1, PVector p2, boolean isBoundayElement) {
        this.p1 = p1;
        this.p2 = p2;
        this.isBoundayElement = isBoundayElement;
    }
    public void setBoundary(boolean b) {
        isBoundayElement = b;
    }
    public boolean isBoundary() {
        return isBoundayElement;
    }
    public float getAngle() {
        return calcRotationAngle(p1, p2);
    }

    public void draw() {
        stroke(128);
        if (isBoundayElement) {
            stroke(0,255,0);
        }
        line(p1.x, p1.y, p2.x, p2.y);
    }
}
public void compReflection(PVector origin, float direction, int depth, Mirror currentMirror) {
    if (depth > MAX_REFLECTION_DEPTH) return; // max recursion

    PVector finite = new PVector((float) (origin.x + (Math.cos(direction) * 4000)), (float) (origin.y + (Math.sin(direction) * 4000)));

    if (DEBUG) {
        stroke(40);
        line(origin.x, origin.y, finite.x, finite.y);
    }
    Intersection inter = findFirstIntersection(origin, finite, currentMirror);
    if (inter != null) {
        // println(depth + " > I N T E R  ---> " + inter.p.x + "   " + inter.p.y);
        // draw beam
        stroke(map(depth,0,MAX_REFLECTION_DEPTH,255,10), 0, 0);
        line(origin.x, origin.y, inter.p.x, inter.p.y);

        float centerangle = -inter.mirror.getAngle();
        PVector tangente = new PVector((float) (inter.p.x + (cos(centerangle) * 100)), (float) (inter.p.y + (sin(centerangle) * 100)));
        if (DEBUG) {
            stroke(25, 250, 90);
            line(inter.p.x, inter.p.y, tangente.x, tangente.y);
        }
        float ta = calcRotationAngle(inter.p, tangente);
        float la = calcRotationAngle(inter.p, origin);
        float diff = ta - la;
        float returnangle = centerangle - diff ;
        compReflection(inter.p, returnangle, depth + 1, inter.mirror); // recursion :)

    } else {
        // println(depth + " > NO_INTER");
        // draw beam into the infinit....
        stroke(255, 0, 0);
        line(origin.x, origin.y, finite.x, finite.y);
    }
}
  public void settings() {  size(1200, 1200, OPENGL); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "reflection_004" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
