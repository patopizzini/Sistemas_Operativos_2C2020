#!/bin/bash
#
#75.08 - 2C 2020 - GRUPO 3
#
#79979 - GONZALEZ, JUAN MANUEL (juagonzalez@fi.uba.ar)
#85881 - SILVESTRI, ANDRES (asilvestri@fi.uba.ar)
#91076 - PORRAS CARHUAMACA, SHERLY KATERIN (sporras@fi.uba.ar)
#97524 - PIZZINI, PATRICIO (ppizzini@fi.uba.ar)
#
#TP1 - pprincipal

#Configuración del intevalo entre ejecuciones, 8 segundos por enunciado
INTERVALO_SEGUNDOS=8
NUMERO_CICLO=0

#Ciclo infinito a repetir según el intervalo configurado
while true
do
	#El primer ciclo es 1
	let "NUMERO_CICLO++"
	#Sleep para tener una pausa entre ejecuciones (parametrizable)
	sleep "$INTERVALO_SEGUNDOS"
done

#Retorno al SO
exit 0
