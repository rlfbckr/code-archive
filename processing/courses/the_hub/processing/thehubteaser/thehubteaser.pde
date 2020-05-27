import processing.sound.*;
import oscP5.*;
import netP5.*;

int myscreen = -1;
int maxscreen = 20;
boolean show_number = true;

int state = 0;
long flash_start = 0;
int flash_duration = 0;
int frequency = 0;
WhiteNoise noise;

OscP5 oscP5;

void setup() {
    fullScreen();
    oscP5 = new OscP5(this, 12001);
    noise = new WhiteNoise(this);
    noise.play();
    noise.amp(0);


}

void draw() {
    if (myscreen == -1) {
        drawSelectScreen();
    } else {
        //sin_amp = (sin_amp * 0.9) + (sin_amp_goto * 0.1);
        // sine.amp(sin_amp);
        drawFlash();
    }
}



void drawFlash() {
    textAlign(CENTER, CENTER);
    background(state * 255);

    if (show_number) {
        textSize(200);
        fill(abs(state - 1) * 255);
        text(myscreen, width / 2, (height / 2) - 40);
    }
    if (state == 1 && abs(millis() - flash_start) > flash_duration ) {
        // turn flash off after
        state = 0;
        noise.amp(0);
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
    if (theOscMessage.checkAddrPattern("/f") == true) {
        if (theOscMessage.checkTypetag("ii")) {
            int target_screen =  theOscMessage.get(0).intValue();
            if (target_screen == -1 || target_screen == myscreen) {
                flash_duration =  theOscMessage.get(1).intValue();
                state = 1;
                noise.amp(1);
                flash_start = millis();
            }
        }
    }
    if (theOscMessage.checkAddrPattern("/show_number") == true) {
        if (theOscMessage.checkTypetag("i")) {
            if (theOscMessage.get(0).intValue() == 1) {
                show_number = true;
            } else {
                show_number = false;
            }
        }
    }

    if (theOscMessage.checkAddrPattern("/frequency") == true) {
        if (theOscMessage.checkTypetag("i")) {
            frequency = theOscMessage.get(0).intValue();
        }
    }

}


