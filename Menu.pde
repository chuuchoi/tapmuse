public class Menu  {  //gameState A
  private boolean callMethod = true;
  private final int SPACE=height/25;
  
  public void draw() {
    if(callMethod) {
      score=0;
      removeButtons();
      drawButtons();
      callReset();
      callMethod = false;
    }
    background(240);
    textAlign(CENTER);
    fill(60);
    textSize(84);
    text("Select music",width/5,height/2);
    strokeWeight(6);
    line(width*2/5,0,width*2/5,height);
  }
  
  public void drawButtons() {
    cp5.addButton("exit")
       .setPosition(width/40,height/40)
       .setImage(loadImage("exit.png"))
       .updateSize().getHeight();
    
    int h=0;
    for(String s : musics){
      h = cp5.addButton(s)
         .setPosition(width/2,height/10+h)
         .setImage(loadImage(s+".png"))
         .updateSize()
         .getHeight();
      h=h+SPACE;
    }
  }
}