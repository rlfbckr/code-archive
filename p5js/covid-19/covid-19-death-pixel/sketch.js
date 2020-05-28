let infected = 0;
let deceased = 0;
let infected_last = 0;
let deceased_last = 0;
let infected_first = 0;
let deceased_first = 0;

let first_read = false;
let covid_data;


let show_deaths = 0;
let block_size = 20; // 100 x 100 pixel
// covid api
// https://apify.com/covid-19l

//world
let url = 'https://api.apify.com/v2/key-value-stores/tVaYRsPHLjNdNBu7S/records/LATEST?disableRedirect=true';


function setup() {
  createCanvas(windowWidth, windowHeight);
  textSize(150);
  textAlign(CENTER, CENTER);
  setInterval(loadData, 5000)
  rectMode(CORNER);

}



function draw() {
  background(0);
  let sum_shown = 0;
  // komplette boxen zeichnen
  for (let i = 0; i < int(show_deaths / (block_size * block_size)); i++) {
    let xpos = i % int(windowWidth / block_size) * block_size;
    let ypos = int(i / int(windowWidth / block_size)) * block_size;
    drawBox(xpos, ypos , block_size, block_size*block_size);
    sum_shown = sum_shown + (block_size * block_size);
  }
  // rest zeichnen
  if (sum_shown < show_deaths) {
    let x = int(show_deaths / (block_size * block_size)) % int(windowWidth / block_size) * block_size;
    let y =  int(int(show_deaths / (block_size * block_size)) / int(windowWidth / block_size)) * block_size;
    drawBox(x,y, block_size, (show_deaths - sum_shown));
  }
  
  
  if (show_deaths < deceased) {
    if (show_deaths +  (block_size * block_size) < deceased) {
      show_deaths +=  (block_size * block_size);
    } else {
      show_deaths++;
    }
  }
  stroke(255);
  //  noStroke()
  strokeWeight(2);
  fill(0);
  textSize(120);
  text(show_deaths, windowWidth / 2, windowHeight / 2);
}

function drawBox(x, y, size, amount) {
  strokeWeight(1);
  if (size * size == amount) {
    // box ist voll also komplett ausfüllen
    noStroke();
    fill(255);
    rect(x, y, block_size, block_size);
  } else {
    // box ist noch nicht voll; also die pixel einzelnd zeichnen...
    stroke(255);
    for (let i = 0; i<amount;i++) {
       point(x+ (i%block_size),y+int(i/block_size));
    }
  }
}

function loadData() {
  covid_data = loadJSON(url, processData);
}

function processData() {
  let sum_infected = 0;
  let sum_deceased = 0;
  for (let i = 0; i < Object.keys(covid_data).length; i++) {
    sum_infected += covid_data[i]["infected"];
    sum_deceased += covid_data[i]["deceased"];
  }
  infected_last = infected;
  infected = sum_infected;
  print(millis() + " loading done: "+ (deceased-deceased_last)+ " new deaths");
  deceased_last = deceased;
  deceased = sum_deceased;

  if (first_read == false) {
    infected_first = infected;
    deceased_first = deceased;
    first_read = true;
  }


}