let osc;
let osc1;

let infected = 0;
let deceased = 0;
let infected_last = 0;
let deceased_last = 0;
let infected_first = 0;
let deceased_first = 0;

let first_read = false;
let covid_data;


// covid api
// https://apify.com/covid-19l

//world
let url = 'https://api.apify.com/v2/key-value-stores/tVaYRsPHLjNdNBu7S/records/LATEST?disableRedirect=true';
// https://api.covid19api.com/summary

function setup() {
  createCanvas(windowWidth, windowHeight);
  textSize(150);
  textAlign(CENTER, CENTER);
  setInterval(loadData, 1000)
  
  osc = new p5.Oscillator('sine');
  osc.freq(100); 
  osc.amp(0.9);
  osc.start();
  
  osc1 = new p5.Oscillator('sine');
  osc1.freq(80); 
  osc1.amp(0.9);
  osc1.start();
}

function draw() {
  background(0);
  if (deceased_last != deceased) {
      background(255,0,0);
  }
  fill(255)
  textSize(100);
  text(deceased + " total death", windowWidth / 2, windowHeight / 2);
  textSize(30);
  text((deceased-deceased_first) + " death since you opened this site", (windowWidth / 2), (windowHeight / 2)+100);
  osc.freq(map(deceased,300000,500000,200,60)); 
  osc1.freq(map(infected,5000000,6000000,60,200)); 
}

function loadData() {
  covid_data = loadJSON(url, processData);
}

function processData() {
  print(millis() + " loading done: ");
  let sum_infected = 0;
  let sum_deceased = 0;
  for (let i = 0; i < Object.keys(covid_data).length; i++) {
    sum_infected += covid_data[i]["infected"];
    sum_deceased += covid_data[i]["deceased"];
  }
  
  infected_last = infected;
  infected = sum_infected;

  deceased_last = deceased;
  deceased = sum_deceased;

  if (first_read == false) {
    infected_first = infected;
    deceased_first = deceased;
    first_read = true;
  }
 

}