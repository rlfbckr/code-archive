let osc;
let freq = 440;
let freq_target = 200;
let fade_speed = 2;

function setup() {
  createCanvas(400, 400);
  osc = new p5.Oscillator('sine');
  osc.freq(freq); 
  osc.amp(1.0);
  osc.start();
}

function draw() {
  background(220);
  print(freq+ " " + freq_target);
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
  osc.freq(freq); 
}