LinearCongruentialGenerator rand = new LinearCongruentialGenerator(8);
shiftRegister numbers = new shiftRegister(1000);

int t = 0;
int speed = 1;
int VIEW = 0;

void setup() {
    size(2000, 600, OPENGL);
    smooth(8);
    frameRate(100);

    // settings for the random number generator
    rand.setMultiplyer(1103515245);
    rand.setModulo(5000);
    rand.setIncement(22345);

    textAlign(CENTER);
}



void draw() {
    if (t % speed == 0) {
        background(0);
        int number = rand.next();
        numbers.add(number);
        if (VIEW == 0) {
            textSize(70);
            text(number, width / 2, height / 2);
        } else {
            float step = (width-20.0)/numbers.getSize();
            textSize(15);
            for (int i = 0; i < numbers.getSize(); i++) {
                text(numbers.get(i), 10 + (i * step), 20);
            }
            noFill();
            stroke(255);
            beginShape();
            for (int i = 0; i < numbers.getSize(); i++) {
                vertex(10 + (i * step), map(numbers.get(i), -rand.m, rand.m, 30, height));
            }
            endShape();
        }
    }
    t++;
}


void keyReleased() {
    if (key == 'v') {
        VIEW = (VIEW + 1) % 2;
    }
    if (key == '+') {
        speed = constrain(speed - 1, 1, 1000);
    }
    if (key == '-') {
        speed = constrain(speed + 1, 1, 1000);
    }
}

