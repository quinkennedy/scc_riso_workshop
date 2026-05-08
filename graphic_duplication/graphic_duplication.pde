import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

void setup(){
  size(600, 600);
}

void draw(){
  noLoop();
  //holes();
  //curveFrame();
  curveMillis();
  //slightRotation();
}

void slightRotation(){
  rectMode(CENTER);
  translate(width/2, height/2);
  rect(0, 0, 3, height);
  rotate(PI*(0.3/180));
  rect(0, 0, 3, height);
}

void curveMillis(){
  background(255);
  int xstep = 60;
  strokeWeight(12);
  noiseSeed(millis());
  for(int y = 0; y < height; y += 24){
    beginShape();
    for(int x = -xstep; x <= width+xstep; x += xstep){
      float n = noise(x*.001, y*.001);
      curveVertex(x, y + n*100);
    }
    endShape();
  }
}

void curveFrame(){
  background(255);
  int xstep = 60;
  strokeWeight(12);
  //noiseSeed(millis());
  for(int y = 0; y < height; y += 24){
    beginShape();
    for(int x = -xstep; x <= width+xstep; x += xstep){
      float n = noise(x*.001, y*.001, frameCount*.05);
      curveVertex(x, y + n*100);
    }
    endShape();
  }
}

void holes(){
  background(255);
  int step = 60;
  ellipseMode(CENTER);
  strokeWeight(5);
  noiseSeed(millis());
  for(int x = 0; x < width; x += step){
    for(int y = 0; y < height; y += step){
      float n = noise(x, y);
      ellipse(x+step/2, y+step/2, n*step, n*step);
    }
  }
}

void keyPressed(){
  if(key == 'p'){
    LocalDateTime now = LocalDateTime.now();
    DateTimeFormatter format = DateTimeFormatter.ofPattern("yyyy-MM-dd-HH-mm-ss");
    String nowString = now.format(format);
    save(nowString + ".png");
  } else if (key == 'r'){
    loop();
  }
}
