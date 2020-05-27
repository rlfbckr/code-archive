int table_size = 250;
int max_pwm = 1023;
boolean printed = false;
void setup() {
  size(1000, 1023);
}


void draw() {
  background(0);
  if (!printed) println("SINE:");
  for (int t = 0; t < table_size; t++) {
    int val = (int)map(
      sin( map(t, 0, table_size, 0, TWO_PI)), 
      -1.0, 1.0, 0, max_pwm);  
    if (!printed) print(val+",");
    stroke(255);
    point(t, val);
  }

  if (!printed) println("\n\nRECT:");
  for (int t = 0; t < table_size; t++) {
    int val = 0; 
    if (t < (table_size/2)) {
      val = max_pwm;
    }
    if (!printed) print(val+",");
    stroke(255,0,0);
    point(t, val);
  }

 if (!printed) println("\n\nTRI:");
  for (int t = 0; t < table_size/2; t++) {
    int val = (int)map(t,0,table_size/2,0,max_pwm);
    if (!printed) print(val+",");
    stroke(255,255,0);
    point(t, val);
  }
  for (int t = table_size/2; t < table_size; t++) {
    int val = (int)map(t,table_size/2,table_size,max_pwm,0);
    if (!printed) print(val+",");
    stroke(255,255,0);
    point(t, val);
  }

 if (!printed) println("\n\nSAW:");
  for (int t = 0; t < table_size; t++) {
    int val = (int)map(t,0,table_size-1,0,max_pwm);
    if (!printed) print(val+",");
    stroke(255,0,255);
    point(t, val);
  }

  if (!printed) println();
  printed=true;
}
