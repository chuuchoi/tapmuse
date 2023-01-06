public class Play {  //gameState B
  private boolean callMethod = true;
  
  public void draw() {
    if (callMethod) {
      removeButtons();
      drawButtons();
      callReset();
      jingle.play();
      callMethod = false;
    }
    background(30);
    textAlign(CENTER);
    textSize(72);
    fill(160);
    text("Score: "+score, width/2, height/5);
    oscP5tcpClient.send("/music", new Object[] {music});
    makeNotes();

    for (int i = 0; i < notes.length; i++)
    {
      Note n = notes[i];
      if (n!=null) {
        if (n.isDead())
          notes[i]=null;
        else
          n.draw();
      }
    }
  }

  public void drawButtons() {
    cp5.addButton("pause")
      .setPosition(width/40, height/40)
      .setImage(loadImage("pause.png"))
      .updateSize();
  }

  public void makeNotes() {
    addNote(0,0,5,100);
    addNote(1,5,12,100);
    addNote(2,12,23,80);
    addNote(3,23,40,80);
    addNote(4,40,65,60);
    addNote(5,65,150,60);
  }

  public void addNote(int n, int fromBin, int toBin, int threshold) {
    float maxValue;
    int maxBin;
    maxValue = threshold;
    maxBin = -1;

    for (int i = fromBin; i < toBin; i++)
    {
      if (bins!=null) {
        if (bins[i] > maxValue) {
          maxValue = bins[i];
          maxBin = i;
        }
      }
    }
    if (maxBin>0) {
      if (notes[n]==null) notes[n]=new Note(n);
    }
  }
}