import arb.soundcipher.*;
import arb.soundcipher.constants.*;
import processing.serial.*;


//sara
PImage noteImage;
PImage clefImage;
PImage sharpImage;
float [] notloc= new float[16];
boolean sharp=false;
boolean upline=false;
boolean middlec=false;
int row=0;
int notenumber=1;


Serial port;
int trumpets[] = new int[48];

SoundCipher sc = new SoundCipher(this);

boolean detectBlow(){
  
  port.write(10);
  while(port.available() == 0){}
  int val = port.read();
  println("blow: "+val);
  return (val > 0);
  
}

int index(){
  port.write(11);
  while(port.available() == 0){}
  int val = port.read();
  println("index: "+val);
  return (val);
}

int middle(){
  port.write(12);
  while(port.available() == 0){}
  int val = port.read();
  println("middle: "+val);
  return (val);
}

int ring(){
  port.write(13);
  while(port.available() == 0){}
  int val = port.read();
  println("ring: "+val);
  return (val);
}

int pinky(){
  port.write(14);
  while(port.available() == 0){}
  int val = port.read();
  println("pinky: "+val);
  return (val);
}

int lowOct(){
  port.write(15);
  while(port.available() == 0){}
  int val = port.read();
  println("lowOct: "+val);
  return (val);
}

int highOct(){
  port.write(16);
  while(port.available() == 0){}
  int val = port.read();
  println("highOct: "+val);
  return (val);
}

void setup() {
  frameRate(10);
  println(Serial.list());
  port = new Serial(this, Serial.list()[0], 9600);
  Note note = new Note(); 
  sc.instrument = sc.TRUMPET;
  initTrumpet();
  //println("Note: "+trumpets[play]);
  //sara
  size(600,600);
  popnotloc();
  clefImage = loadImage("GClef.png");
  sharpImage= loadImage("sharp.png");
    background(color(255, 255, 255));
  image(clefImage, 20,height*.158333, height*.0666, height*.1833);
  image(clefImage, 20,height*.425, height*.0666, height*.1833);
  image(clefImage, 20, height*.69166, height*.0666, height*.1833);
 
  fill(color(0, 0, 0));
  strokeWeight(3);

  line(0, height*.1666, width, height*.1666);
  line(0, height*.2, width, height*.2);
  line(0, height*.2333, width, height*.2333);
  line(0, height*.2666, width, height*.2666);
  line(0, height*.3, width, height*.3);
  
  line(0, height*.4333, width, height*.4333);
  line(0, height*.4666, width, height*.4666);
  line(0, height*.5, width, height*.5);
  line(0, height*.5333, width, height*.5333);
  line(0, height*.5666, width, height*.5666);
  
  line(0, height*.7, width, height*.7);
  line(0, height*.7333, width, height*.7333);
  line(0, height*.7666, width, height*.7666);
  line(0, height*.8, width, height*.8);
  line(0, height*.8333, width, height*.8333);
}

class Note {

  int octave = 0;
  int lookUp = 0;
  int octaveOffset = 0;
  
  int note = -1;
  
  Note() {    
    octaveOffset = 0;
    if (lowOct() == 1) octaveOffset = 16;
    if (highOct() == 1) octaveOffset = 32;
    
    lookUp = index()*8 + middle()*4 + ring()*2 + pinky();
    note = lookUp + octaveOffset;    
    
    println("Total: "+note+", binary: "+lookUp+", octave: "+octaveOffset);
  }  
  public int getNote() {
    return note;
  }
}

boolean beingPlayed = false;
Note prevNote = null;

void draw() {
  if (detectBlow()) {
    Note curNote = new Note();
    if (beingPlayed) {
      if ((prevNote != null) && (prevNote.getNote() != curNote.getNote())) {
        sc.playNote(trumpets[curNote.getNote()],100,20);
        prevNote = curNote;
        notelocation(trumpets[curNote.getNote()]);
      }
    } else {
      sc.playNote(trumpets[curNote.getNote()], 100, 20);
      beingPlayed = true;
      notelocation(trumpets[curNote.getNote()]);
      prevNote = curNote;
    }
  } else {
    if (beingPlayed) {
      sc.stop();
      beingPlayed = false;
    }
  }
 
}
      
void keyPressed()
{ 
  Note note = new Note();
  sc.playNote(trumpets[note.getNote()],100,2);
  beingPlayed = true; 
}

public void initTrumpet() {
  for (int i = 0; i < trumpets.length; i++) {
    trumpets[i] = 0;
  }
  /*Array items with '//' next to them aren't real notes on a trumpet,
    but are filled in for consistency. Each real note also has it's 
    index + 1 as the same note, i.e trumepts[8] and trumpets[9]
    are both F, because the 4th finger (1 bit) doesn't exist on a trumpet.*/
 
  int C = 60;
  int Cs = 61;
  int D = 62;
  int Ds = 63;
  int E = 64;
  int F = 65;
  int Fs = 66;
  int G = 67;
  int Gs = 68;
  int A = 69;
  int Bb = 70;
  int B = 71;
  int high_C = 72;
  int high_Cs = 73;
  int high_D = 74;
  int high_Ds = 75;
  
  trumpets[0] = C;
  trumpets[1] = C;
  trumpets[2] = C;//
  trumpets[3] = C;//
  trumpets[4] = Fs;
  trumpets[5] = Fs;
  trumpets[6] = Ds;
  trumpets[7] = Ds;
  trumpets[8] = F;
  trumpets[9] = F;
  trumpets[10] = D;
  trumpets[11] = D;
  trumpets[12] = E;
  trumpets[13] = E;
  trumpets[14] = Cs;
  trumpets[15] = Cs;
  trumpets[16] = G;
  trumpets[17] = G;
  trumpets[18] = G;//
  trumpets[19] = G;//
  trumpets[20] = B;
  trumpets[21] = B;
  trumpets[22] = Gs;
  trumpets[23] = Gs;
  trumpets[24] = Bb;
  trumpets[25] = Bb;
  trumpets[26] = Bb;//
  trumpets[27] = Bb;//
  trumpets[28] = A;
  trumpets[29] = A; 
  trumpets[30] = A;//
  trumpets[31] = A;//
  trumpets[32] = high_C;
  trumpets[33] = high_C;
  trumpets[34] = high_C;//
  trumpets[35] = high_C;//
  trumpets[36] = high_Ds;
  trumpets[37] = high_Ds;
  trumpets[38] = high_Ds;//
  trumpets[39] = high_Ds;//
  trumpets[40] = high_D;
  trumpets[41] = high_D;
  trumpets[42] = high_D;//
  trumpets[43] = high_D;//
  trumpets[44] = high_Cs;
  trumpets[45] = high_Cs;
  trumpets[46] = high_Cs;//
  trumpets[47] = high_Cs;//
}




void notelocation(int y){
  if(y < 60 || y > 75){
    
  }
  else{
  if((y-60)==1 ||(y-60)==3 || (y-60)==6 || (y-60)==8 ||
      (y-60)==10 || (y-60)==13 || (y-60)==15){
         sharp=true;
      }
  if((y-60)<=11){
    upline=true;
  }
  if(notenumber>= (int)((width-height*.11666)/( (float) height*.0375) ) ){
    row++;
    notenumber=1;
  }
  if(y==60 || y==61){
    middlec=true;
  }  
  if(row==0){
    drawNote(notenumber, notloc[y-60]);
  }
  else if (row==1){
    drawNote(notenumber, notloc[y-60]+height*.2666);
  }
  else if(row==2){
    drawNote(notenumber, notloc[y-60]+height*.5333);
  }
  else{
     row=0;
     redrawscreen();
     drawNote(notenumber, notloc[y-60]);
  }
  }
}

void redrawscreen(){
  background(color(255, 255, 255));
  image(clefImage, 20,height*.158333, height*.0666, height*.1833);
  image(clefImage, 20,height*.425, height*.0666, height*.1833);
  image(clefImage, 20, height*.69166, height*.0666, height*.1833);
 
  fill(color(0, 0, 0));
  strokeWeight(3);

  line(0, height*.1666, width, height*.1666);
  line(0, height*.2, width, height*.2);
  line(0, height*.2333, width, height*.2333);
  line(0, height*.2666, width, height*.2666);
  line(0, height*.3, width, height*.3);
  
  line(0, height*.4333, width, height*.4333);
  line(0, height*.4666, width, height*.4666);
  line(0, height*.5, width, height*.5);
  line(0, height*.5333, width, height*.5333);
  line(0, height*.5666, width, height*.5666);
  
  line(0, height*.7, width, height*.7);
  line(0, height*.7333, width, height*.7333);
  line(0, height*.7666, width, height*.7666);
  line(0, height*.8, width, height*.8);
  line(0, height*.8333, width, height*.8333);
  
}

void drawNote(float x, float y){
  fill(color(255, 255, 255, 0));
  strokeWeight(3);
  
  if(sharp==true){
    image(sharpImage, height*.067+notenumber*.0375*height, y-height*.015, 0.0375 * height, 0.03125 * height);
  }
  if(middlec==true){
    line(height*.092+notenumber*.0375*height,y,height*.14+notenumber*.0375*height,y);
  }
  if(upline==true){
     line(height*.135+notenumber*.0375*height, y, height*.135+notenumber*.0375*height, y-height*.075);
  }
  else{
    line(height*.098+notenumber*.0375*height, y, height*.098+notenumber*.0375*height, y+height*.075);
  }
  
  ellipse(height*.11666+notenumber*.0375*height, y, 0.0375 * height, 0.03125 * height);
  
  notenumber=notenumber+3;
  sharp=false;
  upline=false;
  middlec=false;
}

void popnotloc(){
  //middle c
    notloc[0]=.3333*height;
  //c#
    notloc[1]=.3333*height;
  //d
    notloc[2]=.31666*height;
  //d#
    notloc[3]=.31666*height;
  //e
    notloc[4]=.3*height;
  //f
    notloc[5]=.28333*height;
  //f#
    notloc[6]=.28333*height;
  //g
    notloc[7]=.2666*height;
  //g#
    notloc[8]=.2666*height;
  //a
    notloc[9]=.25*height;
  //a#
    notloc[10]=.25*height;
  //b
    notloc[11]=.2333*height;
  //c
    notloc[12]=.21666*height;
  //c#
    notloc[13]=.21666*height;
  //d
    notloc[14]=.2*height;
  //d#  
    notloc[15]=.2*height;
}


