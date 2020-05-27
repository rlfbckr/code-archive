int sum_deaths = 0;
int sum_cases = 0;
int first_sum_deaths = 0;
int first_sum_cases = 0;
boolean first_done = false;

PFont font;

void setup() {
  size(1000, 1000);

  font = createFont("Arial", 150);
  textFont(font);
  textAlign(CENTER, CENTER);
  textSize(150);
  getData();
}


void draw() {
  background(0);

  getData();
  fill(255);
  text(sum_deaths+"\n"+(sum_deaths-first_sum_deaths), width/2, height/2);
}


void getData() {
  JSONObject json;

  json = loadJSONObject("https://opendata.ecdc.europa.eu/covid19/casedistribution/json");

  JSONArray  records = json.getJSONArray("records"); 
  String filter_country = "Germany";
  int tmp_death = 0;
  int tmp_cases = 0;
  for (int i = 0; i < records.size(); i++) {
    JSONObject record = records.getJSONObject(i); 
    //if (record.getString("countriesAndTerritories").equals(filter_country)) {
    //println(record.getString("dateRep")+" : " +record.getString("countriesAndTerritories"));
    tmp_death+=record.getInt("deaths");
    tmp_cases+=record.getInt("cases");
    //}
  }
  sum_cases = tmp_cases;
  sum_deaths = tmp_death;
  if (first_done == false) {
    first_sum_deaths = sum_deaths;
    first_sum_cases = sum_cases;
    first_done = true;
  }
  println(millis()+" sum death/cases: "+ sum_deaths + " : "+sum_cases);
}
