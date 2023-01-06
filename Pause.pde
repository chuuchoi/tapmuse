public class Pause {  //gameState C
  private boolean callMethod = true;
  private int SPACE;
  
  public void draw() {
    if(callMethod) {
      removeButtons();
      drawButtons();
      callReset();
      callMethod = false;
      jingle.pause();
    }
    fill(125);
    noStroke();
    rect(width/5,height/4,width*3/5,height/2);
  }
  
  public void drawButtons() {
    Button c = cp5.addButton("replay")
                   .setImage(loadImage("replay.png"))
                   .updateSize();
    Button c2 = cp5.addButton("return")
                    .setImage(loadImage("return.png"))
                    .updateSize();
    SPACE=(width*3/5-c.getWidth()-c2.getWidth())/3;
    c.setPosition(width/5+SPACE,height/2-c.getHeight()/2);
    c2.setPosition(width*4/5-c2.getWidth()-SPACE,height/2-c2.getHeight()/2);
  }
}