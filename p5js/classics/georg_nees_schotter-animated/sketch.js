var w = 12;
var h = 19;
var s = 0.0001;

/*
   http://www.medienkunstnetz.de/werke/schotter/
*/

function setup() {
  createCanvas(520, 800);
  rectMode(CENTER);
}

function draw() {
  background(0);
  noFill();
  stroke(255);
  push();
  translate(20, 20);
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      push();
      translate((x + 0.5) * 10 * 4, (y + 0.5) * 10 * 4);
      translate(map(noise(x, y, (millis() * s)), 0, 1, -y * 0.9, y * 0.9), map(noise(x, y, (millis() * s)), 0, 1, -y * 0.9, y * 0.0));
      rotate(map(noise(x, y, s * millis()), 0, 1, -y * 0.15, y * 0.15));
      rect(0, 0, 10 * 4, 10 * 4);
      pop();
    }
  }
  pop();
}