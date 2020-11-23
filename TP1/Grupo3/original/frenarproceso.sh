#!/bin/bash
#
#75.08 - 2C 2020 - GRUPO 3
#
#79979 - GONZALEZ, JUAN MANUEL (juagonzalez@fi.uba.ar)
#85881 - SILVESTRI, ANDRES (asilvestri@fi.uba.ar)
#91076 - PORRAS CARHUAMACA, SHERLY KATERIN (sporras@fi.uba.ar)
#97524 - PIZZINI, PATRICIO (ppizzini@fi.uba.ar)
#
#TP1 - frenaproceso

PID_PPAL=$(pgrep -fn pprincipal)
if [[ "$PID_PPAL" -gt 0 ]]
then
	kill -15 $PID_PPAL
	if [[ $? = 0 ]]
	then
		echo "Proceso principal detenido satisfactoriamente."
	fi
else
	echo "El proceso principal no se encuentra corriendo."
	echo "Fin - frenarproceso (1)"
	exit 1
fi

#Retorno al SO
echo ""
echo "Fin - frenarproceso (0)"
exit 0
