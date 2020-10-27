

public class Toolbar extends PApplet {
  
  boolean prevPressed, justPressed;
  float elementHeight = 50;
  
  Toolbar() {
    super();
  } 
  
  public void settings() {
    size(150, 500);
  }
  
  void setup() {
    textFont(font);
    textSize(14);
    textAlign(CENTER, CENTER);
  }
  
  public void draw() {
    justPressed = mousePressed && !prevPressed;
    background(50);
    prevPressed = mousePressed;
    
    if(button(0, "Load Img")) {
      selectInput("Select an image to decode:", "imageDialog");
    }
    
    if(button(1, "Encode Text")) {
      selectInput("Select a text file to encode:", "textDialog");
    }
    
    if(button(2, "Save Img")) {
      selectOutput("Select a location to save:", "saveDialog");
    }
  }
  
  boolean button(int id, String label) {
    
    textSize(14);
    text(label, width / 2, id * elementHeight + elementHeight / 2);  
    return justPressed && mouseY > id * elementHeight && mouseY < (id + 1) * elementHeight;
  }
  
  void imageDialog(File file) {
    if(file == null) return;
    loadImg(file.getAbsolutePath());
  }
  
  void saveDialog(File file) {
    if(file == null) return;
    img.save(file.getAbsolutePath());
  }
  
  void textDialog(File file) {
    if(file == null) return;
    String msg = "";
    for(String str : loadStrings(file.getAbsolutePath())) {
      msg += str + "\n";
    }
    encodeText(msg);
  }
  
}
