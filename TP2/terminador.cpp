//75.08 - 2C 2020 - GRUPO 3
//
//79979 - GONZALEZ, JUAN MANUEL (juagonzalez@fi.uba.ar)
//85881 - SILVESTRI, ANDRES (asilvestri@fi.uba.ar)
//91076 - PORRAS CARHUAMACA, SHERLY KATERIN (sporras@fi.uba.ar)
//97524 - PIZZINI, PATRICIO (ppizzini@fi.uba.ar)
//
//TP2 - Ruta - Terminador

#include <iostream>
#include "ruta_datos.h"
#include "Sem-sv/sv_sem.h"
#include "Sem-sv/sv_shm.h"

using namespace std;

int main()
{
	//Mensaje inicial, nombre de programa
	cout << "75.08 - 2C 2020 - GRUPO 3" << endl;
	cout << endl;
	cout << "79979 - GONZALEZ, JUAN MANUEL (juagonzalez@fi.uba.ar)" << endl;
	cout << "85881 - SILVESTRI, ANDRES (asilvestri@fi.uba.ar)" << endl;
	cout << "91076 - PORRAS CARHUAMACA, SHERLY KATERIN (sporras@fi.uba.ar)" << endl;
	cout << "97524 - PIZZINI, PATRICIO (ppizzini@fi.uba.ar)" << endl;
	cout << endl;
	cout << "TP2 - Ruta - Terminador" << endl;
	
	//Destrucción de memoria compartida
	sv_shm datos ("datos");
	datos.del();
	cout << endl;
	cout << "Estructuras eliminadas de la memoria compartida." << endl;	

	//Destrucción de semáforos
	sv_sem sVM ("sVM",0);	
	sVM.del();
	sv_sem sMV ("sMV",0);	
	sMV.del();
	cout << "Semáforos eliminados." << endl;

	//Mensaje de fin de ejecución
	cout << endl;
	cout << "Terminador terminado." << endl;

	//Retorno al SO, código de éxito
	return 0;
}
