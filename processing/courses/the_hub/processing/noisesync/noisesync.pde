import oscP5.*;
import netP5.*;
import java.net.*;

int myscreen = -1;
int noise_seed = 1;
long sync = 0;
int slices = 40; // 1000 / 25  - 1sec / framerate
long t = 0;
float speed = 0.00001;
float spread = 0.01;
int  maxscreen = 20;

boolean _DEBUG_ = true;
OscP5 oscP5;
int port = 12000;

void setup() {
    fullScreen();
    oscP5 = new OscP5(this, port);
    frameRate(25);
    noiseDetail(1, 9.2);
}

void draw() {
    if (myscreen == -1) {
        drawSelectScreen();
    } else {
        drawNoise();
    }
}



void drawNoise() {
    t = (long)(now() * speed);
    noStroke();
    for (int ts = 0; ts < slices; ts++) {
        // var col =  noise(  (t+(myscreen*slices)+ts)*scaling)*255;
        float r = noise(0, (t + ts + (myscreen * slices)) * spread) * 255;
        float g = noise(20000, (t + ts + (myscreen * slices)) * spread) * 255;
        float b = noise(30000, (t + ts + (myscreen * slices)) * spread) * 255;
        fill(r, g, b);
        rect(map(ts, 0, slices, 0, width), 0, map(ts + 1, 0, slices, 0, width), height);
    }

    if (_DEBUG_) {
        fill(0, 255, 255);
        textAlign(LEFT);
        text("myscreen     = " + myscreen + " / " + port, 20, 20);
        text("noise_seed   = " + noise_seed, 20, 50);
        text("now()        = " + now(), 20, 80);
        text("speed        = " + speed, 20, 110);
        text("spread       = " + spread, 20, 140);
        text("fps          = " + frameRate, 20, 170);
    }

}

void drawSelectScreen() {
    background(0);
    fill(255, 255, 255);
    textSize(60);
    textAlign(LEFT);
    text("Please Select your Screen:", 100, 100);
    textSize(20);
    textAlign(CENTER, CENTER);

    for (int i = 0; i < maxscreen; i++) {
        stroke(255);
        fill(0);
        if ((mouseX > 100 + (i * 40)) && (mouseX < 100 + (i * 40) + 30)) {
            fill(255, 0, 0);
            if (mousePressed) {
                myscreen = i;
            }
        }
        rect(100 + (i * 40), 150, 30, 30);
        fill(255);
        text(i, 100 + (i * 40) + 16, 165);
    }
}


void oscEvent(OscMessage theOscMessage) {
    if (theOscMessage.checkAddrPattern("/s") == true) {
        if (theOscMessage.checkTypetag("i")) {
            noise_seed =  theOscMessage.get(0).intValue();
            noiseSeed(noise_seed);
            sync = millis();
        }
    }
    if (theOscMessage.checkAddrPattern("/speed") == true) {
        if (theOscMessage.checkTypetag("f")) {
            speed =  theOscMessage.get(0).floatValue();
        }
    }
    if (theOscMessage.checkAddrPattern("/spread") == true) {
        if (theOscMessage.checkTypetag("f")) {
            spread =  theOscMessage.get(0).floatValue();
        }
    }

}

long now() {
    return (millis() - sync);
}

void keyReleased() {
    if (key == 'd') {
        _DEBUG_ = !_DEBUG_;
    }
}