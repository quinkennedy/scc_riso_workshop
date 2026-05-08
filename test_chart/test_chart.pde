//1951 USAF resolution test chart
//milspec MIL-STD-150A
//5:1 aspect Tri-bar Array

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

boolean drawLabels = false;

void setup(){
  size(600, 600);
}

void draw(){
  noLoop();
  background(255);
  fill(0);
  noStroke();
  int currW = width;
  int currH = height;
  int bigGroup = -2;
  for(int i = 0; i < 3; i++){
    drawGroupA(bigGroup, currW, currH);
    drawGroupB(bigGroup+1, currW);
    drawSquare(bigGroup, currH);
    translate((int)(currW/3), (int)(currH/3));
    currW = currW/3;
    currH = currH/3;
    bigGroup += 2;
  }
  /*
  pushMatrix();
  translate(width/3, height/3);
  drawGroupA(0, width/3, height/3);
  drawGroupB(1, width/3);
  drawSquare(0, width/3);
  popMatrix();*/
}

void keyPressed(){
  if(key == 'p'){
    LocalDateTime now = LocalDateTime.now();
    DateTimeFormatter format = DateTimeFormatter.ofPattern("yyyy-MM-dd-HH-mm-ss");
    String nowString = now.format(format);
    save(nowString + "_preview.png");
  }
}

void drawSquare(int group, int w){
  int size = getScale(group, 1);
  rect(w/2, 0, size, size);
}

void drawGroupB(int group, int w){
  pushMatrix();
  int size = getScale(group, 1);
  translate((int)(w-size*2.4), 0);
  for(int element = 1; element <= 6; element++){
    size = drawPair(group, element, g);
    translate((int)((size-getScale(group, element+1))*2), ceil(size*1.8));
  }
  popMatrix();
}

void drawGroupA(int group, int w, int h){
  pushMatrix();
  int size = getScale(group, 1);
  translate(w, h);
  translate((int)(-size*2.4), -size);
  drawPair(group, 1, g);
  popMatrix();
  pushMatrix();
  for(int element = 2; element <= 6; element++){
    size = drawPair(group, element, g);
    translate(0, (int)(size*1.8));
  }
  popMatrix();
}

void drawVertTest(){
  int group = -2;
  int element = 1;
  g.rectMode(CORNER);
  for(int i = 0; i < height;){
    int eheight = drawPair(group, element, g);
    i += eheight+2;
    g.translate(0, eheight+2);
    element ++;
    if (element > 6){
      element = 1;
      group++;
    }
  }
}

int getScale(int group, int element){
  double factor = pow(2, -group-(((float)element-1.0)/6.0));
  return round((float)(25*factor));
}

int drawPair(int group, int element, PGraphics pg){
  int size = getScale(group, element);
  if (!drawLabels){
    pg.pushMatrix();
    pg.rotate(PI/2);
    pg.translate(0, -size);
    drawElement(group, element, pg);
    pg.popMatrix();
  }
  pg.pushMatrix();
  pg.translate((int)(size+size/3), 0);
  drawElement(group, element, pg);
  pg.popMatrix();
  return size;
}

int drawElement(int group, int element, PGraphics pg){
  double factor = pow(2, -group-(((float)element-1.0)/6.0));
  //base scale of 25x5
  int ewidth = round((float)(25*factor));
  int eheight = round((float)(5*factor));
  println(""+group+"x"+element+": "+ewidth+"x"+eheight);
  if (drawLabels){
    pg.fill(200);
  }
  pg.rect(0, 0, ewidth, eheight);
  pg.rect(0, eheight*2, ewidth, eheight);
  pg.rect(0, eheight*4, ewidth, eheight);
  if (drawLabels){
    pg.fill(0);
    pg.text(""+ewidth+":"+eheight, 0, 10);
  }
  return eheight*5;
}
