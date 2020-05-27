int woistdashaus = -100;

void setup() {
  size(500, 500);
}
void draw() {
  background(#FFAD08);
  fill(255, 255, 255);
  //haus
  rect(150, 200, 200, 200);
  //tür
  rect(200, 300, 50, 100);
  line(150, 200, 250, 100);
  line(250, 100, 350, 200);
  fill(255, 0, 0);
  beginShape();
  vertex(150, 200);
  vertex(250, 100);
  vertex(350, 200);
  endShape();
  textSize(40);
  text("Halli Hallo Eierklo", woistdashaus, 50);
  woistdashaus++;
  if (woistdashaus > width) woistdashaus = -500;
}
