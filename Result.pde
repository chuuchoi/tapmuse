public class Result  {  //gameState D
  private boolean callMethod = true;
  private int SPACE;
  
  public void draw() {
    if(callMethod) {
      removeButtons();
      drawButtons();
      callReset();
      saveScore();
      loadData("data.xml");
      callMethod = false;
    }
    background(125);
    textAlign(CENTER);
    textSize(54);
    fill(200);
    text("Score: "+score,width/5,height/3);
    if(score<scores.get(indexOf(music)))
      text("Best Score: "+scores.get(indexOf(music)),width/5,height*2/3);
    else
      text("Best Score: "+score+"   NEW!",width/5,height*2/3);
    fill(60);
    strokeWeight(6);
    line(width*2/5,0,width*2/5,height);
  }
 
  public void drawButtons() {
    Button c = cp5.addButton("replay")
                   .setImage(loadImage("replay.png"))
                   .updateSize();
    Button c2 = cp5.addButton("return")
                    .setImage(loadImage("return.png"))
                    .updateSize();
    SPACE=(width*3/5-c.getWidth()-c2.getWidth())/3;
    c.setPosition(width*2/5+SPACE,height/2-c.getHeight()/2);
    c2.setPosition(width-c2.getWidth()-SPACE,height/2-c2.getHeight()/2);
  }
  
  public int indexOf(String music){
    int counter=0;
    for(String s : musics){
      if(music.equals(s+".mp3")){
        return counter;
      }
      counter++;
    }
    return 0;
  }
  
  public void saveScore(){
    if(scores.get(indexOf(music))<score)
    saveData("data.xml");
  }
}