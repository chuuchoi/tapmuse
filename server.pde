/*
  Code for sever
*/
import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

FFT          fft;
AudioPlayer  jingle2;
//Minim        minim;
OscP5        oscP5tcpServer;
NetAddress   myServerAddress;
AFFT         afft;
boolean first=true;
//final int BUFFER_SIZE = 2048;

//void setup(){
//  oscP5tcpServer = new OscP5(this, 11000, OscP5.TCP);
//  minim = new Minim(this);
//  afft = new AFFT();
//}

//void draw(){
//  background(0);
//}

//void keyPressed(){
//  println(oscP5tcpServer.tcpServer().getClients().length);
//}

//void oscEvent(OscMessage theMessage){
//  System.out.println("### got a message " + theMessage);
//  if(theMessage.checkAddrPattern("/music")){
//    if(theMessage.checkTypetag("s")){
//      String music = theMessage.get(0).stringValue();
//      if(first){
//        try{
//          jingle2 = minim.loadFile(music, BUFFER_SIZE);
//        }catch (Exception e){println("check file format is right; "+music);}
//        fft = new FFT( jingle2.bufferSize(), jingle2.sampleRate() );
//        jingle2.play();
//        first=false;
//      }
//      afft.forward();
//      OscMessage m = new OscMessage("/response");
//      m.add(afft.getBand());
//      m.add(afft.specSize());
//      oscP5tcpServer.send(m,theMessage.tcpConnection());
//      if(!jingle2.isPlaying()){
//        OscMessage m2 = new OscMessage("/done");
//        m2.add(new Object[] {"music is done"});
//        oscP5tcpServer.send(m2,theMessage.tcpConnection());
//      }
//    }
//  }
//  if(theMessage.checkAddrPattern("/pause")){
//    if(theMessage.checkTypetag("s")){
//    jingle2.pause();
//    }
//  }
//  if(theMessage.checkAddrPattern("/replay")){
//    if(theMessage.checkTypetag("s")){
//    jingle2.rewind();
//    jingle2.play();
//    }
//  }
//  if(theMessage.checkAddrPattern("/reset")){
//    try{
//    jingle2.pause();
//    jingle2.rewind();
//    }catch (Exception e){}
//    first=true;
//  }
//}

public class AFFT{
  private float[] x;
  private int y;
  
  public void forward(){
    fft.forward( jingle2.mix );
    x=new float[fft.specSize()];
    for(int i = 0; i < fft.specSize() ; i++){
      x[i]=fft.getBand(i);
    }
    y=fft.specSize();
  }
  public float[] getBand(){
    return x;
  }
  public int specSize(){
    return y;
  }
}