import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class noisesync extends PApplet {




int myscreen = -1;
int noise_seed = 1;
long sync = 0;
int slices = 40;
long t = 0;
float speed = 0.00001f;
float spread = 0.01f;
int  maxscreen = 20;
int fr = 1000;

boolean _DEBUG_ = true;
OscP5 oscP5;


public void setup() {

    
    oscP5 = new OscP5(this, 12000);
    frameRate(fr);
    slices = 1000 / fr;
    noiseDetail(1, 9.2f);
}

public void draw() {

    if (myscreen == -1) {
        drawSelectScreen();
    } else {
        drawNoise();
    }

}



public void drawNoise() {
    background(0);
    t = (long)(now() * speed);
//slices = frameRate();
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
        text("myscreen     = " + myscreen, 20, 20);
        text("noise_seed   = " + noise_seed, 20, 50);
        text("now()        = " + now(), 20, 80);
        text("speed        = " + speed, 20, 110);
        text("spread       = " + spread, 20, 140);
        text("fps          = " + frameRate, 20, 170);
    }

}


public void drawSelectScreen() {
    background(0);
    fill(255, 255, 255);
    textSize(60);
    text("Please Select your Screen:", width / 2, 100);
    textSize(20);

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
        text(i, 100 + (i * 40) + 13, 172);

    }

}

public void oscEvent(OscMessage theOscMessage) {
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

public long now() {
    return (millis() - sync);
}

public void keyReleased() {
    
}
  public void settings() {  size(500, 500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "noisesync" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
