
PImage img;
String binary;
int encodingBits = 2;
int charLimit = 2048;
int charsPerLine = 32;
String message, displayMessage;
PFont font;
int pixelShift = 0;
boolean usingTextEditor;

void settings() {
  size(800, 600);
}

void setup() {
  loadImg("test.png");
  font = createFont("font.ttf", 14);
  textFont(font);
  noStroke();
  textSize(16);
  
  String[] args = {"Toolbar"};
  Toolbar toolbar = new Toolbar();
  PApplet.runSketch(args, toolbar);
}

void draw() {
  background(50);
  fill(40);
  rect(width / 2, 0, width / 2, height);
  fill(255);
  textSize(16);
  text("Image", 15, 25);
  text("Text", width / 2 + 15, 25);
  
  float imageScale = 1;
  while(img.width / imageScale > width / 2 || img.height / imageScale > height) imageScale ++;
  float imgWidth = img.width / imageScale;
  float imgHeight = img.height / imageScale;
  
  float imageX = (width / 2 - imgWidth) / 2;
  float imageY = (height - imgHeight)  / 2;
  image(img, imageX, imageY, imgWidth, imgHeight);
  
  textSize(12);
  text(displayMessage, width / 2 + 50, 75);
}

void loadImg(String filepath) {
  img = loadImage(filepath);
  loadImageData();
}

void loadImageData() {
  usingTextEditor = false;
  binary = "";
  img.loadPixels();
  for(int i = pixelShift; i < img.pixels.length; i ++) {
    int r = floor(red(img.pixels[i]));
    appendNumberToBinary(r);
    if(binary.length() >= charLimit * 8) {
      break;
    }
    int g = floor(green(img.pixels[i]));
    appendNumberToBinary(g);
    if(binary.length() >= charLimit * 8) {
      break;
    }
    int b = floor(blue(img.pixels[i]));
    appendNumberToBinary(b);
    if(binary.length() >= charLimit * 8) {
      break;
    }
  }
  convertBinaryToText();
}

void convertBinaryToText() {
  message = "";
  displayMessage = "";
  int pointer = 0;
  char c = (char)unbinary(binary.substring(0, 8));
  while(c > 0) {
    message += c;
    displayMessage += c;
    if(message.length() % charsPerLine == 0) displayMessage += "\n";
    pointer += 8;
    if(pointer + 8 >= binary.length()) return;
    c = (char)unbinary(binary.substring(pointer, pointer + 8));
  }
}

void appendNumberToBinary(int num) {
  String numBin = binary(num % floor(pow(2, encodingBits)), encodingBits);
  binary += numBin;
}

void encodeText(String txt) {
  binary = "";
  for(int i = 0; i < txt.length(); i ++) {
    char c = txt.charAt(i);
    binary += binary(c, 8);
  }
  binary += "00000000";
  updateImageWithBinary();
  loadImageData();
}

void updateImageWithBinary() {
  img.loadPixels();
  int modulo = floor(pow(2, encodingBits));
  for(int i = 0; i < binary.length() / encodingBits; i ++) {
    int val = unbinary(binary.substring(i * encodingBits, (i + 1) * encodingBits));
    color pixel = img.pixels[i / 3 + pixelShift];
    if(i % 3 == 0) {
      int r = floor(red(pixel));
      r = modulo * floor(r / modulo) + val;
      img.pixels[i / 3 + pixelShift] = color(r, green(pixel), blue(pixel));
    }
    if(i % 3 == 1) {
      int g = floor(green(pixel));
      g = modulo * floor(g / modulo) + val;
      img.pixels[i / 3 + pixelShift] = color(red(pixel), g, blue(pixel));
    }
    if(i % 3 == 2) {
      int b = floor(blue(pixel));
      b = modulo * floor(b / modulo) + val;
      img.pixels[i / 3 + pixelShift] = color(red(pixel), green(pixel), b);
    }
  }
  img.updatePixels();
}

void keyPressed() {
  if(usingTextEditor) {
    if(key == 8) {
      if(message.length() > 0) encodeText(message.substring(0, message.length() - 1));
    } else {
      encodeText(message + key);
    }
    usingTextEditor = true;
  } else {
    encodeText("");
    usingTextEditor = true;
  }
}
