#!/bin/bash
#
#75.08 - 2C 2020 - GRUPO 3
#
#79979 - GONZALEZ, JUAN MANUEL (juagonzalez@fi.uba.ar)
#85881 - SILVESTRI, ANDRES (asilvestri@fi.uba.ar)
#91076 - PORRAS CARHUAMACA, SHERLY KATERIN (sporras@fi.uba.ar)
#97524 - PIZZINI, PATRICIO (ppizzini@fi.uba.ar)
#
#TP1 - instalarTP

#Variables con los datos de la instalación
TIPO_INSTALACION="INSTALACION"
ESTADO_INSTALACION="NO LISTA"

#Variables con directorios, valores por default
#El path base es un nivel arriba de donde ejecuta el script de instalación
PATH_BASE=$(pwd)
PATH_BASE=${PATH_BASE%/*}
PATH_EJECUTABLES="/bin"
PATH_TABLAS="/master"
PATH_NOVEDADES="/input"
PATH_ACEPTADAS="/ok"
PATH_RECHAZADAS="/rechazos"
PATH_LOTES="/lotes"
PATH_TRANSACCIONES="/output"
PATH_COMISIONES="/comisiones"

#Variables con ubicacion de archivos
PATH_SCRIPT_INSTALACION="$PATH_BASE/so7508/instalarTP.sh"
PATH_LOG_INSTALACION="$PATH_BASE/so7508/instalarTP.log"
PATH_CONFIGURACION="$PATH_BASE/so7508/instalarTP.conf"
PATH_LOG_INICIALIZACION="$PATH_BASE/so7508/inicarambiente.log"
PATH_LOG_PROCESO_PPAL="$PATH_BASE/so7508/pprincipal.log"

#Variable con nombres reservados
#Se pueden agregar los que se deseen
RESERVADOS="^(Grupo3|so7508|original|catedra|propios|testeos)$"

#Función para registrar mensajes en el log
log_message() {
	echo "$(date -R): $1" >> "$PATH_LOG_INSTALACION"
}

#Función que chequea si el directorio ingresado es reservado o se encuentra en uso
check_dir() {

	if [[ "$1" != "" ]]
	then
		#Verificamos que comienze con '/'
		if [[ $1 != /* ]]
		then 
			echo "El nombre \""$1\"" debe comenzar con el caracter '/', intente nuevamente."
			return 1
		fi
		
		#Revisamos que no exista una palabra reservada
		IFS="/" read -ra DIR_PARTS <<< "$1"
		for i in "${DIR_PARTS[@]}"
		do
			if [[ "$i" =~ $RESERVADOS ]]
			then
				echo "El nombre \""$i\"" es una plabra reservada, intente nuevamente."
				return 1
			fi
		done
		
		#Revisamos que no se haya definido el path para otro directorio
		REPETIDO=0
			
		if [[ "$1" == "$PATH_EJECUTABLES" ]] && [[ "$2" != "$PATH_EJECUTABLES" ]]
		then
			REPETIDO=1
		fi
		if [[ "$1" == "$PATH_TABLAS" ]] && [[ "$2" != "$PATH_TABLAS" ]]
		then
			REPETIDO=1
		fi
		if [[ "$1" == "$PATH_NOVEDADES" ]] && [[ "$2" != "$PATH_NOVEDADES" ]]
		then
			REPETIDO=1
		fi
		if [[ "$1" == "$PATH_RECHAZADAS" ]] && [[ "$2" != "$PATH_RECHAZADAS" ]]
		then
			REPETIDO=1
		fi
		if [[ "$1" == "$PATH_LOTES" ]] && [[ "$2" != "$PATH_LOTES" ]]
		then
			REPETIDO=1
		fi
		if [[ "$1" == "$PATH_TRANSACCIONES" ]] && [[ "$2" != "$PATH_TRANSACCIONES" ]]
		then
			REPETIDO=1
		fi

		if [[ $REPETIDO == 1 ]]
		then
			echo "El nombre \""$1\"" está definido como otro de los path del sistema, intente nuevamente."
			return 1
		else
			#Asignamos el valor ingresado a la variable, como definitiva
			eval "$3"="\"$1\""
			return 0
		fi
	fi

	#Queda el valor default, no hubo input
	return 0
}

#Función para definir lo directorios
define_dirs() { 

	echo ""
	echo "Por favor, defina los siguientes directorios: "
	echo "Definidos desde el path base \""$PATH_BASE\""".
	echo ""
	chk=1
	while true; do
		echo -n "Ejecutables [$PATH_EJECUTABLES]: "
		IFS= read -r PATH_EJECUTABLES_INPUT
		check_dir "$PATH_EJECUTABLES_INPUT" "$PATH_EJECUTABLES" "PATH_EJECUTABLES"
		chk=$(echo $?)
		[[ $chk != 0 ]] || break
	done
	chk=1
	while true; do
		echo -n "Tablas      [$PATH_TABLAS]: "
		IFS= read -r PATH_TABLAS_INPUT
		check_dir "$PATH_TABLAS_INPUT" "$PATH_TABLAS" "PATH_TABLAS"
		chk=$(echo $?)
		[[ $chk != 0 ]] || break
	done
	chk=1
	while true; do
		echo -n "Novedades   [$PATH_NOVEDADES]: "
		IFS= read -r PATH_NOVEDADES_INPUT
		check_dir "$PATH_NOVEDADES_INPUT" "$PATH_NOVEDADES" "PATH_NOVEDADES"
		chk=$(echo $?)
		[[ $chk != 0 ]] || break
	done
	chk=1
	while true; do
		echo -n "Rechazados  [$PATH_RECHAZADAS]: "
		IFS= read -r PATH_RECHAZADAS_INPUT
		check_dir "$PATH_RECHAZADAS_INPUT" "$PATH_RECHAZADAS" "PATH_RECHAZADAS"
		chk=$(echo $?)
		[[ $chk != 0 ]] || break
	done
	chk=1
	while true; do
		echo -n "Procesados  [$PATH_LOTES]: "
		IFS= read -r PATH_LOTES_INPUT
		check_dir "$PATH_LOTES_INPUT" "$PATH_LOTES" "PATH_LOTES"
		chk=$(echo $?)
		[[ $chk != 0 ]] || break
	done
	chk=1
	while true; do
		echo -n "Resultados  [$PATH_TRANSACCIONES]: "
		IFS= read -r PATH_TRANSACCIONES_INPUT
		check_dir "$PATH_TRANSACCIONES_INPUT" "$PATH_TRANSACCIONES" "PATH_TRANSACCIONES"
		chk=$(echo $?)
		[[ $chk != 0 ]] || break
	done

	ESTADO_INSTALACION="LISTA"
}

show_details() {
	
	clear
	echo 'TP1 - SO75.08 - 2do Cuatrimestre 2020 - Curso Martes Copyright © Grupo 3'
	MENSAJE="Confirmar Proceso - instalarTP"
	echo "$MENSAJE"
	log_message "$MENSAJE"
	echo ""

	#Mostramos el mensaje por pantalla
	echo "Tipo de proceso: $TIPO_INSTALACION"
	echo "Directorio padre: \""$PATH_BASE"\""
	echo "Ubicación script de instalación: \""$PATH_SCRIPT_INSTALACION"\""
	echo "Log de la instalación: \""$PATH_LOG_INSTALACION"\""
	echo "Archivo de configuración: \""$PATH_CONFIGURACION"\""
	echo "Log de la inicialización: \""$PATH_LOG_INICIALIZACION"\""
	echo "Log del proceso principal: \""$PATH_LOG_PROCESO_PPAL"\""
	echo "Directorio de ejecutables: \""$PATH_BASE$PATH_EJECUTABLES"\""
	echo "Directorio de tablas maestras: \""$PATH_BASE$PATH_TABLAS"\""
	echo "Directorio de novedades: \""$PATH_BASE$PATH_NOVEDADES"\""
	echo "Directorio novedades aceptadas: \""$PATH_BASE$PATH_NOVEDADES$PATH_ACEPTADAS"\""
	echo "Directorio de rechazados: \""$PATH_BASE$PATH_RECHAZADAS"\""
	echo "Directorio de lotes procesados: \""$PATH_BASE$PATH_LOTES"\""
	echo "Directorio de transacciones: \""$PATH_BASE$PATH_TRANSACCIONES"\""
	echo "Directorio de comisiones: \""$PATH_BASE$PATH_TRANSACCIONES$PATH_COMISIONES"\""
	echo "Estado de la instalación: \""$ESTADO_INSTALACION"\""

	return 0
}

#Funcion para intalación
clean_install() {

	#PROCESO PARA INSTALAR DE 0
	chk_ci=1
	while true; do
		#Pedimos al usuario los directorios
		define_dirs
		#Mostramos el resumen
		show_details
		#Pedimos al usuario confirmación
		echo ""
		echo -n "¿Confirma la instalación? (SI-[NO]): "
		IFS= read -r CONFIRMA_CLEAN
		if [[ $CONFIRMA_CLEAN == "SI" ]] || [[ $CONFIRMA_CLEAN == "si" ]]
		then
			chk_ci=0
		else
			echo ""
			echo "Instalación no confirmada."
			ESTADO_INSTALACION="NO LISTA"
		fi
		[[ $chk_ci != 0 ]] || break
	done
	
	#Confirmó los valores, hacer la instalación
	echo ""
	echo "Instalación confirmada."
	#Creación de directorios
	ERR_ID_FLAG=0
	ERR_ID=$(mkdir -p "$PATH_BASE$PATH_EJECUTABLES" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		echo "Error creando directorio: $ERR_ID"
		ERR_ID_FLAG=1
	fi
	ERR_ID=$(mkdir -p "$PATH_BASE$PATH_TABLAS" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		echo "Error creando directorio: $ERR_ID"
		ERR_ID_FLAG=1
	fi
	ERR_ID=$(mkdir -p "$PATH_BASE$PATH_NOVEDADES" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		echo "Error creando directorio: $ERR_ID"
		ERR_ID_FLAG=1
	fi
	ERR_ID=$(mkdir -p "$PATH_BASE$PATH_NOVEDADES$PATH_ACEPTADAS" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		echo "Error creando directorio: $ERR_ID"
		ERR_ID_FLAG=1
	fi
	ERR_ID=$(mkdir -p "$PATH_BASE$PATH_RECHAZADAS" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		echo "Error creando directorio: $ERR_ID"
		ERR_ID_FLAG=1
	fi
	ERR_ID=$(mkdir -p "$PATH_BASE$PATH_LOTES" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		echo "Error creando directorio: $ERR_ID"
		ERR_ID_FLAG=1
	fi
	ERR_ID=$(mkdir -p "$PATH_BASE$PATH_TRANSACCIONES" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		echo "Error creando directorio: $ERR_ID"
		ERR_ID_FLAG=1
	fi
	ERR_ID=$(mkdir -p "$PATH_BASE$PATH_TRANSACCIONES$PATH_COMISIONES" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		echo "Error creando directorio: $ERR_ID"
		ERR_ID_FLAG=1
	fi
	#Copia de los archivos
	ERR_IC_FLAG=0
	ERR_IC=$(cp "$PATH_BASE/original/arrancarproceso.sh" $PATH_BASE$PATH_EJECUTABLES 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		echo "Error copiando archivos: $ERR_IC"
		ERR_IC_FLAG=1
	fi
	ERR_IC=$(cp "$PATH_BASE/original/frenarproceso.sh" $PATH_BASE$PATH_EJECUTABLES 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		echo "Error copiando archivos: $ERR_IC"
		ERR_IC_FLAG=1
	fi
	ERR_IC=$(cp "$PATH_BASE/original/iniciarambiente.sh" $PATH_BASE$PATH_EJECUTABLES 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		echo "Error copiando archivos: $ERR_IC"
		ERR_IC_FLAG=1
	fi
	ERR_IC=$(cp "$PATH_BASE/original/pprincipal.sh" $PATH_BASE$PATH_EJECUTABLES 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		echo "Error copiando archivos: $ERR_IC"
		ERR_IC_FLAG=1
	fi
	
	if [[ $ERR_ID_FLAG != 0 ]] || [[ $ERR_IC_FLAG != 0 ]]
	then
		echo ""
		echo "Error de instalación!"
		ESTADO_INSTALACION="ABORTADA"
		echo "Estado de la instalación: $ESTADO_INSTALACION"
		echo ""
		MENSAJE="Fin - instalarTP (1)"
		echo "$MENSAJE"
		log_message "$MENSAJE"
		exit 1
	else
		#Escritura de archivo de configuración
		echo "GRUPO-\"$PATH_BASE\"" > $PATH_CONFIGURACION
		echo "DIRINST-\"$PATH_SCRIPT_INSTALACION\"" >> $PATH_CONFIGURACION
		echo "DIRBIN-\"$PATH_BASE$PATH_EJECUTABLES\"" >> $PATH_CONFIGURACION
		echo "DIRMAE-\"$PATH_BASE$PATH_TABLAS\"" >> $PATH_CONFIGURACION
		echo "DIRIN-\"$PATH_BASE$PATH_NOVEDADES\"" >> $PATH_CONFIGURACION
		echo "DIRRECH-\"$PATH_BASE$PATH_RECHAZADAS\"" >> $PATH_CONFIGURACION
		echo "DIRPROC-\"$PATH_BASE$PATH_LOTES\"" >> $PATH_CONFIGURACION
		echo "DIROUT-\"$PATH_BASE$PATH_TRANSACCIONES\"" >> $PATH_CONFIGURACION
		echo "INTSTALACION-\"$(date -R)\"-$USER" >> $PATH_CONFIGURACION
	
		#Instalación finalizada
		ESTADO_INSTALACION="COMPLETADA"
		echo "Estado de la instalación: $ESTADO_INSTALACION"
	fi
}

#Funcion para reparación
repair_install() {

	echo "FUNCION PARA REPARAR LA INSTALACION"
	return 0
} 

#Funcion para chequeo
check_install() {

	echo "FUNCION PARA CHEQUEAR LA INSTALACION"
	return 0
} 

#FLUJO PRINCIPAL
#Limpiamos la pantalla
clear

#Mensaje y log de inicio
echo 'TP1 - SO75.08 - 2do Cuatrimestre 2020 - Curso Martes Copyright © Grupo 3'
MENSAJE="Inicio - instalarTP"
echo "$MENSAJE"
log_message "$MENSAJE"
echo ""

#Validacion de existencia del archivo de configuración
#ToDO
if [ ! -f "$PATH_CONFIGURACION" ]; then
	
	MENSAJE="El archivo \""$PATH_CONFIGURACION\"" no existe."
	echo "$MENSAJE"
	log_message "$MENSAJE"
	MENSAJE="Tipo de ejecución: INSTALACIÓN."
	echo "$MENSAJE"
	log_message "$MENSAJE"
	TIPO_INSTALACION="INSTALACION"
else	
	MENSAJE="El archivo \""$PATH_CONFIGURACION\"" fue encontrado."
	echo "$MENSAJE"
	log_message "$MENSAJE"
	MENSAJE="Tipo de ejecución: CHEQUEO."
	echo "$MENSAJE"
	log_message "$MENSAJE"	
	TIPO_INSTALACION="CHEQUEO"
fi

#Llamada a las operaciones de instalacion y reparacion
if [ $TIPO_INSTALACION = "INSTALACION" ]; then
	clean_install
else
	if [ $TIPO_INSTALACION = "CHEQUEO" ]; then
		check_install
	else
		MENSAJE="Fin - instalarTP (1). Operación inválida."
		echo "$MENSAJE"
		log_message "$MENSAJE"
		exit 1
	fi
fi

#Mensaje y log de fin de ejecución
echo ""
MENSAJE="Fin - instalarTP (0)"
echo "$MENSAJE"
log_message "$MENSAJE"

#Retorno al shell con código de éxito
exit 0
