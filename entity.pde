public class Entity{
  public String name, type;
  public float hp;
  public float posX, posY;
  public int directionFacing;//0: back; 1: right; 2: front; 3: left
  
  public Entity(String n, String t, float x, float y){
    //construct entity
    name = n;
    type = t;
    hp = 100;  
    posX=x;
    posY=y;
    directionFacing = 2;
  }
}

//child of entity
class StaticCharacter extends Entity{
  public StaticCharacter(String n){
    super(n, "Static", 0, 0);
  }
  //draws the character
  public void drawChar(){
    stroke(0,0,0);
    strokeWeight(1);
    fill(0,0,0, 255-(staticLevel*60));
    
    if(directionFacing == 0){
      //back
      rect(615, 300-5, 20, 20); //head
      rect(615, 318, 20, 30); //body
    }else if(directionFacing == 1){
      //side
      rect(620, 300-5, 20, 20); //head
      beginShape(); //slanted body
      vertex(620, 318);
      vertex(640, 318);
      vertex(635, 348);
      vertex(615, 348);
      endShape();
    }else if(directionFacing == 2){
      //front
      rect(615, 300-5, 20, 20); //head
      rect(615, 318, 20, 30); //body
      image(loadImage("eye.png"), 615, 295, 20, 20); //"face"
    }else if(directionFacing==3){
      //side
      rect(610, 300-5, 20, 20); //head
      beginShape(); //slanted body
      vertex(610, 318);
      vertex(630, 318);
      vertex(635, 348);
      vertex(615, 348);
      endShape();
    }
    
    //static
    noStroke();
    for(int i=0; i<Math.pow(10, staticLevel); i++){
      int x = (int)(Math.random()*25)+610;
      int y = (int)(Math.random()*55)+295;
      if(get(x, y) != #FFFFFF){
        fill((int)(Math.random()*255),(int)(Math.random()*255),(int)(Math.random()*255));
        rect(x, y, 1, 1);
      }
    }
  }  
}
