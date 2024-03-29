import controlP5.*;

import oscP5.*;
import netP5.*;


int port = 7777;

String names[] = {"x","y","r","g","b","num","sin1","sin2","sin3","sin4","angle0",
"angle1","angle2","angle3","angle4","angle5","angle6","angle7","angle8","angle9",
"length0","length1","length2","length3","length4","length5","length6","length7","length8","length9",
"life"};


ControlP5 controlP5;
int myColor = color(0,0,0);

int sliderValue = 100;
int sliderTicks1 = 100;
int sliderTicks2 = 30;

OscP5 oscP5;


NetAddress myNetAddress = new NetAddress("239.0.0.1",port);
/* listeningPort is the port the server is listening for incoming messages */
/* the broadcast port is the port the clients should listen for incoming messages from the server*/
float val[];

/**
 * oscP5multicast by andreas schlegel
 * example shows how to send osc via a multicast socket.
 * what is a multicast? http://en.wikipedia.org/wiki/Multicast
 * ip multicast ranges and uses:
 * 224.0.0.0 - 224.0.0.255 Reserved for special �well-known� multicast addresses.
 * 224.0.1.0 - 238.255.255.255 Globally-scoped (Internet-wide) multicast addresses.
 * 239.0.0.0 - 239.255.255.255 Administratively-scoped (local) multicast addresses.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

boolean controlling = false;

void setup() {
  size(400,720,P2D);
  controlP5 = new ControlP5(this);
  oscP5 = new OscP5(this,"239.0.0.1",7777);
  
  frameRate(25);
  
  // add horizontal sliders
  
  val = new float[names.length];
  
  for(int i =0 ; i < names.length ;i++){
   val[i] = 127; 
  }
  
  int y = 30;
    for(int i =0  ;i<names.length;i++){
    controlP5.addSlider(names[i],0,255,128,30,y,width-80,10);y+=20;
  }
 

  
}

void mousePressed(){
 controlling = true; 
}
void mouseReleased(){
 controlling = false; 
}

void draw() {
  background(sliderTicks1);
 
 if(controlling)
   automate();
   
   
  controlP5.draw();
}


void automate(){
  
  for(int i =0 ; i < names.length;i++){
   controlP5.controller(names[i]).setValue(val[i]);
  }
  
}

void send(int sel){
  
  OscMessage msg = new OscMessage("/ctl");
  
    msg.add(sel);
    msg.add(val[sel]);
    
    
  
  oscP5.send(msg);
}

void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  
  if(theOscMessage.checkAddrPattern("/ctl")) {
    /* check if the typetag is the right one. */
    if(theOscMessage.checkTypetag("if")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      int sel = theOscMessage.get(0).intValue();  
      float v = theOscMessage.get(1).floatValue();
      //print("### received an osc message /test with typetag ifs.");
     
    
 
     val[sel] = v;
     
      return;
    }  
  } 
  //println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}



