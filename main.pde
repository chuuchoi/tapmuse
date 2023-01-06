/*
  There is code from server.
  Only for this code to work well, communicate with myself.
*/
import controlP5.*;
import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

OscP5        oscP5tcpClient;
ControlP5    cp5;
AudioPlayer  jingle,bgm;
Menu         menu;
Pause        pause;
Result       result;
Play         play;
Minim        minim;
String music;
ArrayList<String> musics;
ArrayList<Integer> scores;
char gameState;
char preState;
boolean start;
PFont font;
float[] bins;
int specsize, score;
final int BUFFER_SIZE = 2048;
Note[] notes;

void setup() {
  // Code for server
  ////////////////////////////////////////////////////////////
  oscP5tcpServer = new OscP5(this, 11000, OscP5.TCP);
  afft = new AFFT();
  ////////////////////////////////////////////////////////////
  
  oscP5tcpClient = new OscP5(this, "127.0.0.1", 11000, OscP5.TCP);
  cp5 = new ControlP5(this);
  minim = new Minim(this);
  bgm = minim.loadFile("second run.mp3");
  musics = new ArrayList<String>();
  scores = new ArrayList<Integer>();
  menu = new Menu();
  pause = new Pause();
  result = new Result();
  play = new Play();
  notes = new Note[6];
  size(1800,980);
  font = createFont("arial", 54);
  score=0;
  try{
    loadData("data.xml");
  }catch(Exception e){println("error occured while loading data");}
}

void draw() {
  if(!start){
    background(30);
    oscP5tcpClient.send("/reset", new Object[] {"reset"});
    bgm.play();
    textFont(font);
    textAlign(CENTER);
    text("Tap Muse",width/2,height/2);
    textSize(18);
    text("Touch to Start", width/2, height/2+108);
  }else{
    bgm.pause();
    bgm.rewind();
  }
  switch(gameState){
    case 'A': // menu menu
      menu.draw();
      break;
    case 'B': // game play
      play.draw();
      break;
    case 'C': // game pause
      pause.draw();
      break;
    case 'D': // game result
      result.draw();
      break;
  }
}

void mousePressed(){
  if(!start) gameState='A';
  start=true;
  for(int i=0; i<6; i++)
    if(notes[i]!=null){
      if(notes[i].isTapped(mouseX,mouseY)) score++;
    }
}

void oscEvent(OscMessage theMessage) {
  if(theMessage.checkAddrPattern("/response")) {
    specsize=theMessage.get(BUFFER_SIZE/2+1).intValue();
    bins=new float[specsize];
    for(int i=0; i<specsize;i++){
      bins[i]=theMessage.get(i).floatValue();
    }
  }
  if(theMessage.checkAddrPattern("/done")) {
    preState = gameState;
    gameState = 'D';
  }
  
  
  
  
  //Code for server
  ///////////////////////////////////////////////////////////////////////
  //System.out.println("### got a message " + theMessage);
  if(theMessage.checkAddrPattern("/music")){
    if(theMessage.checkTypetag("s")){
      String music = theMessage.get(0).stringValue();
      if(first){
        try{
          jingle2 = minim.loadFile(music, BUFFER_SIZE);
        }catch (Exception e){println("check file format is right; "+music);}
        fft = new FFT( jingle2.bufferSize(), jingle2.sampleRate() );
        jingle2.play();
        first=false;
      }
      afft.forward();
      OscMessage m = new OscMessage("/response");
      m.add(afft.getBand());
      m.add(afft.specSize());
      oscP5tcpServer.send(m,theMessage.tcpConnection());
      if(!jingle2.isPlaying()){
        OscMessage m2 = new OscMessage("/done");
        m2.add(new Object[] {"music is done"});
        oscP5tcpServer.send(m2,theMessage.tcpConnection());
      }
    }
  }
  if(theMessage.checkAddrPattern("/pause")){
    if(theMessage.checkTypetag("s")){
    jingle2.pause();
    }
  }
  if(theMessage.checkAddrPattern("/replay")){
    if(theMessage.checkTypetag("s")){
    jingle2.rewind();
    jingle2.play();
    }
  }
  if(theMessage.checkAddrPattern("/reset")){
    try{
    jingle2.pause();
    jingle2.rewind();
    }catch (Exception e){}
    first=true;
  }
  ////////////////////////////////////////////////////////////////////
  
  
  
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isController()) {
    for(String s : musics){
      if(theEvent.getController().getName().equals(s)) {
        music = s+".mp3";
        jingle = minim.loadFile(music);
        preState = gameState;
        gameState = 'B';
      }
    }
    if(theEvent.getController().getName().equals("replay")) {
      oscP5tcpClient.send("/replay", new Object[] {"replay"});
      jingle.rewind();
      score=0;
      preState = gameState;
      gameState = 'B';
    }
    if(theEvent.getController().getName().equals("return")) {
      oscP5tcpClient.send("/reset", new Object[] {"reset"});
      preState = gameState;
      gameState = 'A';
    }
    if(theEvent.getController().getName().equals("pause")) {
      oscP5tcpClient.send("/pause", new Object[] {"pause"});
      preState = gameState;
      gameState = 'C';
    }
  }
}

public void removeButtons(){
    if(cp5.getController("exit")!=null)
      cp5.getController("exit").remove();
    for(String s : musics){
      if(cp5.getController(s)!=null)
        cp5.getController(s).remove();
    }
    if(cp5.getController("replay")!=null)
      cp5.getController("replay").remove();
    if(cp5.getController("return")!=null)
      cp5.getController("return").remove();
    if(cp5.getController("pause")!=null)
      cp5.getController("pause").remove();
}

public void callReset(){
    menu.callMethod=true;
    pause.callMethod=true;
    play.callMethod=true;
    result.callMethod=true;
}

void loadData(String filename){
  XML xml = loadXML(filename);
  XML[] children = xml.getChildren("Music");
  scores=new ArrayList<Integer>();
  for(XML c : children){
    if(!musics.contains(c.getString("music"))) musics.add(c.getString("music"));
    scores.add(c.getInt("score"));
  }
}

void saveData(String filename){
  XML xml = loadXML(filename);
  XML[] children = xml.getChildren("Music");
  for(XML c : children){
    if(music.equals(c.getString("music")+".mp3"))
      c.setInt("score",score);
  }
  saveXML(xml,"/data/data.xml");
}

// Code for sever
//////////////////////////////////////////////////////////
void keyPressed(){
  println(oscP5tcpServer.tcpServer().getClients().length);
}
//////////////////////////////////////////////////////////