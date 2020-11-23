#!/bin/bash
#
#75.08 - 2C 2020 - GRUPO 3
#
#79979 - GONZALEZ, JUAN MANUEL (juagonzalez@fi.uba.ar)
#85881 - SILVESTRI, ANDRES (asilvestri@fi.uba.ar)
#91076 - PORRAS CARHUAMACA, SHERLY KATERIN (sporras@fi.uba.ar)
#97524 - PIZZINI, PATRICIO (ppizzini@fi.uba.ar)
#
#TP1 - arrancaproceso

if [[ -f "./pprincipal.sh" ]]
then
	if [[ "$INICIALIZAR" == "EXITO" ]]
	then
		PID_PPAL=$(pgrep -fn pprincipal)
		if [[ "$PID_PPAL" -gt 0 ]]
		then
			echo "El proceso principal ya se encuentra corriendo, con PID: $PID_PPAL."
			echo "Fin - arrancarproceso (1)"
			exit
		else
			./pprincipal.sh &
			PID_PPAL_LAUNCH=$!
			echo "Proceso principal iniciado, con PID: $PID_PPAL_LAUNCH."
		fi
	else
		echo "El ambiente no se encuentra inicializado. Por favor ejecute \"iniciarambiente.sh\"."
		echo "Fin - arrancarproceso (1)"
		exit 1
	fi
	else
		"No se encuentra el archivo a ejecutar, por favor verifique su instalación."
		echo "Fin - arrancarproceso (1)"
		exit 1
fi

#Retorno al SO
echo ""
echo "Fin - arrancarproceso (0)"
exit 0
