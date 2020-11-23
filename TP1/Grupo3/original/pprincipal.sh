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

#Variables con directorios, valores por default
#El path base es un nivel arriba de donde ejecuta el script de instalación
PATH_BASE=$(pwd)
PATH_BASE=${PATH_BASE%/*}

#Variables con ubicacion de archivos
PATH_CONFIGURACION="$PATH_BASE/so7508/instalarTP.conf"
PATH_LOG_PROCESO_PPAL="$PATH_BASE/so7508/pprincipal.log"

#Configuración del intevalo entre ejecuciones, 8 segundos por enunciado
INTERVALO_SEGUNDOS=10 #60
NUMERO_CICLO=0

#Función para registrar mensajes en el log
#$1 - TIPO (INF/ALE/ERR)
#$2 - MENSAJE
#$3 - ORIGEN
log_message() {
	echo "\"$(date -R)\"-\"$1\"-\"$2\"-\"$3\"-\"$USER\"" >> "$PATH_LOG_PROCESO_PPAL"
}

#Función a ejecutar antes de finalizar el proceso
finalizar() {
	MENSAJE="Se detectó frenar proceso."
	log_message "INF" "$MENSAJE" "pprincipal.sh"
	MENSAJE="Fin - pprincipal (0)"
	log_message "INF" "$MENSAJE" "pprincipal.sh"

	exit 0
}

#Funcion que se encarga de leer el directorio input y clasificar los archivos
#Deja un array de archivos candidatos en $ARCHIVOS_ACEPTADOS
procesar_input(){

	MENSAJE="Inicio de clasificación de archivos..."
	log_message "INF" "$MENSAJE" "procesar input"
	ARCHIVOS_PROCESADOS=()
	while IFS= read -r -d $'\0';
	do
		ARCHIVOS_PROCESADOS+=("$REPLY")
	done < <(find "$DIRPROC" -maxdepth 1 -type f -name "C[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_Lote[0-9][0-9][0-9][0-9].txt" -print0)
	
	find "$DIRIN" -maxdepth 1 -type f -not -name "C[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_Lote[0-9][0-9][0-9][0-9].txt" |
	while read file
	do
		if [[ -f "$file" ]]
		then
			MENSAJE="El archivo \"$file\" tiene un nombre incorrecto. Se movió a rechazados."
			log_message "ERR" "$MENSAJE" "procesar input"
			mv "$file" "$DIRRECH"
		fi
	done

	ARCHIVOS_POSIBLES=()
	while IFS= read -r -d $'\0';
	do
		ARCHIVOS_POSIBLES+=("$REPLY")
	done < <(find "$DIRIN" -maxdepth 1 -type f -name "C[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_Lote[0-9][0-9][0-9][0-9].txt" -print0)
	for file in "${ARCHIVOS_POSIBLES[@]}"
	do
		if [[ -f "$file" ]]
		then
			#Es un archivo
			if [[ ! -s "$file" ]] #Archivo vacío
			then
				MENSAJE="El archivo \"$file\" está vacío. Se movió a rechazados."
				log_message "ERR" "$MENSAJE" "procesar input"
				mv "$file" "$DIRRECH"
			else
				if [[ -z "$(file $file | grep text)" ]] #Archivo binario
				then
					MENSAJE="El archivo \"$file\" no es de texto. Se movió a rechazados."
					log_message "ERR" "$MENSAJE" "procesar input"
					mv "$file" "$DIRRECH"
				else
					posibleMerchantCode="$(echo $file | sed -n 's-.*\([0-9]\{8\}\).*-\1-p')"
					if [[ -z "$(cut -d, -f1 "$DIRMAE/comercios.txt" | grep $posibleMerchantCode)" ]] #Validar merchant code
					then
						MENSAJE="El merchant code del archivo \"$file\" no existe en tabla maestra de comercios. Se movió a rechazados."
						log_message "ERR" "$MENSAJE" "procesar input"
						mv "$file" "$DIRRECH"
					else
						DUPLICADO=0
						for i in "${ARCHIVOS_PROCESADOS[@]}"
						do
							if [[ $(basename -- "$i") == $(basename -- "$file") ]]
							then
								MENSAJE="El archivo \"$file\" se encuentra duplicado. Se movió a rechazados."
								log_message "ERR" "$MENSAJE" "procesar input"
								mv "$file" "$DIRRECH"
								DUPLICADO=1
								break
							fi
						done
					
						if [[ $DUPLICADO -eq 0 ]]
						then
							ARCHIVOS_ACEPTADOS+=("$(basename -- \"$file\")")
							MENSAJE="El archivo \"$file\" fue aceptado. Se movió a aceptados."
							log_message "INF" "$MENSAJE" "procesar input"
							mv "$file" "$DIRIN/ok"
						fi
					fi
				fi
			fi
		fi
	done
}

#Mensaje y log de inicio
MENSAJE='TP1 - SO75.08 - 2do Cuatrimestre 2020 - Curso Martes Copyright © Grupo 3'
log_message "INF" "$MENSAJE" "pprincipal.sh"
MENSAJE="Inicio - Proceso principal"
log_message "INF" "$MENSAJE" "pprincipal.sh"

#Verificamos si el ambiente se encuentra inicializado
if [[ $INICIALIZAR != "EXITO" ]]
then
	MENSAJE="El ambiente no se encuentra inicializado. Por favor ejecute \"iniciarambiente.sh\"."
	echo $MENSAJE
	log_message "ERR" "$MENSAJE" "pprincipal.sh"
	MENSAJE="Fin - pprincipal (1)"
	echo $MENSAJE
	log_message "ERR" "$MENSAJE" "pprincipal.sh"

	exit 1
fi

#Verificamos si el proceso no se encuentra corriendo
PID_PPAL=$(pgrep -fo pprincipal)
if [[ "$PID_PPAL" -gt 0 ]] && [[ "$PID_PPAL" -ne "$$" ]]
then
	MENSAJE="El proceso principal ya se encuentra corriendo, con PID: $PID_PPAL."
	echo $MENSAJE
	log_message "ERR" "$MENSAJE" "pprincipal.sh"	
	MENSAJE="Fin - pprincipal (1)"
	echo $MENSAJE
	log_message "ERR" "$MENSAJE" "pprincipal.sh"

	exit 1
fi

#Retorno al SO
trap finalizar TERM

#Logeamos las variables de entorno con los paths
MENSAJE="Valor de la variable \"GRUPO\": $GRUPO"
log_message "INF" "$MENSAJE" "pprincipal.sh"
MENSAJE="Valor de la variable \"DIRINST\": $DIRINST"
log_message "INF" "$MENSAJE" "pprincipal.sh"
MENSAJE="Valor de la variable \"DIRBIN\": $DIRBIN"
log_message "INF" "$MENSAJE" "pprincipal.sh"
MENSAJE="Valor de la variable \"DIRMAE\": $DIRMAE"
log_message "INF" "$MENSAJE" "pprincipal.sh"
MENSAJE="Valor de la variable \"DIRIN\": $DIRIN"
log_message "INF" "$MENSAJE" "pprincipal.sh"
MENSAJE="Valor de la variable \"DIRRECH\": $DIRRECH"
log_message "INF" "$MENSAJE" "pprincipal.sh"
MENSAJE="Valor de la variable \"DIRPROC\": $DIRPROC"
log_message "INF" "$MENSAJE" "pprincipal.sh"
MENSAJE="Valor de la variable \"DIROUT\": $DIROUT"
log_message "INF" "$MENSAJE" "pprincipal.sh"

#Ciclo infinito a repetir según el intervalo configurado
MENSAJE="Comenzando procesamiento..."
log_message "INF" "$MENSAJE" "pprincipal.sh"
while true
do
	#El primer ciclo es 1
	let "NUMERO_CICLO++"
	MENSAJE="Comenzando el ciclo: $NUMERO_CICLO"
	log_message "INF" "$MENSAJE" "pprincipal.sh"
	
	############################################
	# REALIZAR EL PROCESAMIENTO
	############################################

	#Procesar input
	#Array con archivos candidatos para los pasos siguientes
	ARCHIVOS_ACEPTADOS=()
	procesar_input
	CANT_ARCHIVOS_ACEPTADOS=${#ARCHIVOS_ACEPTADOS[@]}
	MENSAJE="Se encontraron $CANT_ARCHIVOS_ACEPTADOS candidatos en \"$DIRIN\"."
	log_message "INF" "$MENSAJE" "pprincipal.sh"
	MENSAJE="Fin de clasificación de archivos."
	log_message "INF" "$MENSAJE" "pprincipal.sh"
	
	if [[ $CANT_ARCHIVOS_ACEPTADOS -gt 0 ]]
	then
		
		#Validar candidatos
		MENSAJE="Fin de validación de candidatos."
		log_message "INF" "$MENSAJE" "pprincipal.sh"
		
		#Calcular comisiones y generar salida
		MENSAJE="Fin de cálculo de comisiones y escritura de salida."
		log_message "INF" "$MENSAJE" "pprincipal.sh"
	fi
	
	#Sleep para tener una pausa entre ejecuciones (parametrizable)
	MENSAJE="Durmiendo $INTERVALO_SEGUNDOS segundos."
	log_message "INF" "$MENSAJE" "pprincipal.sh"	
	sleep "$INTERVALO_SEGUNDOS"
done
