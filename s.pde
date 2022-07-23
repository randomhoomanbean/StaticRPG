/*
To run, keep all files (images + sound + font) in the same folder as the .pde file and download the sound package
Sketch > Import Library > Add Library > Sound

Press X for gameplay and story explaination (best done after playing through the game)

Stuff might take a bit to load, including during the game directly after the dialogue.
If nothing appears after a minute, then something probably broke
*/


import processing.sound.*;

//variables;
int screen = 0, frame = 0, part=0, lastClick=0, staticLevel=0;
int startSelection = 0;
PFont f1; //font
String message=""; //message used in dialogue

//creates entities
StaticCharacter staticChar = new StaticCharacter("???");
Entity nullChar = new Entity("NULL", "n", 20, 0); 
Entity page = new Entity("OLD PAGE", "page", (float)((int)(Math.random()*200+250)*(Math.pow(-1, (int)(Math.random()*5)+1))), (float)((int)(Math.random()*200+250)*(Math.pow(-1, (int)(Math.random()*5)+1)))); //randomize location of page entity

//music + beat detector
BeatDetector beats;
SoundFile music;

//images + sound effects
PImage images[] = new PImage[10]; //StartingScreen, arrow, folder, opened page, eye
SoundFile sfx[] = new SoundFile[10]; //Mouse click, 

boolean noteOpen = false; //checks if the note is opened


//generates dialogue
void typingAnim(Entity character, String message){
  
  //font
  textFont(createFont("DotGothic.ttf", 20));
  noStroke();
  fill(100,100,100);
  //dialogue box
  rect(0, 400, 1200, 200, 10);
  rect(0, 350, 230, 150, 30);
  fill(0,0,0,100);
  rect(230, 415, 955, 170, 30);
  rect(15, 415, 200, 170, 30);
  //image of character
  PImage a = loadImage(character.name+".png");
  image(a, 30, 430, 150, 150);
  fill(0,0,0);
  text(character.name, 50, 390);
  //text formatting
  int breakCount=0;
  int ind=240;
  for(int i=0; i<message.length(); i++){
      if(i>=message.length()){
        break;
      }
      if(message.charAt(i)=='|'){
        breakCount++;
        ind=240;
      }else{
       text(message.charAt(i), ind, 470+breakCount*40);
       ind+=12;
      }
  }
  textFont(createFont("DotGothic.ttf", 15));
  text("Press 'ENTER' to Continue", 920, 570);
}

//resetting for screen changes
void screenChange(int f){
  sfx[0].play();
  frame=0;
  lastClick=0;
  screen=f;
}

void setup(){
  
  //loads font
  f1=createFont("DotGothic.ttf", 30);
  
  //size of screen
  size(1200, 600);
  
  //loads images
  images[0] = loadImage("startingScreen.png");
  images[1] = loadImage("arr.png");
  images[2] = loadImage("note.png");
  images[3] = loadImage("openNote.png");
  images[4] = loadImage("nulleye.png");
  
  //loads sound effects + music
  sfx[0] = new SoundFile(this, "mouseClick.mp3");
  music = new SoundFile(this, "lavtown.mp3");
  //plays
  music.play();
  music.loop();
  //beat detector
  beats = new BeatDetector(this);
  beats.input(music);
  beats.sensitivity(10);
  frameRate(60);
}

void draw(){
  
  textFont(f1);
  background(0,0,0);
  
  //"secret" command for information 
  if(keyPressed && key=='x' || key=='X'){
    screen=-1;
  }
  
  //starting screen
  if(screen==0){
    //background
    image(images[0], 0, 0);
    textSize(20);
    fill(255,255,255);
    //animation for text
    if(frame>20 && frame<40){
      fill(255,255,255);
      text("STATIC: THE RPG", 525, (frame-20)*(frame-20)*0.4);
    }else if(frame>40){
      if(Math.random()>0.98){
        fill(0,0,0);
      }else{
         fill(255,255,255);
       }
       text("STATIC: THE RPG", 525, 170);
    }
    if(frame<80){
      fill(0,0,0);
    }
    if(frame>80 && frame<103){
      fill(255,255,255);
      text("PLAY", 430, (frame-80)*(frame-80)*0.4);
    }else if(frame>103){
      fill(255,255,255);
      text("PLAY", 430, 200);
    }
    if(frame>90 && frame<115){
      fill(255,255,255);
      text("HELP", 430, (frame-90)*(frame-90)*0.4);
    }else if(frame>113){
      fill(255,255,255);
      text("HELP", 430, 230);
    }
    if(frame>100 && frame<125){
      fill(255,255,255);
      text("CREDITS", 430, (frame-100)*(frame-100)*0.4);
    }else if(frame>125){
      fill(255,255,255);
      text("CREDITS", 430, 260);
    }
    fill(255,255,255);
    text("ICS20-05 STUDIOS\n   presents...", 520, 100);
    //page selection
    if(keyPressed && frame-lastClick>10){
      if(keyCode==UP && startSelection>0){
        startSelection--;
        lastClick=frame;
        sfx[0].play();
      }
      else if(keyCode==DOWN && startSelection<2){
        startSelection++;
        lastClick=frame;
        sfx[0].play();
      }
    }
    
    if(frame>117){
      image(images[1], 410+(frame%30)/3, 185+startSelection*30, 7.2, 12);
    }
    frame++;
    //goes to selected page
    if(keyPressed && key==ENTER && frame-lastClick>5){
      screenChange(startSelection+1);
    }

  }else if(screen==1){
    //game
    background(255,255,255);
    staticChar.drawChar();
  
    //grid
    stroke(0,0,0,100);
    strokeWeight(1);
    for(int i=0; i<=1200; i+=50){
      line(i-staticChar.posX*3%50, 0, i-staticChar.posX*3%50, 600);
    }
    for(int i=0; i<=600; i+=50){
      line(0, i-staticChar.posY*3%50, 1200, i-staticChar.posY*3%50);
    }
    
    //additional objects
    image(images[2], -staticChar.posX*3+600+page.posX*3, -staticChar.posY*3+300+page.posY*3, 30, 30); //note folder
    tint(255, 50*staticLevel);
    image(images[4], -staticChar.posX*3+600+nullChar.posX*3, -staticChar.posY*3+300+nullChar.posY*3, 30, 30); //NULL
    tint(255, 255);
    //first level
    if(staticLevel==0){
    //dialogue
    //lack of indentation for less spacing
    if(part==0){
      //checks if enter is pressed
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          part++;
          lastClick = frame;
        }
      }
      //generates message
      message="...";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        //message is finished and goes to next part
        sfx[0].play();
        part++;
      }
    }else if(part==1){
      //full dialogue of part 0
      if(keyPressed && frame-lastClick>5){
        //checks if enter is pressed
        if(keyCode==0){
          //goes to next part
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==2){
      //repeat of step 0
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      //"NOT AGAIN"
      message="01001110 01001111 01010100 00100000 01000001 01000111 01000001 01001001|01001110";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==3){
      //repeat of step 1
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==4){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      //"Hello!"
      message="01001000 01100101 01101100 01101100 01101111 00100001";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==5){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==6){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Where am I?";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==7){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==8){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Welcome, Static.";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
      staticChar.name="Static";
    }else if (part==9){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else if(part==10){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Who are you?|How do you know who I am?";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==11){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==12){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="That is an answer you'll find soon enough.|As for now, you can think of me as some sort of guide";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==13){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else if(part==14){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="What is this place?";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==15){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==16){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Home. Settle in, and get cozy.";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==17){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else if(part==18){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="...";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==19){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==20){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="No need to be wary. We're all friends here";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==21){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else if(part==22){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="How do I get out.";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==23){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==24){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Harsh.";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==25){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else if(part==26){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Don't worry. I'm not keeping anything from you.|Believe me, if I knew, I would've been long gone.";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==27){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else if(part==28){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="So much for a guide.|Did you miss some kind of orientation for the job?";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==29){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==30){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="If I'm such a terrible guide, go explore yourself.|All I've been able to find are white squares and...";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==31){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else if(part==32){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="More white squares.";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==33){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else{
      //dialogue completed
      
      //while note is open:
      if(noteOpen){
        fill(0);
        image(images[3], 600-images[3].width/2, 300-images[3].height/2);
        textFont(createFont("DotGothic.ttf", 15));
        //
        text("01110011 01110100 01100001 01110100 01101001 01100011 00100000 01110110 01101111 01101001 01100100 00100000 01110011 01110100 01100001 01110100 01101001 01100011 01010010 01010000 01000111 00101000 01000101 01101110 01110100 01101001 01110100 01111001 00100000 01001110 01010101 01001100 01001100 00101001 01111011", 600-images[3].width/2+15, 300-images[3].height/2+15, images[3].width-8, images[3].height-8);
        text("Press 'Enter' to continue", 600-15*15, 500);
        if(keyPressed && key==ENTER){
          //moving on to the next stage
          staticLevel=1;
          //resetting everything
          part=0;
          frame=0;
          lastClick=0;
          staticChar.posX = 0;
          staticChar.posY = 0;
          page.posX = (float)((int)(Math.random()*50+250)*(Math.pow(-1, (int)(Math.random()*5)+1)));
          page.posY = (float)((int)(Math.random()*50+250)*(Math.pow(-1, (int)(Math.random()*5)+1)));
          noteOpen = false;
        }
      }else{
      //on beat of the song
      if(beats.isBeat()){
        fill(0);
        rect(0,0,1200,600);
        //arrow pointing to the page
        pushMatrix();
        translate(600, 250);
        if(page.posX-staticChar.posX!=0){
          if(page.posX-staticChar.posX>0){
            rotate((float)Math.atan(((float)page.posY-staticChar.posY)/(page.posX-staticChar.posX)));
          }else{
            rotate((float)Math.atan(((float)page.posY-staticChar.posY)/(page.posX-staticChar.posX))+PI);
          }
        }else{
          rotate(0);
        }
        translate(-images[1].width/2, -images[1].height/2);
        image(images[1], 0, 0);
        popMatrix();
        
        //"static" effect
        for(int i=0; i<50*(staticLevel+1); i++){
          fill((int)(Math.random()*255),(int)(Math.random()*255),(int)(Math.random()*255));
          rect((int)(Math.random()*120)*10, (int)(Math.random()*60)*10, 10, 10);
        }
      }
      
      //movement controls
      if(keyPressed){
        if(key=='w'){
          staticChar.posY--;
          staticChar.directionFacing = 0;
        }else if(key=='s'){
          staticChar.posY++;
          staticChar.directionFacing = 2;
        }else if(key=='a'){
          staticChar.posX--;
          staticChar.directionFacing = 3;
        }else if(key=='d'){
          staticChar.posX++;
          staticChar.directionFacing = 1;
        }
      }
      //if character is within reach
      if(sqrt(pow(staticChar.posX-page.posX, 2)+pow(staticChar.posY-page.posY, 2))<8){
        fill(0);
        text("Press E to Interact", 600-19/2*15, 450);
        if(keyPressed && (key=='e' || key=='E')){
          //Item interacted with -> Opens note
          noteOpen = true;
        }
      } 
    }
    }
    }else if(staticLevel==1){
      //stage/level 2
      //opening "static"
      if(frame<180){
        fill(0);
        rect(0,0,1200,600);
        for(int i=0; i<(int)(Math.random()*2000); i++){
          fill((int)(Math.random()*255),(int)(Math.random()*255),(int)(Math.random()*255));
          rect((int)(Math.random()*120)*10, (int)(Math.random()*60)*10, 10, 10);
        }
      }else{//lack of indentation for less spacing 
      //repeat of what happens in the first level

      //dialogue
      if(part==0){//lack of indentation for less spacing
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          part++;
          lastClick = frame;
        }
      }
      message="...";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        sfx[0].play();
        part++;
      }
    }else if(part==1){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==2){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="01001110 01001111 01010100 00100000 01000001 01000111 01000001 01001001|01001110";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==3){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==4){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="01001000 01100101 01101100 01101100 01101111 00100001";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==5){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==6){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Welcome, Static.";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==7){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else if(part==8){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Who are you?|How do you know who I am?";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==9){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==10){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="That is an answer you'll find soon enough.|As for now, you can think of me as some sort of guide";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==11){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else if(part==12){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="What is this place?";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==13){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==14){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Home. Settle in, and get cozy.";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==15){
      //modified dialogue
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else if(part==16){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="This all seems so... familiar?";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==17){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==18){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Does it now?";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==19){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else if(part==20){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="I'll let you explore on your own. You should know your way around by now";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==21){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else{
      if(noteOpen){
        fill(0);
        image(images[3], 600-images[3].width/2, 300-images[3].height/2);
        textFont(createFont("DotGothic.ttf", 15));
        text("01110011 01110100 01100001 01110100 01101001 01100011 01010010 01010000 01000111 00101000 01001110 01010101 01001100 01001100 00101001 00111011", 600-images[3].width/2+15, 300-images[3].height/2+15, images[3].width-8, images[3].height-8);
        text("Press 'Enter' to continue", 600-15*15, 500);
        if(keyPressed && key==ENTER){
          //moving on to the next stage
          staticLevel=2;
          //resetting everything
          part=0;
          frame=0;
          lastClick=0;
          staticChar.posX = 0;
          staticChar.posY = 0;
          page.posX = (float)((int)(Math.random()*50+250)*(Math.pow(-1, (int)(Math.random()*5)+1)));
          page.posY = (float)((int)(Math.random()*50+250)*(Math.pow(-1, (int)(Math.random()*5)+1)));
          noteOpen = false;
        }
      }else{
      //on beat of the song
      if(beats.isBeat()){
        fill(0);
        rect(0,0,1200,600);
        //arrow pointing to the page
        pushMatrix();
        translate(600, 250);
        if(page.posX-staticChar.posX!=0){
          if(page.posX-staticChar.posX>0){
            rotate((float)Math.atan(((float)page.posY-staticChar.posY)/(page.posX-staticChar.posX)));
          }else{
            rotate((float)Math.atan(((float)page.posY-staticChar.posY)/(page.posX-staticChar.posX))+PI);
          }
        }else{
          rotate(0);
        }
        translate(-images[1].width/2, -images[1].height/2);
        image(images[1], 0, 0);
        popMatrix();
        
        //"static" effect
        for(int i=0; i<500; i++){
          fill((int)(Math.random()*255),(int)(Math.random()*255),(int)(Math.random()*255));
          rect((int)(Math.random()*120)*10, (int)(Math.random()*60)*10, 10, 10);
        }
      }
      //movement controls
      if(keyPressed){
        if(key=='w'){
          staticChar.posY--;
          staticChar.directionFacing = 0;
        }else if(key=='s'){
          staticChar.posY++;
          staticChar.directionFacing = 2;
        }else if(key=='a'){
          staticChar.posX--;
          staticChar.directionFacing = 3;
        }else if(key=='d'){
          staticChar.posX++;
          staticChar.directionFacing = 1;
        }
      }
      //if character is within reach
      if(sqrt(pow(staticChar.posX-page.posX, 2)+pow(staticChar.posY-page.posY, 2))<8){
        fill(0);
        text("Press E to Interact", 600-19/2*15, 450);
        if(keyPressed && (key=='e' || key=='E') && frame-lastClick>1){
          //Item interacted with -> Opens note
          noteOpen = true;
        }
      } 
    }
    }
    }
    }else if(staticLevel==2){
      //stage/level 3
      //opening "static"
      if(frame<180){
        fill(0);
        rect(0,0,1200,600);
        for(int i=0; i<(int)(Math.random()*4000); i++){
          fill((int)(Math.random()*255),(int)(Math.random()*255),(int)(Math.random()*255));
          rect((int)(Math.random()*120)*10, (int)(Math.random()*60)*10, 10, 10);
        }
      }else{//lack of indentation for less spacing 
      //repeat of what happens in the first level

      //dialogue
      if(part==0){//lack of indentation for less spacing
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          part++;
          lastClick = frame;
        }
      }
      message="...";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        sfx[0].play();
        part++;
      }
    }else if(part==1){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==2){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="01001110 01001111 01010100 00100000 01000001 01000111 01000001 01001001|01001110";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==3){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==4){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="01001000 01100101 01101100 01101100 01101111 00100001";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==5){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==6){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Welcome, Static.";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==7){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else if(part==8){
      //modified dialogue begins here
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Why am I here?";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==9){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==10){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Interesting you haven't figured it out yet.";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==11){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else if(part==12){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="What?";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==13){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==14){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Nothing, nothing.";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==15){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else if(part==16){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="This all seems so... familiar?";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==17){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==18){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Deja vu? I get what you mean.";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==19){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else if(part==20){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="I've been there.";
      typingAnim(nullChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==21){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(nullChar, message);
    }else{
      if(noteOpen){
        fill(0);
        image(images[3], 600-images[3].width/2, 300-images[3].height/2);
        textFont(createFont("DotGothic.ttf", 15));
        text("return('Not again.');", 600-images[3].width/2+15, 300-images[3].height/2+15, images[3].width-8, images[3].height-8);
        text("Press 'Enter' to continue", 600-15*15, 500);
        if(keyPressed && key==ENTER){
          //moving on to the next stage
          staticLevel=3;
          //resetting everything
          part=0;
          frame=0;
          lastClick=0;
          staticChar.posX = 0;
          staticChar.posY = 0;
          page.posX = (float)((int)(Math.random()*50+250)*(Math.pow(-1, (int)(Math.random()*5)+1)));
          page.posY = (float)((int)(Math.random()*50+250)*(Math.pow(-1, (int)(Math.random()*5)+1)));
          noteOpen = false;
        }
      }else{
      //on beat of the song
      if(beats.isBeat()){
        fill(0);
        rect(0,0,1200,600);
        //arrow pointing to the page
        pushMatrix();
        translate(600, 250);
        if(page.posX-staticChar.posX!=0){
          if(page.posX-staticChar.posX>0){
            rotate((float)Math.atan(((float)page.posY-staticChar.posY)/(page.posX-staticChar.posX)));
          }else{
            rotate((float)Math.atan(((float)page.posY-staticChar.posY)/(page.posX-staticChar.posX))+PI);
          }
        }else{
          rotate(0);
        }
        translate(-images[1].width/2, -images[1].height/2);
        image(images[1], 0, 0);
        popMatrix();
        
        //"static" effect
        for(int i=0; i<500; i++){
          fill((int)(Math.random()*255),(int)(Math.random()*255),(int)(Math.random()*255));
          rect((int)(Math.random()*120)*10, (int)(Math.random()*60)*10, 10, 10);
        }
      }
      //movement controls
      if(keyPressed){
        if(key=='w'){
          staticChar.posY--;
          staticChar.directionFacing = 0;
        }else if(key=='s'){
          staticChar.posY++;
          staticChar.directionFacing = 2;
        }else if(key=='a'){
          staticChar.posX--;
          staticChar.directionFacing = 3;
        }else if(key=='d'){
          staticChar.posX++;
          staticChar.directionFacing = 1;
        }
      }
      //if character is within reach
      if(sqrt(pow(staticChar.posX-page.posX, 2)+pow(staticChar.posY-page.posY, 2))<8){
        fill(0);
        text("Press E to Interact", 600-19/2*15, 450);
        if(keyPressed && (key=='e' || key=='E') && frame-lastClick>1){
          //Item interacted with -> Opens note
          noteOpen = true;
        }
      } 
    }
    }
    }
    }else if(staticLevel==3){
      //final stage
      //opening "static"
      if(frame<180){
        fill(0);
        rect(0,0,1200,600);
        for(int i=0; i<(int)(Math.random()*4000); i++){
          fill((int)(Math.random()*255),(int)(Math.random()*255),(int)(Math.random()*255));
          rect((int)(Math.random()*120)*10, (int)(Math.random()*60)*10, 10, 10);
        }
      }else{//lack of indentation for less spacing 
      //repeat of what happens in the first level

      //dialogue
      if(part==0){//lack of indentation for less spacing
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          part++;
          lastClick = frame;
        }
      }
      message = "...?";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        sfx[0].play();
        part++;
      }
    }else if(part==1){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==2){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Null?";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==3){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==4){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Null? Are you there?";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==5){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==6){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Where are you Null?";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==7){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==8){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Null? When did it mention its name..?";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==9){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==10){
      staticChar.name = "Unknown";
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Who am I?";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==11){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else if(part==12){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      message="Am I [NULL]?";
      typingAnim(staticChar, message.substring(0, min(message.length(), frame-lastClick)));
      if(frame-lastClick>message.length()){
        part++;
      }
    }else if (part==13){
      if(keyPressed && frame-lastClick>5){
        if(keyCode==0){
          sfx[0].play();
          part++;
          lastClick = frame;
        }
      }
      typingAnim(staticChar, message);
    }else{
      if(noteOpen){
        fill(0);
        image(images[3], 600-images[3].width/2, 300-images[3].height/2);
        textFont(createFont("DotGothic.ttf", 15));
        text("I'm writing in hopes I do not forget.   I am s̶̨̢̲̤̜̮̟̯̪̲͈̥̑̉͊̿͌̊͂͋̽͗̀̋̕͠t̵̡̻̹̭̞̺͉͉̻̜̻̲͇̎̓͒͐̆̇̾̔̋́͋͑̅̌ͅḁ̸̧͉̞̘̗̅̓͗͊̀́̇̂̈̅̔͐̚͝t̵̡̡̞̦̰̭̟͚͇̟̓͗͗͋͊i̵̢̧̦̫̼͇̎̅̕͝c̸̨̣̘͕̺̲̥̯̹̜̅̃̐̏́͐͑. I am [C:S.Processing]/RUNTIME ERROR. Character.NAME NOT FOUND. I am [NULL]. I am Null.", 600-images[3].width/2+15, 300-images[3].height/2+15, images[3].width-8, images[3].height-8);
        text("Press 'Enter' to continue", 600-15*15, 500);
        if(keyPressed && key==ENTER){
          //moving on to the next stage
          staticLevel=4;
          //resetting everything
          part=0;
          frame=0;
          lastClick=0;
          staticChar.posX = 0;
          staticChar.posY = 0;
          page.posX = (float)((int)(Math.random()*50+250)*(Math.pow(-1, (int)(Math.random()*5)+1)));
          page.posY = (float)((int)(Math.random()*50+250)*(Math.pow(-1, (int)(Math.random()*5)+1)));
          noteOpen = false;
        }
      }else{
      //on beat of the song
      if(beats.isBeat()){
        fill(0);
        rect(0,0,1200,600);
        //arrow pointing to the page
        pushMatrix();
        translate(600, 250);
        if(page.posX-staticChar.posX!=0){
          if(page.posX-staticChar.posX>0){
            rotate((float)Math.atan(((float)page.posY-staticChar.posY)/(page.posX-staticChar.posX)));
          }else{
            rotate((float)Math.atan(((float)page.posY-staticChar.posY)/(page.posX-staticChar.posX))+PI);
          }
        }else{
          rotate(0);
        }
        translate(-images[1].width/2, -images[1].height/2);
        image(images[1], 0, 0);
        popMatrix();
        
        //"static" effect
        for(int i=0; i<500; i++){
          fill((int)(Math.random()*255),(int)(Math.random()*255),(int)(Math.random()*255));
          rect((int)(Math.random()*120)*10, (int)(Math.random()*60)*10, 10, 10);
        }
      }
      //movement controls
      if(keyPressed){
        if(key=='w'){
          staticChar.posY--;
          staticChar.directionFacing = 0;
        }else if(key=='s'){
          staticChar.posY++;
          staticChar.directionFacing = 2;
        }else if(key=='a'){
          staticChar.posX--;
          staticChar.directionFacing = 3;
        }else if(key=='d'){
          staticChar.posX++;
          staticChar.directionFacing = 1;
        }
      }
      //if character is within reach
      if(sqrt(pow(staticChar.posX-page.posX, 2)+pow(staticChar.posY-page.posY, 2))<8){
        fill(0);
        text("Press E to Interact", 600-19/2*15, 450);
        if(keyPressed && (key=='e' || key=='E') && frame-lastClick>1){
          //Item interacted with -> Opens note
          noteOpen = true;
        }
      } 
    }
    }
    }
    }else if(staticLevel==4){
      textFont(createFont("DotGothic.ttf", 100));
      background(0);
      fill(255);
      text("I am NULL.", 350, 300);
    }
    frame++;
    //displays current cordinates
    textFont(createFont("DotGothic.ttf", 20));
    fill(0,0,0);
    text(staticChar.posX + " " + staticChar.posY, 110, 100);
  }else if(screen==2){
    //help/intstructions
    fill(0,0,0);
    textFont(createFont("DotGothic.ttf", 20));
    fill(255,255,255);
    text("WASD for character movement. Press ENTER to return.", 100, 100);
    if(keyPressed && key==ENTER && frame-lastClick>5){
      screenChange(0);
    }
    frame++;
  }else if(screen==3){
    //credits
    background(0);
    textFont(createFont("DotGothic.ttf", 20));
    fill(255,255,255);
    
    int breakCount=0;
    int ind=240;
    String m = "Images: GOOGLE|Character Designs: Dorothy|Storyline: Dorothy (With the help of Laura and Honeyeh)|Code: Dorothy|Teacher: Mr. Horvat|Enter to go back";
    for(int i=0; i<m.length(); i++){
      if(i>=m.length()){
        break;
      }
      if(m.charAt(i)=='|'){
        breakCount++;
        ind=240;
      }else{
       text(m.charAt(i), ind, 100+breakCount*40);
       ind+=12;
      }
    }
    if(keyPressed && key==ENTER && frame-lastClick>5){
      screenChange(0);
    }
    frame++;
  }else if(screen == -1){
    background(0);
    textFont(createFont("DotGothic.ttf", 20));
    fill(255,255,255);
    String m = "The game follows Static, a character that has found itself in an unknown location. It begins with meeting NULL," +
    " what seems to be an 'invisible' guide, that offers no help. As it explores, it finds remnants of notes (which are later discovered"+
    " to be written by Static). The reality is that Static is a variable stuck in an endless recurisve loop, and the lines of code"+
    " are found in the notes. Its name, Static, derives from static methods, which can be called without the use of its class."+
    " The binary translations are as follows:";
    String binaryTranslations = "Static's first words: 'NOT AGAIN', followed by 'Hello!'; Note #1: 'static void staticRPG(Entity NULL){';"+
    " Note#2: staticRPG(NULL);";
    String gameplay = "The beats of the game showing the static screen + the arrow pointing towards the target were heavily inspired"+
    " by rhythm games. However, if the song doesn't load, or the flashing is too quick, you can click on the screen and the console will output"+
    " the coordinates.";
    text(m, 50, 50, 1100, 700);
    text(binaryTranslations, 50, 310, 500, 300);
    text(gameplay, 625, 310, 500, 300);
    text("Press 'Enter' to Return", 50, 500);
    if(keyPressed && key==ENTER && frame-lastClick>5){
      screenChange(0);
    }
    frame++;
  }
  
}
void mouseClicked(){
  System.out.println(page.posX + "" + page.posY);
} 
//extra curly bracket to match with the one in line 1634 so processing doesn't give the warning }
