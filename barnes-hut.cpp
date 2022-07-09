#include <iostream>       // basic input output streams
#include <fstream>        // input output file stream class
#include <cmath>          // librerie mathematique de base
#include <iomanip>        // input output manipulators
#include <valarray>       // valarray functions
#include <vector>       // vector functions
#include <ctime> 
#include "Noeud.cpp"
#include "Planete.cpp"
#include "ConfigFile.h"
using namespace std; 






double random(double min, double max){
		  return((max-min)*abs(rand())/RAND_MAX) + min;
	}


int main(int argc, char* argv[])
{
	
	std::time_t timeBegin = std::time(nullptr);
	
	srand (time(NULL));						//CHIANT
	string inputPath("configuration.in");
		if(argc>1)
    inputPath = argv[1];
	ConfigFile configFile(inputPath);
		for(int i(2); i<argc; ++i)
    configFile.process(argv[i]);
    
    
    
    
    int nbEtoile(configFile.get<int>("nbEtoile"));
	double rayon(configFile.get<double>("rayon"));
	double epaisseur(configFile.get<double>("epaisseur"));
	double V(configFile.get<double>("V0"));
	double tfin(configFile.get<double>("tfin"));
	double dt(configFile.get<double>("dt"));
	
	
    
    

	vector<Planete*> systeme;

	double X,Y,Z;

	
	for(int i(0); i < nbEtoile; i++){
			/*do{
				X = random(-rayon,rayon);
				Y = random(-rayon,rayon);
				
			}while(X*X+Y*Y > rayon*rayon);*/
			//Z = random(-10,10);
			
			double r = random(0,1);//sqrt(X*X+Y*Y);
			double phi =  random(0,2*3.1415);//2.*atan(Y/(X+r));
			double theta =  random(0,3.1415);
			X = rayon*r*cos(phi)*sin(theta);
			Y= rayon*r*sin(phi)*sin(theta);
			Z = epaisseur * r* cos(theta);
			
			systeme.push_back(new Planete( valarray<double>{X,Y,Z}, valarray<double>{-V*sin(phi),V*cos(phi),0.},1,dt ));
	}
	//systeme.push_back(new Planete( valarray<double>{0,0,0}, valarray<double>{0,0,0},100000,dt ));
	//nbEtoile++;
	double maxX=0.,maxY=0.,maxZ=0.;

		
	Noeud* Eve = new Noeud(systeme, -rayon,rayon,-rayon,rayon,-epaisseur,epaisseur);

	
	ofstream* coordPlanete = new ofstream("coord.out"); 
		coordPlanete->precision(5);

	
	cout << "Initialisation Finie, t = " << time(nullptr) - timeBegin << " s" <<endl;
	
	int pourcent(0),actual(0);
	for(double t(0); t < tfin; t+=dt){
		pourcent = trunc(100 * t/tfin);
		if(pourcent>actual){
				actual = pourcent;
				cout << pourcent << "%" << endl;
		}
		
		
		for(int i(0); i<systeme.size(); i++){
			systeme[i]->A = Eve->Acc(systeme[i]);
		}
		
		for(int i(0); i<systeme.size(); i++){
			*coordPlanete << systeme[i]->X[0] << ", " ;
		}
		*coordPlanete << endl;
		for(int i(0); i<systeme.size(); i++){
			*coordPlanete << systeme[i]->X[1] << ", " ;
			
		}
		*coordPlanete << endl;
		for(int i(0); i<systeme.size(); i++){
			*coordPlanete << systeme[i]->X[2] << ", " ;
		}
		*coordPlanete << endl;
		for(int i(0); i<systeme.size(); i++){
			*coordPlanete << systeme[i]->getA()  << ", " ;
		}
		*coordPlanete << endl;
		
		
		
		
		
		double maxX=0.,maxY=0.,maxZ=0.;
		for(int i(0); i<systeme.size(); i++){
			systeme[i]->step(dt);
			if(abs(systeme[i]->X[0]) > maxX)maxX = abs(systeme[i]->X[0]);
			if(abs(systeme[i]->X[1]) > maxY)maxY = abs(systeme[i]->X[1]);
			if(abs(systeme[i]->X[2]) > maxZ)maxZ = abs(systeme[i]->X[2]);
			
		}
		delete Eve;
		Eve = new Noeud(systeme,-maxX,maxX,-maxY,maxY,-maxZ,maxZ);
		
		
		
		
		
	}
	cout << "Simulation Finie, t = " << time(nullptr) - timeBegin << " s" <<endl;
	coordPlanete->close();
  return 0;
}
