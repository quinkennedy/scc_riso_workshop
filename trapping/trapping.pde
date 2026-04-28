import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

PGraphics c1m, c1mi, c1, c2m, c2mi, c2;
color pink = color(255, 72, 176);
color teal = color(0, 157, 165, 200);
int dpi = 600;
float mmpi = 25.4;
float coverage = 0.8;

void setup(){
  size(1998, 1200);//3.33"x2" @600dpi
  c1m = createGraphics(width, height);
  c1mi = createGraphics(width, height);
  c1 = createGraphics(width, height);
  c2m = createGraphics(width, height);
  c2mi = createGraphics(width, height);
  c2 = createGraphics(width, height);
}

void draw(){
  noLoop();
background(255);
drawRegistration(width-100, height-100, c1m);
drawRegistration(width-100, height-100, c2m);
float trapmm = 0.3;//https://spectrolite.app/how-to/color/trapping#trapping-amount
int trappx = round(trapmm/mmpi*dpi);
renderLabels();

drawSample(400, 100, 0, 0, 0);
drawSample(400, 700, trappx*2/3, 0, 0);
drawSample(1200, 100, 0, 0, trappx);
drawSample(1200, 700, trappx*2/3, 0, trappx);

renderPreview();
}
void renderLabels(){
  
c2m.beginDraw();
c2m.textSize(84);
c2m.text("no trapping", 400, 80);
c2m.text("0.3mm trapping", width-850, 80);
c2m.pushMatrix();
c2m.rotate(PI/2);
c2m.text("\"perfect\"\nregistration", 100, -120);
c2m.text("\"0.2mm\"\nmis-registration", 640, -120);
c2m.popMatrix();
c2m.endDraw();
}

void renderPreview(){
  c2mi.beginDraw();
  c2mi.image(c2m, 0, 0);
  c2mi.filter(INVERT);
  c2mi.endDraw();
  
  c2m.beginDraw();
  c2m.fill(255, 255, 255, 255*(1-coverage));
  c2m.rect(400, 100, width-600, height-100);
  c2m.endDraw();
  
  c1mi.beginDraw();
  c1mi.image(c1m, 0, 0);
  c1mi.filter(INVERT);
  c1mi.endDraw();
  
  c1m.beginDraw();
  c1m.fill(255, 255, 255, 255*(1-coverage));
  c1m.rect(400, 100, width-600, height-100);
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
  }
}

void drawRegistration(int x, int y, PGraphics pg){
  pg.beginDraw();
  pg.background(255);
  pg.stroke(0);
  pg.strokeWeight(5);
  pg.line(x - 100, y, x + 100, y);
  pg.line(x, y - 100, x, y + 100);
  pg.noStroke();
  pg.fill(0);
  pg.ellipseMode(CENTER);
  //pg.rectMode(CENTER);
  pg.endDraw();
}

void drawSample(int x, int y, int offsetX, int offsetY, int trapping){
  int scale = 500;
  c1m.beginDraw();
  c1m.ellipse(x+offsetX+scale/2, y+offsetY+scale/2, scale-100, scale-100);
  c1m.endDraw();
  c2m.beginDraw();
  c2m.fill(0);
  c2m.rect(x, y, scale, scale);
  c2m.fill(255);
  c2m.ellipse(x+scale/2, y+scale/2, scale-100-trapping*2, scale-100-trapping*2);
  c2m.endDraw();
}
