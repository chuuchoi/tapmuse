public class Note{
  private int x,LEFT,RIGHT,TOP,BOTTOM;
  private float duration;
  private boolean alreadyTapped;
  private final int MARGIN = width/10;
  private final int SPACE = width*2/105;
  private final int WIDTH = width/9;
  private final int HEIGHT = WIDTH/2;
  private final int ROUND = width/60;
  
  Note(int x){
    this.x=x;
    LEFT=MARGIN+SPACE*(x+1)+WIDTH*x;
    RIGHT=LEFT+WIDTH;
    TOP=height*7/10;
    BOTTOM=TOP+HEIGHT;
    duration = frameRate*2/5;
  }
  
  public void draw() {
    pushStyle();
    if(x==0){
    stroke(250,0,0, map(duration, frameRate/3, 0, 255, 0));
    fill(255,0,0, map(duration, frameRate/3, 0, 255, 0));
    }
    else if(x==1){
    stroke(0,0,222, map(duration, frameRate/3, 0, 255, 0));
    fill(5,0,222, map(duration, frameRate/3, 0, 255, 0));
    }
    else if(x==2){
    stroke(0,222,0, map(duration, frameRate/3, 0, 255, 0));
    fill(2,220,0, map(duration, frameRate/3, 0, 255, 0));
    }
    else if(x==3){
    stroke(200,202,0, map(duration, frameRate/3, 0, 255, 0));
    fill(213,213,0, map(duration, frameRate/3, 0, 255, 0));
    }
    else if(x==4){
    stroke(100,222,210, map(duration, frameRate/3, 0, 255, 0));
    fill(102,222,210, map(duration, frameRate/3, 0, 255, 0));
    }
    else if(x==5){
    stroke(239,62,220, map(duration, frameRate/3, 0, 255, 0));
    fill(239,59,240, map(duration, frameRate/3, 0, 255, 0));
    }else{
    stroke(255, map(duration, frameRate/3, 0, 255, 0));
    fill(255, map(duration, frameRate/3, 0, 255, 0));
    }
    duration--;
    if (duration > 0){
      rect(LEFT,TOP,WIDTH,HEIGHT,ROUND,ROUND,ROUND,ROUND);
    }
    popStyle();
    
  }
 
  public boolean isTapped(int x, int y) {
    if(alreadyTapped) return false;
    if(LEFT>x||RIGHT<x) return false;
    if(TOP>y||BOTTOM<y) return false;
    else alreadyTapped=true;
    return true;
  }
  
  public boolean isDead(){
    return (duration<=0);
  }
}