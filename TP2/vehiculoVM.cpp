//75.08 - 2C 2020 - GRUPO 3
//
//79979 - GONZALEZ, JUAN MANUEL (juagonzalez@fi.uba.ar)
//85881 - SILVESTRI, ANDRES (asilvestri@fi.uba.ar)
//91076 - PORRAS CARHUAMACA, SHERLY KATERIN (sporras@fi.uba.ar)
//97524 - PIZZINI, PATRICIO (ppizzini@fi.uba.ar)
//
//TP2 - Ruta - Vehiculo VM

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
	cout << "TP2 - Ruta - Vehiculo VM" << endl;

	//Instanciación de los semáforos
	sv_sem sVM ("sVM");
	sv_sem sMV ("sMV");

	//Instanciación y acceso a la memoria compartida
	sv_shm datos ("datos");
	contador *p_contador;
	p_contador=reinterpret_cast<contador*>(datos.map(sizeof(contador)));

	//Inicio de vehiculoVM
	cout << endl;
	cout << "VehiculoVM iniciado." << endl;

	//Se mira si existen vehículos en circulando en la ruta
	//En sentido contrario
	if (p_contador->n_MV > 0) {
		
		//En caso afirmativo, hay que esperar que se libere el camino
		//Se incrementa el contador de esperas en la cabecera del valle
		p_contador->c_VM = p_contador->c_VM + 1;
		
		//Mensaje de espera
		cout << endl;
		cout << "Hay vehículos circulando en la dirección MV." << endl;
		cout << "Esperando..." << endl;
		
		//Se hace el wait para parar el proceso y que espere
		sVM.wait();
	}
	
	//Si no hay vehículos en sentido contrario, o cruzaron todos
	//Se entra a la ruta (seccion critica)
	//Se incrementa el contador de vehículos en circulación
	p_contador->n_VM = p_contador->n_VM + 1;

	//Se muestra un mensaje mientras el vehículo ocupa la ruta
	//y se espera el input del usuario para continuar
	cout << endl;
	cout << "Vehículo circulando del valle al monte (VM)" << endl;
	cout << "Presione ENTER para continuar..." << endl;
	cin.ignore();
	
	//Presionado ENTER, el vehículo sale de la ruta
	//Se decrementa el contador de vehículos en la ruta, en el sentido VM
	p_contador->n_VM = p_contador->n_VM - 1;
	//En caso de que fuera el útlimo vehículo en la ruta
	//Se liberan los vehículos que estaban esperando en la otra cabecera
	if (p_contador->n_VM == 0) {
		
		//Para todos los vehículos en cola en la cabecera contraria
		//Para que puedan ingresar a la ruta
		for (int i=0; i<p_contador->c_MV; i++) {

			//Post del semáforo
			sMV.post();
		}
		p_contador->c_MV = 0;
	}

	//Mensaje de fin de ejecución
	cout << "VehiculoVM terminado." << endl;

	//Retorno al SO, código de éxito
	return 0;
}
