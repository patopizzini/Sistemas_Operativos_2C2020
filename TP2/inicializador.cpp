//75.08 - 2C 2020 - GRUPO 3
//
//79979 - GONZALEZ, JUAN MANUEL (juagonzalez@fi.uba.ar)
//85881 - SILVESTRI, ANDRES (asilvestri@fi.uba.ar)
//91076 - PORRAS CARHUAMACA, SHERLY KATERIN (sporras@fi.uba.ar)
//97524 - PIZZINI, PATRICIO (ppizzini@fi.uba.ar)
//
//TP2 - Ruta - Inicializador

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
	cout << "TP2 - Ruta - Inicializador" << endl;
	
	//Inicio de inicialización
	cout << endl;
	cout << "Inicializado estructuras..." << endl;

	//Creación de la estructura a almacenar en la memoria compartida
	//Contadores para vehículos en circulación en ambos sentidos
	//Contadores para vehículos en espera en ambas cabeceras
	sv_shm datos ("datos");
	void * ptr;
	contador *p_contador;
	int len=sizeof(contador);
	ptr=datos.map(len);
	p_contador=reinterpret_cast<contador *>(ptr);
	
	//Inicialización de los contadores en memoria compartida
	p_contador->n_VM = 0;
	p_contador->c_VM = 0;
	p_contador->n_MV = 0;
	p_contador->c_MV = 0;

	//Impresión de los datos en la memoria compartida
	cout << endl;
	cout << "Memoria compartida" << endl;
	cout << "Valor del contador en ruta VM: " << p_contador->n_VM << endl;
	cout << "Valor del contador en cola VM: " << p_contador->c_VM << endl;
	cout << "Valor del contador en ruta MV: " << p_contador->n_MV << endl;
	cout << "Valor del contador en cola MV: " << p_contador->c_MV << endl;
	
	//Creación de los semáforos
	//Un semáforo para cada cabecera
	sv_sem sVM ("sVM",0);
	sv_sem sMV ("sMV",0);
		
	//Impresión de los datos de los semáforos
	cout << endl;
	cout << "Semáforos" << endl;	
	cout << "Creado semaforo sVM con id: " << sVM.getsem() << ", clave: " << sVM.getClave() << "." << endl; 
	cout << "Creado semaforo sMV con id: " << sMV.getsem() << ", clave: " << sMV.getClave() << "." << endl; 
	
	//Mensaje de fin de ejecución
	cout << endl;
	cout << "Inicializador terminado." << endl;

	//Retorno al SO, código de éxito
	return 0;
}
