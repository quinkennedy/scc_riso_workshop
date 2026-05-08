import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

PGraphics pgTeal, pgTealMask, pgPink, pgPinkMask, preview;
color pink = color(255, 72, 176);
color teal = color(0, 157, 165, 200);
int dpi = 600;
int pagew = (int)(8.5*dpi);
int pageh = (int)(14*dpi);

void setup(){
  size(1020, 840);//60dpi
  pgTeal = createGraphics(pagew, pageh);
  pgPink = createGraphics(pagew, pageh);
  pgTealMask = createGraphics(pagew, pageh);
  pgPinkMask = createGraphics(pagew, pageh);
  preview = createGraphics(pagew, pageh);
}

void draw(){
  noLoop();
  renderGrid();
  renderRegistration();
  renderTitle();
  renderPreview();
}

void renderTitle(){
  pgTeal.beginDraw();
  pgTeal.textSize(100);
  pgTeal.textAlign(CENTER);
  pgTeal.text(
    "SCC Risograph Workshop Contact Sheet\nprinted 6 May 2026 using Fluorescent Pink and Light Teal", 
    pagew/2, 
    300);
  pgTeal.endDraw();
}

void renderRegistration(){
  renderRegistration(pgTeal);
  renderRegistration(pgPink);
}
void renderRegistration(PGraphics pg){
  pg.beginDraw();
  pg.stroke(0);
  pg.strokeWeight(10);
  renderCross(pg, 600, 300);
  renderCross(pg, pagew-600, 300);
  renderCross(pg, pagew/2, pageh-900);
  pg.endDraw();
}
void renderCross(PGraphics pg, int x, int y){
  pg.line(x, y-100, x, y+100);
  pg.line(x-100, y, x+100, y);
}

void renderGrid(){
  // Use dataPath("") to get the path to the data folder
  java.io.File folder = new java.io.File(dataPath(""));
  
  // List all filenames in that folder
  String[] filenames = sort(folder.list());
  String[] nameList = new String[10];
  String[][][] nameGrid = new String[10][6][3];
  int skippedSamples = 0;
  int skippedPeople = 0;
  int placedSamples = 0;
  
  for(String filename:filenames){
    //println("processing " + filename);
    int extI = filename.lastIndexOf('.');
    if (!filename.endsWith(".png")){
      println("unsupported extension: " + filename);
      continue;
    }
    String filenameBody = filename.substring(0, extI);
    int layerI = filenameBody.lastIndexOf('_');
    String filenameName = filenameBody.substring(0, layerI);
    String layer = filenameBody.substring(layerI+1).toLowerCase();
    if (!layer.startsWith("pink") && !layer.startsWith("teal")){
      println("unsupported layer: " + filename);
      continue;
    }
    int userI = filenameName.indexOf('_');
    String username = filenameName.substring(0, userI);
    int nameListIndex = 0;
    while(nameListIndex < nameList.length 
      && nameList[nameListIndex] != null 
      && !nameList[nameListIndex].equals(username))
    {
      nameListIndex++;
    }
    if(nameListIndex >= nameList.length){
      println("out of space for user: " + username);
      skippedPeople++;
      continue;
    } else if (nameList[nameListIndex] == null) {
      //println("putting " + username + " at " + nameListIndex);
      nameList[nameListIndex] = username;
    } else {
      //println("found " + username + " at " + nameListIndex);
    }
    int nameGridIndex = 0;
    while (nameGridIndex < nameGrid[nameListIndex].length
      && nameGrid[nameListIndex][nameGridIndex][0] != null
      && !nameGrid[nameListIndex][nameGridIndex][0].equals(filenameName)){
      nameGridIndex++;
    }
    if (nameGridIndex >= nameGrid[nameListIndex].length){
      println("out of space for sample: " + filenameName);
      skippedSamples++;
      continue;
    } else if (nameGrid[nameListIndex][nameGridIndex][0] == null){
      //println("putting " + filenameName + " at " + nameGridIndex);
      nameGrid[nameListIndex][nameGridIndex][0] = filenameName;
      nameGrid[nameListIndex][nameGridIndex][layer.startsWith("pink") ? 1 : 2] = filename;
      placedSamples++;
    } else {
      //println("found " + filenameName + " at " + nameGridIndex);
      nameGrid[nameListIndex][nameGridIndex][layer.startsWith("pink") ? 1 : 2] = filename;
    }
  }
  
  renderGrid(pgTeal, nameList, nameGrid, 2, true);
  renderGrid(pgPink, nameList, nameGrid, 1, false);
  
  println("skipped " + skippedPeople + " people");
  println("skipped " + skippedSamples + " samples");
  println("placed " + placedSamples + " samples");
}

void renderGrid(PGraphics pg, String[] nameList, String[][][] nameGrid, int layerIndex, boolean includeNames){
  int margin = 150;
  int topMargin = 500;
  int xGutter = ((pagew-margin*2)-(nameGrid[0].length * 600))/nameGrid[0].length;
  int yGutter = ((pageh-margin-topMargin)-(nameList.length * 600))/nameList.length;
  pg.beginDraw();
  pg.background(255);
  pg.fill(0);
  pg.pushMatrix();
  pg.translate((int)(xGutter/2+margin), (int)(yGutter/2+topMargin));
  for(int y = 0; y < nameList.length && nameList[y] != null; y++){
    pg.pushMatrix();
    if (includeNames){
      pg.textSize(80);
      pg.textAlign(LEFT);
      //pg.text(nameList[y], 0, -50);
    }
    for(int x = 0; x < nameGrid[y].length && nameGrid[y][x] != null; x++){
      String imgName = nameGrid[y][x][layerIndex];
      if (imgName != null){
        PImage img = loadImage(imgName);
        pg.image(img, 0, 0, 600, 600);
        if (includeNames){
          pg.textSize(50);
          pg.text(nameGrid[y][x][0], 0, 670);
        }
      }
      pg.translate(xGutter + 600, 0);
    }
    pg.popMatrix();
    pg.translate(0, yGutter + 600);
  }
  pg.popMatrix();
  pg.endDraw();
}

void renderPreview(){
  image(pgTeal, 0, 0, width/2, height);
  image(pgPink, width/2, 0, width/2, height);
  /*
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
  */
}

void keyPressed(){
  if(key == 'p'){
    LocalDateTime now = LocalDateTime.now();
    DateTimeFormatter format = DateTimeFormatter.ofPattern("yyyy-MM-dd-HH-mm-ss");
    String nowString = now.format(format);
    pgTeal.save(nowString + "_teal.png");
    pgPink.save(nowString + "_pink.png");
  } else if (key == 'r'){
    loop();
  }
}
