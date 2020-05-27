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


void setup() {
    size(1200, 1200, OPENGL);
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
        float rangle = radians(random(360));
        PVector pb = new PVector(pa.x + (cos(rangle) * msize), pa.y + (sin(rangle) * msize));
        if (findIntersection(pa, pb) == null) { // the mirror should not intersect with an existing one.
            Mirror m = new Mirror(pa, pb);
            mirrors.add(m);
        }
    }
}


void draw() {
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
        beamRotation = fixAngle(PI - ((PI / 2.0) + calcRotationAngle(new PVector(mouseX , mouseY ), beamOrigin)));
    } else if (MODE == _ROT) {
        if (!PAUSE) { beamRotation = beamRotation + 0.01; }
    }
    compReflection(beamOrigin, beamRotation, 0, null);
}


float fixAngle(float a) {
    if (a < 0) { a = (2 * PI) + a; }
    return a;
}

float calcRotationAngle(PVector centerPt, PVector targetPt) {
    float theta = atan2(targetPt.y - centerPt.y, targetPt.x - centerPt.x);
    theta = ((PI / 2.0) - theta) + PI ; //offset
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
    } else if (key == 'b') {
        println("USE_BOUNDARY");
        USE_BOUNDARY = !USE_BOUNDARY;
    }
}