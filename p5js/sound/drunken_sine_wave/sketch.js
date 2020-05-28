let osc;
let freq = 100;
let freq_target = 200;
let fade_speed = 2;

function setup() {
  createCanvas(windowWidth, windowHeight);
  osc = new p5.Oscillator('sawtooth');
  osc.freq(freq); 
  osc.amp(0.5);
  osc.start();
  textSize(150);
  textAlign(CENTER, CENTER);
}

function draw() {
  background(map(freq,100,500,0,255));
  //print(freq+ " " + freq_target);
  if (freq > freq_target) {
    freq=freq-fade_speed;
  }
  if (freq < freq_target) {
    freq=freq+fade_speed;
  }
  if (abs(freq-freq_target) < 2) {
    print("new random frequency");
    freq_target = random(100,500);
  }
  //osc.freq(freq); 
  fill(0);
  text(freq+" Hz", windowWidth / 2, windowHeight / 2);
}