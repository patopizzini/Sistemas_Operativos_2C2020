//75.08 - 2C 2020 - GRUPO 3
//
//79979 - GONZALEZ, JUAN MANUEL (juagonzalez@fi.uba.ar)
//85881 - SILVESTRI, ANDRES (asilvestri@fi.uba.ar)
//91076 - PORRAS CARHUAMACA, SHERLY KATERIN (sporras@fi.uba.ar)
//97524 - PIZZINI, PATRICIO (ppizzini@fi.uba.ar)
//
//TP2 - Ruta - Estructuras de datos para memoria compartida

#ifndef RUTA_DATOS_H
#define RUTA_DATOS_H

//Definición de la estructura a almacenar en la memoria compartida
typedef struct {
	int n_VM; //Cantidad de vehículos en circulación en sentido VM
	int c_VM; //Cantidad de vehículos en espera en la cabecera del valle
	int n_MV; //Cantidad de vehículos en circulación en sentido MV
	int c_MV; //Cantidad de vehículos en espera en la cabecera del monte
} contador;

#endif
