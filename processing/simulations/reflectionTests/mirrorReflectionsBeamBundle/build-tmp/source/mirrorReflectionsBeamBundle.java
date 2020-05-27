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

public class mirrorReflectionsBeamBundle extends PApplet {

/*
    mirrorMultiBeamReflectionsExample
    ---------------------------------

    quick and dirty mirrorReflection(bundle) implementation for processing

    Ralf Baecker 20x17

*/

int _MOUSE = 0;
int _ROT = 1;


int MAX_REFLECTION_DEPTH = 20; // max recursion depth

boolean PAUSE = false;
boolean DEBUG = true;
boolean USE_BOUNDARY = false;

int MODE = _MOUSE;


ArrayList mirrors = new ArrayList();

//Beam beam;
MultiBeam multibeam;
//Beam beam2;


public void setup() {
    
    frameRate(30);
    
//    beam = new Beam(new PVector(width / 2, height / 2), 0);
    multibeam = new MultiBeam(new PVector(width / 2, height / 2), 0);
    //beam2 = new Beam(new PVector(2 * (width / 3), height / 2), 0);
    //beam2.setBeamRotation(PI / 2.0);
    // boundary box
    mirrors.add(new Mirror( new PVector(0, 0), new PVector(width, 0), true));
    mirrors.add(new Mirror( new PVector(0, height), new PVector(width, height), true));
    mirrors.add(new Mirror( new PVector(0, 0), new PVector(0, height), true));
    mirrors.add(new Mirror( new PVector(width, 0), new PVector(width, height), true));

    // create some random mirrors
    float padding = 100;
    float msize = 40;
    for (int i = 0; i < 90; i++) {
        PVector pa = new PVector(random(padding, width - padding), random(padding, height - padding));
        float rangle = radians((int)random(4) * 45);
        PVector pb = new PVector(pa.x + (cos(rangle) * msize), pa.y + (sin(rangle) * msize));
        if (findIntersection(pa, pb) == null) { // the mirror should not intersect with an existing one.
            mirrors.add(new Mirror(pa, pb));
        }
    }
}


public void draw() {
    background(0);

    for (int i = 0; i < mirrors.size(); i++) {
        ((Mirror) mirrors.get(i)).draw();
    }

    if (MODE == _MOUSE) {
        multibeam.setMultiBeamRotation(  PI - ( (PI / 2.0f) + multibeam.calcRotationAngle(new PVector(mouseX , mouseY ), multibeam.getMultiBeamOrigin())));
        //beam2.setBeamRotation(  PI - ( (PI / 2.0) + beam2.calcRotationAngle(new PVector(mouseX , mouseY ), beam2.getBeamOrigin())));
    } else if (MODE == _ROT) {
        if (!PAUSE) {
            multibeam.setMultiBeamRotation(multibeam.getMultiBeamRotation() + 0.001f);
            //beam2.setBeamRotation(beam2.getBeamRotation() + 0.01);
        }
    }

    multibeam.draw();
    //beam2.compReflection();

    drawGui();
}


public void drawGui() {
    if (DEBUG) {
        fill(255);
        text("d -> debug view", 20, 20);
        text("m -> angle by mouse", 20, 40);
        text("r -> autorotate", 20, 60);
        text("b -> use boundary", 20, 80);
        text("p -> pause", 20, 100);
    }
    text((int)frameRate + " fps", width - 60, height - 30);
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
class Beam {
    PVector beamOrigin;
    float beamRotation = 0;

    Beam(PVector beamOrigin, float beamRotation) {
        this.beamOrigin = beamOrigin;
        this.beamRotation = beamRotation;
    }

    public void setBeamRotation(float rot) {
        this.beamRotation = rot;
    }

    public float getBeamRotation() {
        return beamRotation;
    }

    public void setBeamOrigin(float x, float y) {
        beamOrigin.x = x;
        beamOrigin.y = y;
    }
    public void setBeamOrigin(PVector newBeamOrigin) {
        this.beamOrigin = newBeamOrigin;
    }
    public PVector getBeamOrigin() {
        return beamOrigin;
    }

    public void compReflection() {
        compReflection(beamOrigin, beamRotation, 0, null);
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
            // println(depth + " > INTERSECION FOUND  ---> " + inter.p.x + "   " + inter.p.y);
            // draw beam
            stroke(map(depth, 0, MAX_REFLECTION_DEPTH, 255, 10), map(depth, 0, MAX_REFLECTION_DEPTH, 255, 10), map(depth, 0, MAX_REFLECTION_DEPTH, 200, 10),128); // fade out beam color...
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
            // println(depth + " > NO_INTERSECTION");
            // draw beam into the infinit....
            stroke(255, 255, 200,128);
            line(origin.x, origin.y, finite.x, finite.y);
        }
    }

    public float calcRotationAngle(PVector centerPt, PVector targetPt) {
        float theta = atan2(targetPt.y - centerPt.y, targetPt.x - centerPt.x);
        theta = ((PI / 2.0f) - theta) + PI ; //offset
        return theta;
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
    // not optimized yet.
    ArrayList possibleIntersections = new ArrayList();
    for (int i = 0; i < mirrors.size(); i++) {
        Mirror m = (Mirror) mirrors.get(i);
        if (m.isBoundary() && USE_BOUNDARY == false) {
            continue;
        }
        if (m == currentMirror) { // not myself
            continue;
        }
        PVector testintersection = segIntersection(start.x, start.y, end.x, end.y, m.p1.x, m.p1.y, m.p2.x, m.p2.y);
        if (testintersection != null) {
            if (DEBUG) {
                stroke( 255 );
                noFill();
                ellipse( testintersection.x, testintersection.y, 6, 6 );
            }
            Intersection in =  new Intersection(m, testintersection);
            possibleIntersections.add(in);
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

/*
 code from here:
 http://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
*/

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
// mirror object
class Mirror  {
    int size = 2;
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
    public float calcRotationAngle(PVector centerPt, PVector targetPt) {
        float theta = atan2(targetPt.y - centerPt.y, targetPt.x - centerPt.x);
        theta = ((PI / 2.0f) - theta) + PI ; //offset
        return theta;
    }
    public void draw() {
        stroke(128);
        if (isBoundayElement) {
            stroke(0);
        }
        strokeWeight(2);
        line(p1.x, p1.y, p2.x, p2.y);
        strokeWeight(1);
    }
}
class MultiBeam {
    PVector  origin;
    float rotation = 0;
    int size = 100;

    ArrayList beams = new ArrayList();
    MultiBeam(PVector origin, float rotation) {
        this.origin = origin;
        this.rotation = rotation;
        for (int i = 0; i < size; i++) {
            float ox = lerp(    origin.x - (cos(rotation + (PI / 2)) * size / 2),
                                origin.x + (cos(rotation + (PI / 2)) * size / 2),
                                (i / (size * 1.0f))
                           );
            float oy = lerp(    origin.y - (sin(rotation + (PI / 2)) * size / 2),
                                origin.y + (sin(rotation + (PI / 2)) * size / 2),
                                (i / (size * 1.0f))
                           );

            PVector oo = new PVector(ox, oy);
            Beam b = new Beam(oo, rotation);
            beams.add(b);
            println(i + " > adding beam: " + ox + " / " + oy + "     " + (i / size));
        }
    }

    public void setMultiBeamRotation(float rot) {
        this.rotation = rot;
    }

    public float getMultiBeamRotation() {
        return rotation;
    }

    public void setMultiBeamOrigin(PVector origin) {
        this.origin = origin;
    }

    public PVector getMultiBeamOrigin() {
        return origin;
    }

    public float calcRotationAngle(PVector centerPt, PVector targetPt) {
        float theta = atan2(targetPt.y - centerPt.y, targetPt.x - centerPt.x);
        theta = ((PI / 2.0f) - theta) + PI ; //offset
        return theta;
    }

    public void draw() {
        if (DEBUG) {
            stroke(255, 0, 255);
            line(origin.x - (cos(rotation + (PI / 2)) * size / 2), origin.y - (sin(rotation + (PI / 2)) * size / 2), origin.x + (cos(rotation + (PI / 2)) * size / 2), origin.y + (sin(rotation + (PI / 2)) * size / 2));
        }
        for (int i = 0; i < beams.size(); i++) {
            Beam b = (Beam) beams.get(i);
            b.setBeamRotation(rotation);
            b.setBeamOrigin(    lerp(
                                    origin.x - (cos(rotation + (PI / 2)) * size / 2),
                                    origin.x + (cos(rotation + (PI / 2)) * size / 2),
                                    (i / (size * 1.0f))
                                ),
                                lerp(
                                    origin.y - (sin(rotation + (PI / 2)) * size / 2),
                                    origin.y + (sin(rotation + (PI / 2)) * size / 2),
                                    (i / (size * 1.0f))
                                )
                           );
            b.compReflection();
        }
    }
}
  public void settings() {  size(1000, 1000, OPENGL);  smooth(4); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "mirrorReflectionsBeamBundle" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
