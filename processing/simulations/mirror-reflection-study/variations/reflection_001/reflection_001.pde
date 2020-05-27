import point2line.*;
int _MOUSE = 0;
int _ROT = 1;

int MODE = _MOUSE;

int MAX_REFLECTION_DEPTH = 1;
boolean PAUSE = false;
boolean DEBUG = false;

ArrayList mirrors = new ArrayList();
double r = 0;
void setup() {
    size(1000, 1000, OPENGL);
    mirrors.add(new Mirror( new PVector(250, 250),
                            new PVector(750, 300),
                            0
                          )
               );
    mirrors.add(new Mirror( new PVector(250, 750),
                            new PVector(750, 600),
                            0
                          )
               );
    mirrors.add(new Mirror( new PVector(150, 300),
                            new PVector(250, 600),
                            0
                          )
               );
    mirrors.add(new Mirror( new PVector(750, 300),
                            new PVector(950, 600),
                            0
                          )
               );
}

void draw() {
    background(0);
    for (int i = 0; i < mirrors.size(); i++) {
        Mirror m = (Mirror) mirrors.get(i);
        m.draw();
    }
    if (MODE == _MOUSE) {
        r = PI - ((PI / 2.0) + calcRotationAngleInDegrees(new PVector(mouseX , mouseY ), new PVector(500, 500)));
    } else if (MODE == _ROT) {
        if (!PAUSE) { r = r + 0.01; }
    }
    compReflection(new PVector(500, 500), r, 0);
}

void compReflection(PVector origin, double direction, int depth) {
    if (depth > MAX_REFLECTION_DEPTH) return;
    //  println("direction = " + direction);
    // println(cos(direction) + "  " + sin(direction));
    stroke(10, 50, 210);
    PVector finite = new PVector((float) (origin.x + (Math.cos(direction) * 2000)), (float) (origin.y + (Math.sin(direction) * 2000)));
    println(depth + " > FINITE  ---> " + finite.x + "   " + finite.y);

    if (DEBUG) line(origin.x, origin.y, finite.x, finite.y);
    Intersection inter = findIntersection(origin, finite);
    if (inter != null && (origin.x != inter.p.x && origin.y != inter.p.y)) {
        println(depth + " > I N T E R  ---> " + inter.p.x + "   " + inter.p.y);
        stroke(255, 0, 0);
        line(origin.x, origin.y, inter.p.x, inter.p.y);
        if (DEBUG) stroke(25, 250, 90);
        float centerangle = -inter.mirror.getAngle();
        //println(degrees(aa));
        if (DEBUG) line(inter.p.x, inter.p.y, inter.p.x + (cos((float)centerangle) * 100), inter.p.y + (sin((float)centerangle) * 100));

        if (centerangle > (2 * PI)) {
            centerangle = centerangle - (2 * PI);
        }

        double returnangle = ((PI / 2.0) + (( centerangle - direction ))) + PI;
        stroke(255);
        // line(inter.p.x, inter.p.y, inter.p.x + (cos((float)returnangle) * 1000), inter.p.y + (sin((float)returnangle) * 1000));

        compReflection(inter.p, returnangle, depth + 1);

    } else {
        println(depth + " > NO_INTER");
        stroke(255, 0, 0);
        line(origin.x, origin.y, finite.x, finite.y);

    }

}

Intersection findIntersection(PVector start, PVector end) {
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

class Intersection {
    Mirror mirror;
    PVector p;
    Intersection(Mirror mirror, PVector p) {
        this.mirror = mirror;
        this.p = p;
    }
}

class Mirror  {
    int id = 0;
    PVector p1;
    PVector p2;
    double angle;
    Mirror(PVector p1, PVector p2, int id) {
        this.p1 = p1;
        this.p2 = p2;
        this.id = id;
        this.angle = calcRotationAngleInDegrees(p1, p2);
        println(angle + " --> " + degrees((float)angle));
    }

    float getAngle() {
//        return PVector.angleBetween(p1, p2);
        return (float) calcRotationAngleInDegrees(p1, p2);
    }

    void draw() {
        stroke(0, 255, 255);
        line(p1.x, p1.y, p2.x, p2.y);

    }
}




PVector segIntersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
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



double calcRotationAngleInDegrees(PVector centerPt, PVector targetPt) {
    double theta = Math.atan2(targetPt.y - centerPt.y, targetPt.x - centerPt.x);
    theta = ((Math.PI / 2.0) - theta) + PI ;
    return theta;
}


void keyReleased() {
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
    }

}