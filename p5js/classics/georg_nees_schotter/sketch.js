let w = 12;
let h = 19;

function setup() {
  createCanvas(520, 800);
  rectMode(CENTER);
}

function draw() {
  randomSeed(1);
  noFill();
  background(255);
  push();
  translate(20, 20);
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      push();
      translate((x + 0.5) * 10 * 4, (y + 0.5) * 10 * 4);
      translate(random(-y, y), random(-y, y));
      rotate(radians(random(-y * 10, y * 10)));
      rect(0, 0, 10 * 4, 10 * 4);
      pop();
    }
  }
  pop();
}