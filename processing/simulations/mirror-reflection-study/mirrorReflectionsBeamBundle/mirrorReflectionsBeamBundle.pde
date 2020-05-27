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


void setup() {
    size(1000, 1000, OPENGL);
    frameRate(30);
    smooth(4);
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


void draw() {
    background(0);

    for (int i = 0; i < mirrors.size(); i++) {
        ((Mirror) mirrors.get(i)).draw();
    }

    if (MODE == _MOUSE) {
        multibeam.setMultiBeamRotation(  PI - ( (PI / 2.0) + multibeam.calcRotationAngle(new PVector(mouseX , mouseY ), multibeam.getMultiBeamOrigin())));
        //beam2.setBeamRotation(  PI - ( (PI / 2.0) + beam2.calcRotationAngle(new PVector(mouseX , mouseY ), beam2.getBeamOrigin())));
    } else if (MODE == _ROT) {
        if (!PAUSE) {
            multibeam.setMultiBeamRotation(multibeam.getMultiBeamRotation() + 0.001);
            //beam2.setBeamRotation(beam2.getBeamRotation() + 0.01);
        }
    }

    multibeam.draw();
    //beam2.compReflection();

    drawGui();
}


void drawGui() {
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
