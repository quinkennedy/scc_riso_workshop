import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

PGraphics c1m, c1mi, c1, c2m, c2mi, c2;
color pink = color(255, 72, 176);
color teal = color(0, 157, 165, 200);
int dpi = 600;

void setup(){
  size(600, 1200);
  c1m = createGraphics(width, height);
  c1mi = createGraphics(width, height);
  c1 = createGraphics(width, height);
  c2m = createGraphics(width, height);
  c2mi = createGraphics(width, height);
  c2 = createGraphics(width, height);
}

void draw(){
  noLoop();
  noiseDetail(0, 0.1);
  noiseSeed(millis());
  c1m.beginDraw();
  c1m.loadPixels();
  for(int x = 0; x < width; x++){
    for(int y = 0; y < height; y++){
      float n = noise(x*.005, y*.005);
      n = min(1, max(0, 1 * (n-.5) + .5));
      c1m.pixels[x+y*width] = color(n * 255);
    }
  }
  c1m.updatePixels();
  c1m.endDraw();
  
  c2m.beginDraw();
  c2m.background(255);
  c2m.loadPixels();
  for(int x = 1; x < width; x++){
    for(int y = 1; y < height; y++){
     
      //c2m.pixels[x+y*width] = c1m.pixels[x-1+(y-1)*width] - c1m.pixels[x+y*width];
    
     // c2m.pixels[x+y*width] = min(255, max(0, (c1m.pixels[x-1+(y-1)*width] - c1m.pixels[x+y*width]) + (int)map(y, 700, 1000, 255, 0)));
    }
  }
  c2m.updatePixels();
  c2m.endDraw();
  
  renderPreview();
}

void renderPreview(){
  c2mi.beginDraw();
  c2mi.image(c2m, 0, 0);
  c2mi.filter(INVERT);
  c2mi.endDraw();
  
  c1mi.beginDraw();
  c1mi.image(c1m, 0, 0);
  c1mi.filter(INVERT);
  c1mi.endDraw();
  
  c2.beginDraw();
  c2.background(pink);
  c2.mask(c2mi);
  c2.endDraw();
  
  c1.beginDraw();
  c1.background(teal);
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
