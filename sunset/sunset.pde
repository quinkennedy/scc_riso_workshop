import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

PGraphics c1a, c1b, c1m, c1mi, c1, c2m, c2mi, c2;
color pink = color(255, 72, 176);
color teal = color(0, 157, 165, 200);
float coverage = 0.8;
PFont myFont;

void setup(){
  size(1998,1950);//3.33x3.25
  c1a = createGraphics(width,height);
  c1b = createGraphics(width,height);
  c1m = createGraphics(width, height);
  c1mi = createGraphics(width, height);
  c1 = createGraphics(width, height);
  c2 = createGraphics(width,height);
  c2m = createGraphics(width, height);
  c2mi = createGraphics(width, height);
}

void draw(){

  noLoop();
  
  c1a.beginDraw();
  c1a.background(255);
  c1a.fill(0);
  c1a.noStroke();
  c1a.ellipseMode(CENTER);
  c1a.ellipse(width/2, width/2, width/2, width/2);
  c1a.endDraw();
  c1b.beginDraw();
  c1b.background(0);
  c1b.fill(255);
  c1b.noStroke();
  c1b.ellipseMode(CENTER);
  c1b.ellipse(width/2, width/2, width/2, width/2);
  c1b.endDraw();
  
  c1m.beginDraw();
  int step1 = height/10 + (int)random(height/10);
  int textSize = step1/2;
  myFont = createFont("Orbitron_Black.ttf", textSize);
  int step2 = (int)random(height/20);
  for(int i = 0; i < height;){
    c1m.copy(c1b, 0, i, width, step1, 0, i, width, step1);
    if (i == 0){
      c1m.textFont(myFont);
      c1m.textSize(textSize);
      c1m.fill(255);
      c1m.textAlign(CENTER);
      c1m.text("Risograph Printing", width/2, step1*2/3);
    }
    i += step1;
    c1m.copy(c1a, 0, i, width, step2, 0, i, width, step2);
    i += step2;
    step1 -= random(height/20);
    step2 += random(height/20);
  }
  c1m.endDraw();
  
  c2m.beginDraw();
  c2m.background(255);
  c2m.fill(0);
  c2m.noStroke();
  int step = (int)random(50);
  boolean up = true;
  for(int x = 0, y = height/2; x < width;){
    int x2 = x + step;
    int y2 = y + (up ? step : -step);
    c2m.beginShape();
    c2m.vertex(x, y);
    c2m.vertex(x2, y2);
    c2m.vertex(x2, height);
    c2m.vertex(x, height);
    c2m.endShape();
    step = abs(step + (int)random(100) - 50);
    up = !up;
    x = x2;
    y = y2;
  }
  c2m.textFont(myFont);
  c2m.textSize(textSize);
  c2m.textAlign(CENTER);
  c2m.fill(0);
  c2m.text("for", width/2, height*2/5);
  c2m.fill(255);
  c2m.text("Digital Artists", width/2, height*4/5);
  c2m.endDraw();
  
  renderPreview();
}

void renderPreview(){
  
  c2mi.beginDraw();
  c2mi.image(c2m, 0, 0);
  c2mi.filter(INVERT);
  //c2mi.fill(255, 255, 255, 255*0.2);
  //c2mi.rect(0, 0, width, height);
  c2mi.endDraw();
  
  c2m.beginDraw();
  c2m.fill(255, 255, 255, 255*(1-coverage));
  c2m.rect(0, 0, width, height);
  c2m.endDraw();
  
  c1mi.beginDraw();
  c1mi.image(c1m, 0, 0);
  c1mi.filter(INVERT);
  //c1mi.fill(255, 255, 255, 255*0.2);
  //c1mi.rect(0, 0, width, height);
  c1mi.endDraw();
  
  c1m.beginDraw();
  c1m.fill(255, 255, 255, 255*(1-coverage));
  c1m.rect(0, 0, width, height);
  c1m.endDraw();
  
  c2.beginDraw();
  c2.background(teal);
  c2.mask(c2mi);
  c2.endDraw();
  
  c1.beginDraw();
  c1.background(pink);
  c1.mask(c1mi);
  c1.endDraw();
  
  background(255);
  image(c1, 0, 0);
  image(c2, 0, 0);
}

void keyPressed(){
  if(key == 'p'){
    LocalDateTime now = LocalDateTime.now();
    DateTimeFormatter format = DateTimeFormatter.ofPattern("yyyy-MM-dd-HH-mm-ss");
    String nowString = now.format(format);
    c1m.save(nowString + "_c1.png");
    c2m.save(nowString + "_c2.png");
    save(nowString + "_preview.png");
  } else if (key == 'r'){
    loop();
  }
}
