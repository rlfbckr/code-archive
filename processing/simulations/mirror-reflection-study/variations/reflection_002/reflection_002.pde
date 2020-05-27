import java.awt.geom.Line2D; //line intersection lib schon bei java dabei. hurra
import java.awt.geom.Line2D.*; //line intersection lib schon bei java dabei. hurra

int _MOUSE = 0;
int _ROT = 1;

int MODE = _MOUSE;

int MAX_REFLECTION_DEPTH = 10;
boolean PAUSE = false;
boolean DEBUG = true;

PVector beamOrigin = new PVector(500, 540);
ArrayList mirrors = new ArrayList();
double r = 0;
void setup() {
    size(1000, 1000, OPENGL);
    mirrors.add(new Mirror( new PVector(250, 250),
                            new PVector(750, 280),
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
    fill(255);
    text("d -> debug view", 20, 20);
    text("m -> angle by mouse", 20, 40);
    text("r -> autorotate", 20, 60);
    text("p -> pause", 20, 80);


    for (int i = 0; i < mirrors.size(); i++) {
        Mirror m = (Mirror) mirrors.get(i);
        m.draw();
    }
    if (MODE == _MOUSE) {
        r = fixAngle(PI - ((PI / 2.0) + calcRotationAngleInDegrees(new PVector(mouseX , mouseY ), beamOrigin)));
    } else if (MODE == _ROT) {
        if (!PAUSE) { r = r + 0.01; }
    }
    compReflection(beamOrigin, r, 0);
}

void compReflection(PVector origin, double direction, int depth) {
    if (depth > MAX_REFLECTION_DEPTH) return; // max recursion
    stroke(10, 50, 210);
    PVector finite = new PVector((float) (origin.x + (Math.cos(direction) * 4000)), (float) (origin.y + (Math.sin(direction) * 4000)));

    if (DEBUG) line(origin.x, origin.y, finite.x, finite.y);
    Intersection inter = findIntersection(origin, finite);
    if (inter != null && (origin.x != inter.p.x && origin.y != inter.p.y)) {
        println(depth + " > I N T E R  ---> " + inter.p.x + "   " + inter.p.y);
        stroke(255, 0, 0);
        line(origin.x, origin.y, inter.p.x, inter.p.y);
        if (DEBUG) stroke(25, 250, 90);
        float centerangle = -inter.mirror.getAngle();
        PVector tangente = new PVector((float) (inter.p.x + (Math.cos(centerangle) * 100)), (float) (inter.p.y + (Math.sin(centerangle) * 100)));
        if (DEBUG) line(inter.p.x, inter.p.y, tangente.x, tangente.y);
        float ta = (float) calcRotationAngleInDegrees(inter.p, tangente);
        float la = (float) calcRotationAngleInDegrees(inter.p, origin);
        float diff = ta - la;
        float returnangle = centerangle - diff ;

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

double fixAngle(double a) {
    if (a < 0) { a = (2 * PI) + a; }
    return a;
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
    Line2D line1 = new Line2D.Float(x1, y1, x2, y2);
    Line2D line2 = new Line2D.Float(x3, y3, x4, y4);
    if (!line2.intersectsLine(line1)) { return null; }
    double [] co1 = getLineCoeffs(line1);
    double [] co2 = getLineCoeffs(line2);
    // det = A1*B2 - A2*B1
    double det = co1[0]*co2[1] - co2[0]*co1[1];
    // if det == 0, lines are parallel, but already checked by intersection check above
    // if det == 0 and we got here, lines are the same line.
    if (det == 0) return null;
    // x = (B2*C1 - B1*C2)/det
    double x = (co2[1]*co1[2] - co1[1]*co2[2])/det;
    // y = (A1*C2 - A2*C1)/det
    double y = (co1[0]*co2[2] - co2[0]*co1[2])/det;
    if (x == -0.0) x = 0;
    if (y == -0.0) y = 0;
    return new PVector((float)x, (float)y);

}
    private static double [] getLineCoeffs(Line2D line) {
        double A = line.getP2().getY() - line.getP1().getY();
        double B = line.getP1().getX() - line.getP2().getX();
        double C = A * line.getP1().getX() + B * line.getP1().getY();
        return new double [] {A,B,C};
    }

PVector oldsegIntersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
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