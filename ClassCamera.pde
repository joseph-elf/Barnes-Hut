//Camera camera = new Camera(0, 0, 0, 800, PI/3, 0, true); 
/*
void setup() {
 size(1000, 1000, P3D);
 background(0);
 drawRepere();
 }
 void draw() {
 clear();
 background(0);
 camera.setCamera();
 drawRepere();
 drawGround();
 box(50);
 
 
 
 
 
 if (keyPressed) {
 //camera.keyPress(key, keyCode);
 }
 camera.updatePosition();
 }
 
 */

class Camera {


  float X, Y, Z;
  float vX, vY, vZ;
  float R, theta, phi;
  float vR, vtheta, vphi;
  float eta, epsilon;
  float veta, vepsilon;

  float angularInc = 0.03;
  float spaceInc = 16;

  boolean lookAtCenter,showCoord;

  PFont font;

  boolean[] clavier = new boolean[16];


  Camera (float x, float y, float z, float r, float t, float p, boolean center) {  
    X=x;
    Y=y;
    Z=z;
    R=r;
    theta=t;
    phi=p;
    eta = phi+PI;
    epsilon = PI-theta;
    lookAtCenter = center;
    vX=0;
    vY=0;
    vZ=0;
    vR=0;
    vtheta=0;
    vphi=0;
    veta=0;
    vepsilon=0;
    font = createFont("Pointless.ttf", 14);
    showCoord = true;
    for (int i =0; i<16; i++)
      clavier[i]=false;
  } 

  












  float posX() {
    return(X + R*cos(phi)*sin(theta) );
  }
  float posY() {
    return(Y + R*sin(phi)*sin(theta) );
  }
  float posZ() {
    return(Z + R*cos(PI-theta) );
  }

  float lookAtX() {

    return posX() + cos(eta)*sin(epsilon);
  }
  float lookAtY() {

    return posY() + sin(eta)*sin(epsilon);
  }
  float lookAtZ() {

    return posZ() - cos(epsilon);
  }

  void setCamera() {
    //scale(1,1,-1);
    

    camera( posX(), posY(), posZ(), lookAtX(), lookAtY(), lookAtZ(), 0, 0, 1);
    
    
  }

  void drawcoord(int nbEtoile,int imgid, int imgmax){
    if(showCoord){
    textFont(font);
    beginCamera();
    camera();
    int coordx = 60;
    text(nbEtoile + " STARS" ,30,coordx-25);
    text("X = " + round(X),30,coordx);
    text("Y = " + round(Y),30,coordx+20);
    text("Z = " + round(Z),30,coordx+40);

    text("R = " + round(R),30,coordx+65);
    text("Theta = " + nf(theta,1,2),30,coordx+85);
    text("Phi= " + nf(phi,1,2),30,coordx+105);
    
    text("IMG Nb.  " + imgid + "/" + imgmax, 30, coordx+130);
    endCamera();
  }
  }


  void setMove(char simpleKey, int codeKey, boolean b) {
    switch (codeKey) {
    case 38:  
      clavier[0]=b;
      break;
    case 40:  
      clavier[1]=b;
      break;
    case 37:  
      clavier[2]=b;
      break;
    case 39:  
      clavier[3]=b;
      break;
    }


    switch (simpleKey) {
    case 'z':  
      clavier[4]=b;
      break;
    case 's':  
      clavier[5]=b;
      break;
    case 'q':  
      clavier[6]=b;
      break;
    case 'd':  
      clavier[7]=b;
      break;


    case 'Z':  
      clavier[8]=b;
      break;
    case 'S':  
      clavier[9]=b;
      break;
    case 'Q':  
      clavier[10]=b;
      break;
    case 'D':  
      clavier[11]=b;
      break;


    case 'R':  
      clavier[14]=b;
      break;
    case 'F':  
      clavier[15]=b;
      break;
    case 'r':  
      clavier[12]=b;
      break;
    case 'f':  
      clavier[13]=b;
      break;

    case 'h':
      X=0;
      Y=0;
      R=600;
      epsilon = PI-theta;
      eta = phi+PI;
      for (int i =0; i<12; i++)
        clavier[i]=false;
      break;
    case'v':
    case 'V':
      if (b) 
        lookAtCenter=!lookAtCenter;
      break;
    case 'c':
    case 'C':
      if (b) 
        showCoord= !showCoord;
      break;
    
    }
  }

  void updatePosition() {
    if (clavier[0] && vY*vY+vX*vX<spaceInc*spaceInc) {
      vX+=1*cos(eta);
      vY+=1*sin(eta);
    }
    if (clavier[1] && vY*vY+vX*vX<spaceInc*spaceInc) {
      vX-=1*cos(eta);
      vY-=1*sin(eta);
    }

    if (clavier[2] && vY*vY+vX*vX<spaceInc*spaceInc) {
      vX-=1*sin(eta);
      vY+=1*cos(eta);
    }
    if (clavier[3] && vY*vY+vX*vX<spaceInc*spaceInc) {
      vX+=1*sin(eta);
      vY-=1*cos(eta);
    }

    if (clavier[4] && vtheta>=-angularInc)vtheta-=angularInc/10;
    if (clavier[5] && vtheta<=angularInc)vtheta+=angularInc/10;

    if (clavier[6] && vphi>=-angularInc)vphi-=angularInc/10;
    if (clavier[7] && vphi<=angularInc)vphi+=angularInc/10;


    if (clavier[8] && vepsilon>=-angularInc)vepsilon-=angularInc/10;
    if (clavier[9] && vepsilon<=angularInc)vepsilon+=angularInc/10;

    if (clavier[11] && veta>=-angularInc)veta-=angularInc/5;
    if (clavier[10] && veta<=angularInc)veta+=angularInc/5;

    if (clavier[12] && vR>=-spaceInc)vR-=1;
    if (clavier[13] && vR<=spaceInc)vR+=1;
    
    if (clavier[14] && vZ>=-spaceInc)vZ-=1;
    if (clavier[15] && vZ<=spaceInc)vZ+=1;


    if (vX!=0)vX*=0.95;
    if (vY!=0)vY*=0.95;
    if (vtheta!=0)vtheta*=0.95;
    if (vphi!=0)vphi*=0.95;
    if (vepsilon!=0)vepsilon*=0.8;
    if (veta!=0)veta*=0.8;
    if (vR!=0)vR*=0.95;
    if (vZ!=0)vZ*=0.95;

    X+=vX;
    Y+=vY;
    Z+=vZ;
    R+=vR;
    theta+=vtheta;
    phi+=vphi;
    eta+=veta;
    epsilon+=vepsilon;
    if (lookAtCenter && !clavier[11] && !clavier[10] && !clavier[9] && !clavier[8]) {// || vtheta*vtheta > 0.00001|| vphi*vphi > 0.00001){
      epsilon = PI-theta;
      eta = phi+PI;
    }
    if (theta<=0) {
      theta=0.001;
      vtheta=0;
    }
    if (theta>=PI) {
      theta=PI-0.001;
      vtheta=0;
    }
  }




  void drawRepere() {
    stroke(255, 0, 0);
    line(0, 0, 0, 100, 0, 0);
    stroke(0, 255, 0);
    line(0, 0, 0, 0, 100, 0);
    stroke(0, 0, 255);
    line(0, 0, 0, 0, 0, -100);
  }

  void drawGround() {

    int size = 1000, inter = 50;
    for (int i = -size; i<size; i+=inter) {
      for (int j = -size; j<size; j+=inter) {
        fill(200);
        stroke(50);
        rect(i, j, inter, inter);
      }
    }
  }
}
