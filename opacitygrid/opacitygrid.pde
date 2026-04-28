import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

PGraphics c1m, c1mi, c1, c2m, c2mi, c2, preview;
color pink = color(255, 72, 176);
color teal = color(0, 157, 165, 200);
int dpi = 600;
int pagew = (int)(3.25*dpi);
int pageh = (int)(3.33*dpi);

void setup(){
  size(1200, 1000);
  c1m = createGraphics(pagew, pageh);
  c1mi = createGraphics(pagew, pageh);
  c1 = createGraphics(pagew, pageh);
  c2m = createGraphics(pagew, pageh);
  c2mi = createGraphics(pagew, pageh);
  c2 = createGraphics(pagew, pageh);
  preview = createGraphics(pagew, pageh);
}

void draw(){
  noLoop();
  
  renderGrid(c1m, 255, true, 6, true);
  renderGrid(c2m, 255, false, 6, true);
  //renderGrid(c1mi, 0, true, 10, false);
  //renderGrid(c2mi, 0, true, 10, false);
  
  renderPreview();
}

void renderGrid(PGraphics pg, color bg, boolean horizontal, int steps, boolean l2d){
  pg.beginDraw();
  pg.background(bg);
  pg.ellipseMode(CENTER);
  for(int x = 0; x < steps; x++){
    for(int y = 0; y < steps; y++){
      pg.pushMatrix();
      float stretch = pagew*(1.0/(float)steps);
      pg.translate(
        (pagew+stretch)*(x+1)/(steps+1)-stretch/2, 
        (pageh+stretch)*(y+1)/(steps+1)-stretch/2);
      pg.rotate(horizontal ? PI/4 : -PI/4);
      pg.noStroke();
      int keyIndex = horizontal ? x : y;
      if (!l2d){
        keyIndex = steps - 1 - keyIndex;
      }
      int fillValue = 255*(keyIndex+1)/steps;
      pg.fill(255-fillValue);
      pg.ellipse(0, 0, pagew/steps, pagew/steps*2/3);
      pg.popMatrix();
    }
  }
  pg.endDraw();
  
}

void renderPreview(){
  
  c2mi.beginDraw();
  c2mi.image(c2m, 0, 0);
  c2mi.filter(INVERT);
  c2mi.endDraw();
  
  c2.beginDraw();
  c2.background(pink);
  c2.mask(c2mi);
  c2.endDraw();
  
  c1mi.beginDraw();
  c1mi.image(c1m, 0, 0);
  c1mi.filter(INVERT);
  c1mi.endDraw();
  
  c1.beginDraw();
  c1.background(teal);
  c1.mask(c1mi);
  c1.endDraw();
  
  preview.beginDraw();
  preview.background(255);
  preview.image(c1, 0, 0);
  preview.image(c2, 0, 0);
  preview.endDraw();
  
  image(preview, 0, 0, 1000, 1000);
  image(c1m, 1000, 0, 200, 200);
  image(c2m, 1000, 200, 200, 200);
  image(c1mi, 1000, 400, 200, 200);
  image(c2mi, 1000, 600, 200, 200);
  image(c1, 1000, 800, 200, 200);
}

void keyPressed(){
  if(key == 'p'){
    LocalDateTime now = LocalDateTime.now();
    DateTimeFormatter format = DateTimeFormatter.ofPattern("yyyy-MM-dd-HH-mm-ss");
    String nowString = now.format(format);
    c1m.save(nowString + "_c1.png");
    c2m.save(nowString + "_c2.png");
    save(nowString + "_preview.png");
    preview.save(nowString+"_fpo.png");
  } else if (key == 'r'){
    loop();
  }
}
