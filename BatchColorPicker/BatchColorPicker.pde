PImage source;
PImage prevCapture;
int prevColor;
int areaX = 300;
int areaY = 150;
int sampleX, sampleY;

void setup(){
  size(1000, 792);
  //source = loadImage("pink.png");
  //source = loadImage("teal.png");
  //source = loadImage("2color_pink-n-teal_grain_600dpi.png");
  selectInput("","fileSelected");
  stroke(255, 0, 255);
}

void draw(){
  if (source != null){
    PVector offset = map(mouseX, mouseY);
    copy(source, (int)offset.x, (int)offset.y, width, height, 0, 0, width, height);
    //rect(mouseX-areaX/2, mouseY-areaY/2, areaX, areaY);
    if (prevCapture != null){
      image(prevCapture, width-prevCapture.width-50, height-prevCapture.height-50);
      fill(prevColor);
      rect(width-prevCapture.width-50, height - prevCapture.height - areaY - 100, areaX, areaY);
      noFill();
    }
  }
}

void mousePressed(){
  PVector offset = map(mouseX, mouseY);
  
  //simple sampling
  //println(hex(source.get((int)offset.x + mouseX, (int)offset.y + mouseY)));
  
  ////area sampling
  //prevCapture = source.get((int)offset.x + mouseX - areaX/2, (int)offset.y + mouseY - areaY/2, areaX, areaY);
  //int r = 0, g = 0, b = 0;
  //for(int pixel : prevCapture.pixels){
  //  r += red(pixel);
  //  g += green(pixel);
  //  b += blue(pixel);
  //}
  //r /= prevCapture.pixels.length;
  //g /= prevCapture.pixels.length;
  //b /= prevCapture.pixels.length;
  //prevColor = color(r, g, b);
  //println(hex(prevColor));
  
  //selection sampling
  sampleX = (int)offset.x + mouseX;
  sampleY = (int)offset.y + mouseY;
}

void mouseReleased(){
  PVector offset = map(mouseX, mouseY);
  int w = (int)offset.x + mouseX - sampleX;
  int h = (int)offset.y + mouseY - sampleY;
  if (w == 0 || h == 0){
    //simple sampling
    int x = (int)offset.x + mouseX;
    int y = (int)offset.y + mouseY;
    println("sampling " + x + ", " + y);
    prevColor = source.get(x, y);
    println(hex(prevColor));
  } else {
    println("sampling " + sampleX + ", " + sampleY + ": " + w + ", " + h);
    prevColor = sampleArea(source, sampleX, sampleY, w, h);
    println(hex(prevColor));
  }
}

int sampleArea(PImage src, int x, int y, int w, int h){
  PImage sample = source.get(x, y, w, h);
  int r = 0, g = 0, b = 0;
  for(int pixel : sample.pixels){
    r += red(pixel);
    g += green(pixel);
    b += blue(pixel);
  }
  r /= sample.pixels.length;
  g /= sample.pixels.length;
  b /= sample.pixels.length;
  return color(r, g, b);
}

PVector map(int x, int y){
  int sourceX = round(map(max(areaX/2, x), areaX/2, width, 0, source.width-width));
  int sourceY = round(map(y, 0, height, 0, source.height-height));
  return new PVector(sourceX, sourceY);
}

void fileSelected(File selection){
  if (selection == null){
    println("no file selected");
  } else {
    source = loadImage(selection.getAbsolutePath());
    source.loadPixels();
  }
}
