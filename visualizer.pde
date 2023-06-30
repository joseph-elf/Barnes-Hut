//CONTROLS:
// 'o', 'p' previous and next picture
// 'n' save the picture
// 'b' will charge and save all picture, it may make bug your PC so DONT USE IT !
//Camera movement 
// 'q', 'd', 'z', 's', 'r', 'f' move spherical coordinates
// 'left', 'up', 'right', 'down' move origin of spherical coordinate coordinates
// 'h' init position



int nbEtoile;
float[] X;
float[] Y;
float[] Z;
float[] F;

boolean paused =true  ;
boolean trouNoir = false;
boolean force = false;
boolean save = false;
float mult=10.;

Camera camera; 

String fichierName = "test";      // Set the results folder
int stepImg = 0, nbImage = 100;  //Set the number of pictures
PFont f;
  float fmin=0, fmax=1000,fmoy=0.5*(fmax+fmin);




void setup() {
  size(1100, 900, P3D);
  //fullScreen(P3D);
    camera = new Camera(0, 0, 0, 800, PI/3, 0, true); 

 chargeSolar();

    

   //tint(255, 50, 50,200);
 
}



void draw() {
  background(0);
  colorMode(RGB, 255,255,255);
  camera.setCamera();
  strokeWeight(1);
  camera.drawRepere();
  stroke(255);
  colorMode(HSB, 360,100,100);

  
  for (int i=0; i<nbEtoile; i++) {
    strokeWeight(1);
    
    if(i == nbEtoile-2 && trouNoir)
    strokeWeight(10);
      
    if(force)  
     stroke(30,  constrain( map((F[i]),fmoy,fmax, 100,0) ,0,100)  ,  constrain( map((F[i]),fmin,fmoy, 40,100) ,0,100)  )  ;
    //stroke(255);

    point(mult*X[i], mult*Y[i], mult*Z[i]);
    
    
    
    
  }
  camera.drawcoord(nbEtoile,stepImg,nbImage-1);
  camera.updatePosition();
  if(save){
    if(stepImg<10)
    saveFrame("IMG/000"+stepImg+".png");
    else if(stepImg<100)
    saveFrame("IMG/00"+stepImg+".png");
    else if (stepImg<1000)
    saveFrame("IMG/0"+stepImg+".png");
    else
    saveFrame("IMG/"+stepImg+".png");
    
    stepImg++;
    
    
    if(stepImg>=nbImage){
      save = false;
      stepImg = nbImage-1;
    }
    chargeSolar();
    }
 
  //delay(1000/30);
}

















void keyPressed()
{
  switch(key){
    case ' ':
      paused = !paused;
    break;
    case 'o':
      stepImg--;
      if(stepImg<0)stepImg=0;
      chargeSolar();
    break;
    case 'p':
      stepImg++;
      if(stepImg>nbImage-1)stepImg=nbImage-1;
      chargeSolar();
    break;
    case 'n':
    if(stepImg<10)
    saveFrame("IMG/000"+stepImg+".png");
    else if(stepImg<100)
    saveFrame("IMG/00"+stepImg+".png");
    else if (stepImg<1000)
    saveFrame("IMG/0"+stepImg+".png");
    else
    saveFrame("IMG/"+stepImg+".png");
    break;
    case 'b':
    save= !save;
    break;
    case 'j':
    stepImg+= nbImage/10;
    chargeSolar();
    break;
    case 'k':
    stepImg-= nbImage/10;
    chargeSolar();
    break;
  }
  camera.setMove(key, keyCode, true);
}
void keyReleased()
{
  camera.setMove(key, keyCode, false);
}


void chargeSolar() {
  Table table;
  table = loadTable(fichierName + "/" + stepImg + ".out", "csv");


  int colonne = table.getColumnCount();
  nbEtoile = table.getRowCount();

  //println(nbEtoile);
  //println(colonne);

  if(colonne==4){
  force = true;}
  else if(colonne==3){
  force = false;}
  else{
  println("ERROR");
  }

  X = new float[nbEtoile];
  Y = new float[nbEtoile];
  Z = new float[nbEtoile];
  F = new float[nbEtoile];


  for (int line = 0; line < nbEtoile; line++) {
      X[line] =  table.getFloat(line, 0);
      Y[line] =  table.getFloat(line, 1);
      Z[line] =  table.getFloat(line, 2);
      if(force)
      F[line] =  table.getFloat(line, 3);
    
  }
//println("tout bene ma bella");
//println(Z[1]);
}






void TexturedCube(PImage tex) {
  beginShape(QUADS);
  texture(tex);


  vertex(-16, -16,  16, 0, 0);
  vertex( 16, -16,  16, 32, 0);
  vertex( 16,  16,  16, 32, 32);
  vertex(-16,  16,  16, 0, 32);


  endShape();
}
