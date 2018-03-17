// adapted from the "BouncyBubbles" example.
//import ddf.minim.*;
int level = 1;
//AudioPlayer player;
//Minim minim;//audio context
int numBubbles = 20; // initial bubble count
int redbubblex=230;
int redbubbley=230;
int redbubbleradiusx = 30;
int redbubbleradiusy = 30;
float ballspeedx=1;
float ballspeedy=1.1;
int mouseclickx=15;
final int BROKEN = -99; // code for "broken", may have other states later
final int MAXDIAMETER = 120; // maximum size of expanding bubble
int clicksleft = 2; // number of clicks, presently not used
int a =32;
ArrayList pieces; // all the playing pieces

void setup() 
{
  
 // minim  = new Minim(this);
 // player = minim.loadFile("music.mp3");
  //player.play();
  pieces = new ArrayList(numBubbles);
  size(640, 640);
  noStroke();
  smooth();
  
  for (int i = 0; i < numBubbles; i++) {
    pieces.add(new Bubble(random(width), random(height), 30, i, pieces));
   
  }

}

void mousePressed()
{
  
      // on click, create a new burst bubble at the mouse location and add it to the field
      clicksleft--;
      mouseclickx--;
      Bubble b = new Bubble(mouseX,mouseY,2,numBubbles,pieces);
      b.burst();
      pieces.add(b);
      numBubbles++;

    
}
void draw() 
{
  
  background(0);
  text("level",270,35);
  text(level,340,35);
  
  for (int i = 0; i < numBubbles; i++) {
    Bubble b = (Bubble)pieces.get(i); // get the current piece
    
    // Check if the bubble(i) is colliding with the red bubble
    float dist1 = dist(b.x,b.y,redbubblex,redbubbley);
    if(dist1<redbubbleradiusx/2+(b.diameter/2) && b.diameter>30){
      mouseclickx--;
    }
      // If it is, end the game
    
    if (b.diameter < 1) // if too small, remove
      {
	pieces.remove(i);
	numBubbles--;
	i--;
      }
    else
      {
	// check collisions, update state, and draw this piece
        if (b.broken == BROKEN)
        // only bother to check collisions with broken bubbles
  	   b.collide();
	b.update();
        
	b.display();  
      }
  }
  fill(255,0,0);
   ellipse(redbubblex,redbubbley,redbubbleradiusx,redbubbleradiusy);
   redbubblex+=ballspeedx;
  redbubbley+=ballspeedy;
  if(redbubblex-redbubbleradiusx/2==0 || redbubblex+redbubbleradiusx/2==width){
    
    ballspeedx*=-1;
  }
   if(redbubbley-redbubbleradiusy/2==0 || redbubbley+redbubbleradiusy/2==height){
    
    ballspeedy*=-1;
  }
 
    textAlign(CENTER);
 textSize(30);
  text(mouseclickx,580,600);
  
  if(mouseclickx<0 && numBubbles>0){

reset();

  
  }
  else if (numBubbles==0 && level==1){
    text("You Win",320,320);
    levelup();
  }
    else if(numBubbles==0 && level==2){
   level3();
 }
  else if(numBubbles==0 && level==3){
    textSize(a);
    text("You Win",320,320);
   a++;
   if(a>60){
     a--;
   }

}

}  
   


class Bubble {
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  int broken = 0;
  float growrate = 0;
  ArrayList others;
 
  Bubble(float xin, float yin, float din, int idin, ArrayList oin) {
    x = xin;
    y = yin;
    diameter = din;
    growrate = 0;
    id = idin;
    vx = random(0,100)/50. - 1.;
    vy = random(0,100)/50. - 1.;
    
    others = oin;
  } 
  void burst()
  {
    if (this.broken != BROKEN) // only burst once
      {
	this.broken = BROKEN;
	this.growrate = 2; // start it expanding
      }
  }
  
  void collide() {
    Bubble b;
    // check collisions with all bubbles
    for (int i = 0; i < numBubbles; i++) {
      
      b = (Bubble)others.get(i);
      float dx = b.x - x;
      float dy = b.y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = b.diameter/2 + diameter/2;
      if (distance < minDist) { // collision has happened
	if ((this.broken == BROKEN) || (b.broken == BROKEN))
	  {
	    // broken bubbles cause others to break also
	    
	    b.burst();
	  }
     }
    }

  }
  
  void update() {
    if (this.broken == BROKEN)
      {
	this.diameter += this.growrate;
	if (this.diameter > MAXDIAMETER) // reached max size
	  this.growrate = -0.75; // start shrinking
      }
    else
      {
	// move via Euler integration
	x += vx;
	y += vy;
	
	// the rest: reflect off the sides and top and bottom of the screen
	if (x + diameter/2 > width) {
	  x = width - diameter/2;
	  vx *= -1; 
	}
	else if (x - diameter/2 < 0) {
	  x = diameter/2;
	  vx *= -1;
	}
	if (y + diameter/2 > height) {
	  y = height - diameter/2;
	  vy *= -1; 
	} 
	else if (y - diameter/2 < 0) {
	  y = diameter/2;
	  vy *= -1;
	}
      }
  }
  
  void display() {
    // how to draw a bubble: set to white with some transparency, draw a circle
    fill(255, 204); 
    ellipse(x, y, diameter, diameter);
  }
}

void reset(){
  ellipse(redbubblex,redbubbley,redbubbleradiusx,redbubbleradiusy);
   redbubblex+=ballspeedx;
  redbubbley+=ballspeedy;
  if(redbubblex-redbubbleradiusx/2==0 || redbubblex+redbubbleradiusx/2==width){
    
    ballspeedx*=-1;
  }
   if(redbubbley-redbubbleradiusy/2==0 || redbubbley+redbubbleradiusy/2==height){
    
    ballspeedy*=-1;
  }
 level=1;
 numBubbles=20;
  text("GAME WILL RESET",320,320);
  
 
pieces.clear();
mouseclickx = 15; 
pieces = new ArrayList(numBubbles);
  size(640, 640);
  noStroke();
  smooth();
 
  for (int i = 0; i < numBubbles; i++) {
    pieces.add(new Bubble(random(width), random(height), 30, i, pieces));
   
  }
}
  
  
  void levelup(){
  redbubblex=0;
  redbubbley=0;
  redbubbleradiusx=0;
  redbubbleradiusy=0;
    numBubbles=35;
     level =2;
pieces.clear();
mouseclickx = 10; 
pieces = new ArrayList(numBubbles);
  size(640, 640);
  noStroke();
  smooth();

 
  for (int i = 0; i < numBubbles; i++) {
    pieces.add(new Bubble(random(width), random(height), 30, i, pieces));
  }


  }



void level3(){

  redbubblex=0;
  redbubbley=0;
  redbubbleradiusx=0;
  redbubbleradiusy=0;
    numBubbles=50;
     level =3;
pieces.clear();
mouseclickx = 15; 
pieces = new ArrayList(numBubbles);
  size(640, 640);
  noStroke();
  smooth();

 
  for (int i = 0; i < numBubbles; i++) {
    pieces.add(new Bubble(random(width), random(height), 30, i, pieces));
  }

}