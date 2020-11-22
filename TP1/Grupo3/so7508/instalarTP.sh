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
DEBE_REPARAR=0

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
PATH_LOG_INICIALIZACION="$PATH_BASE/so7508/iniciarambiente.log"
PATH_LOG_PROCESO_PPAL="$PATH_BASE/so7508/pprincipal.log"

#Variables de control para el reparar instalación
FIX_PATH_EJECUTABLES=0
FIX_PATH_TABLAS=0
FIX_PATH_NOVEDADES=0
FIX_PATH_ACEPTADAS=0
FIX_PATH_RECHAZADAS=0
FIX_PATH_LOTES=0
FIX_PATH_TRANSACCIONES=0
FIX_PATH_COMISIONES=0

FIX_ARCHIVO_ARRANCAR=0
FIX_ARCHIVO_FRENAR=0
FIX_ARCHIVO_INICIAR=0
FIX_ARCHIVO_PRINCIPAL=0
FIX_ARCHIVO_COMERCIOS=0
FIX_ARCHIVO_TARJETAS=0

#Variable con nombres reservados
#Se pueden agregar los que se deseen
RESERVADOS="^(Grupo3|so7508|original|catedra|propios|testeos)$"

#Función para registrar mensajes en el log
#$1 - TIPO (INF/ALE/ERR)
#$2 - MENSAJE
#$3 - ORIGEN
log_message() {
	echo "\"$(date -R)\"-\"$1\"-\"$2\"-\"$3\"-\"$USER\"" >> "$PATH_LOG_INSTALACION"
}

#Función que chequea si el directorio ingresado es reservado o se encuentra en uso
check_dir() {

	if [[ "$1" != "" ]]
	then
		#Verificamos que comienze con '/'
		if [[ $1 != /* ]]
		then 
			MENSAJE="El nombre \""$1\"" debe comenzar con el caracter '/', intente nuevamente."
			echo $MENSAJE
			log_message "ERR" "$MENSAJE" "chequear directorios"
			return 1
		fi
		
		#Revisamos que no exista una palabra reservada
		IFS="/" read -ra DIR_PARTS <<< "$1"
		for i in "${DIR_PARTS[@]}"
		do
			if [[ "$i" =~ $RESERVADOS ]]
			then
				MENSAJE="El nombre \""$i\"" es una plabra reservada, intente nuevamente."
				echo $MENSAJE
				log_message "ERR" "$MENSAJE" "chequear directorios"
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
			MENSAJE="El nombre \""$1\"" está definido como otro de los path del sistema, intente nuevamente."
			echo $MENSAJE
			log_message "ERR" "$MENSAJE" "chequear directorios"
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
	MENSAJE="Por favor, defina los siguientes directorios: "
	echo $MENSAJE
	log_message "INF" "$MENSAJE" "definir directorios"
	MENSAJE="Definidos desde el path base \""$PATH_BASE\""".
	echo $MENSAJE
	log_message "INF" "$MENSAJE" "definir directorios"
	echo ""
	chk=1
	while true; do
		echo -n "Ejecutables [$PATH_EJECUTABLES]: "
		IFS= read -r PATH_EJECUTABLES_INPUT
		MENSAJE="Ejecutables [$PATH_EJECUTABLES]:"
		log_message "INF" "$MENSAJE" "definir directorios"
		log_message "INF" "$PATH_EJECUTABLES_INPUT" "definir directorios"
		check_dir "$PATH_EJECUTABLES_INPUT" "$PATH_EJECUTABLES" "PATH_EJECUTABLES"
		chk=$(echo $?)
		[[ $chk != 0 ]] || break
	done
	chk=1
	while true; do
		echo -n "Tablas      [$PATH_TABLAS]: "
		IFS= read -r PATH_TABLAS_INPUT
		MENSAJE="Tablas      [$PATH_TABLAS]:"
		log_message "INF" "$MENSAJE" "definir directorios"
		log_message "INF" "$PATH_TABLAS_INPUT" "definir directorios"
		check_dir "$PATH_TABLAS_INPUT" "$PATH_TABLAS" "PATH_TABLAS"
		chk=$(echo $?)
		[[ $chk != 0 ]] || break
	done
	chk=1
	while true; do
		echo -n "Novedades   [$PATH_NOVEDADES]: "
		IFS= read -r PATH_NOVEDADES_INPUT
		MENSAJE="Novedades   [$PATH_NOVEDADES]:"
		log_message "INF" "$MENSAJE" "definir directorios"
		log_message "INF" "$PATH_NOVEDADES_INPUT" "definir directorios"
		check_dir "$PATH_NOVEDADES_INPUT" "$PATH_NOVEDADES" "PATH_NOVEDADES"
		chk=$(echo $?)
		[[ $chk != 0 ]] || break
	done
	chk=1
	while true; do
		echo -n "Rechazados  [$PATH_RECHAZADAS]: "
		IFS= read -r PATH_RECHAZADAS_INPUT
		MENSAJE="Rechazados  [$PATH_RECHAZADAS]:"
		log_message "INF" "$MENSAJE" "definir directorios"
		log_message "INF" "$PATH_RECHAZADAS_INPUT" "definir directorios"
		check_dir "$PATH_RECHAZADAS_INPUT" "$PATH_RECHAZADAS" "PATH_RECHAZADAS"
		chk=$(echo $?)
		[[ $chk != 0 ]] || break
	done
	chk=1
	while true; do
		echo -n "Procesados  [$PATH_LOTES]: "
		IFS= read -r PATH_LOTES_INPUT
		MENSAJE="Procesados  [$PATH_LOTES]:"
		log_message "INF" "$MENSAJE" "definir directorios"
		log_message "INF" "$PATH_LOTES_INPUT" "definir directorios"
		check_dir "$PATH_LOTES_INPUT" "$PATH_LOTES" "PATH_LOTES"
		chk=$(echo $?)
		[[ $chk != 0 ]] || break
	done
	chk=1
	while true; do
		echo -n "Resultados  [$PATH_TRANSACCIONES]: "
		IFS= read -r PATH_TRANSACCIONES_INPUT
		MENSAJE="Resultados  [$PATH_TRANSACCIONES]:"
		log_message "INF" "$MENSAJE" "definir directorios"
		log_message "INF" "$PATH_TRANSACCIONES_INPUT" "definir directorios"
		check_dir "$PATH_TRANSACCIONES_INPUT" "$PATH_TRANSACCIONES" "PATH_TRANSACCIONES"
		chk=$(echo $?)
		[[ $chk != 0 ]] || break
	done

	ESTADO_INSTALACION="LISTA"
}

#Función que muestra un resumen del proceso
show_details() {
	
	if [[ $DEBE_REPARAR = 0 ]]
	then
		clear
		MENSAJE="TP1 - SO75.08 - 2do Cuatrimestre 2020 - Curso Martes Copyright © Grupo 3"
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
		MENSAJE="Confirmar Proceso - instalarTP"
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
	else
		echo ""
		MENSAJE="Debe reparar su instalación."
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
		MENSAJE="Se utilizarán los siguientes parámetros:"
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
	fi
	echo ""
	
	#Mostramos el mensaje por pantalla
	MENSAJE="Tipo de proceso: $TIPO_INSTALACION"
	echo $MENSAJE
	log_message "INF" "$MENSAJE" "show details"
	MENSAJE="Directorio padre: \""$PATH_BASE"\""
	echo $MENSAJE
	log_message "INF" "$MENSAJE" "show details"
	MENSAJE="Ubicación script de instalación: \""$PATH_SCRIPT_INSTALACION"\""
	echo $MENSAJE
	log_message "INF" "$MENSAJE" "show details"
	MENSAJE="Log de la instalación: \""$PATH_LOG_INSTALACION"\""
	echo $MENSAJE
	log_message "INF" "$MENSAJE" "show details"
	MENSAJE="Archivo de configuración: \""$PATH_CONFIGURACION"\""
	echo $MENSAJE
	log_message "INF" "$MENSAJE" "show details"
	MENSAJE="Log de la inicialización: \""$PATH_LOG_INICIALIZACION"\""
	echo $MENSAJE
	log_message "INF" "$MENSAJE" "show details"
	MENSAJE="Log del proceso principal: \""$PATH_LOG_PROCESO_PPAL"\""
	echo $MENSAJE
	log_message "INF" "$MENSAJE" "show details"
	if [[ $DEBE_REPARAR = 0 ]]
	then
		MENSAJE="Directorio de ejecutables: \""$PATH_BASE$PATH_EJECUTABLES"\""	
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
		MENSAJE="Directorio de tablas maestras: \""$PATH_BASE$PATH_TABLAS"\""
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
		MENSAJE="Directorio de novedades: \""$PATH_BASE$PATH_NOVEDADES"\""
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
		MENSAJE="Directorio novedades aceptadas: \""$PATH_BASE$PATH_NOVEDADES$PATH_ACEPTADAS"\""
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
		MENSAJE="Directorio de rechazados: \""$PATH_BASE$PATH_RECHAZADAS"\""
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
		MENSAJE="Directorio de lotes procesados: \""$PATH_BASE$PATH_LOTES"\""
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
		MENSAJE="Directorio de transacciones: \""$PATH_BASE$PATH_TRANSACCIONES"\""
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
		MENSAJE="Directorio de comisiones: \""$PATH_BASE$PATH_TRANSACCIONES$PATH_COMISIONES"\""
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
	else
		MENSAJE="Directorio de ejecutables: \""$PATH_EJECUTABLES"\""	
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
		MENSAJE="Directorio de tablas maestras: \""$PATH_TABLAS"\""
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
		MENSAJE="Directorio de novedades: \""$PATH_NOVEDADES"\""
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
		MENSAJE="Directorio novedades aceptadas: \""$PATH_ACEPTADAS"\""
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
		MENSAJE="Directorio de rechazados: \""$PATH_RECHAZADAS"\""
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
		MENSAJE="Directorio de lotes procesados: \""$PATH_LOTES"\""
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
		MENSAJE="Directorio de transacciones: \""$PATH_TRANSACCIONES"\""
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
		MENSAJE="Directorio de comisiones: \""$PATH_COMISIONES"\""
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "show details"
	fi
	MENSAJE="Estado de la instalación: \""$ESTADO_INSTALACION"\""
	echo $MENSAJE
	log_message "INF" "$MENSAJE" "show details"

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
		MENSAJE="¿Confirma la instalación? (SI-[NO]):"
		log_message "INF" "$MENSAJE" "nueva instalacion"
		log_message "INF" "$CONFIRMA_CLEAN" "nueva instalacion"
		if [[ $CONFIRMA_CLEAN == "SI" ]] || [[ $CONFIRMA_CLEAN == "si" ]]
		then
			chk_ci=0
		else
			echo ""
			MENSAJE="Instalación no confirmada."
			echo $MENSAJE
			log_message "INF" "$MENSAJE" "nueva instalacion"
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
		MENSAJE="Error creando directorio: $ERR_ID"
		echo $MENSAJE
		log_message "ERR" "$MENSAJE" "nueva instalacion"
		ERR_ID_FLAG=1
	fi
	ERR_ID=$(mkdir -p "$PATH_BASE$PATH_TABLAS" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		MENSAJE="Error creando directorio: $ERR_ID"
		echo $MENSAJE
		log_message "ERR" "$MENSAJE" "nueva instalacion"
		ERR_ID_FLAG=1
	fi
	ERR_ID=$(mkdir -p "$PATH_BASE$PATH_NOVEDADES" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		MENSAJE="Error creando directorio: $ERR_ID"
		echo $MENSAJE
		log_message "ERR" "$MENSAJE" "nueva instalacion"
		ERR_ID_FLAG=1
	fi
	ERR_ID=$(mkdir -p "$PATH_BASE$PATH_NOVEDADES$PATH_ACEPTADAS" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		MENSAJE="Error creando directorio: $ERR_ID"
		echo $MENSAJE
		log_message "ERR" "$MENSAJE" "nueva instalacion"
		ERR_ID_FLAG=1
	fi
	ERR_ID=$(mkdir -p "$PATH_BASE$PATH_RECHAZADAS" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		MENSAJE="Error creando directorio: $ERR_ID"
		echo $MENSAJE
		log_message "ERR" "$MENSAJE" "nueva instalacion"
		ERR_ID_FLAG=1
	fi
	ERR_ID=$(mkdir -p "$PATH_BASE$PATH_LOTES" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		MENSAJE="Error creando directorio: $ERR_ID"
		echo $MENSAJE
		log_message "ERR" "$MENSAJE" "nueva instalacion"
		ERR_ID_FLAG=1
	fi
	ERR_ID=$(mkdir -p "$PATH_BASE$PATH_TRANSACCIONES" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		MENSAJE="Error creando directorio: $ERR_ID"
		echo $MENSAJE
		log_message "ERR" "$MENSAJE" "nueva instalacion"
		ERR_ID_FLAG=1
	fi
	ERR_ID=$(mkdir -p "$PATH_BASE$PATH_TRANSACCIONES$PATH_COMISIONES" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		MENSAJE="Error creando directorio: $ERR_ID"
		echo $MENSAJE
		log_message "ERR" "$MENSAJE" "nueva instalacion"
		ERR_ID_FLAG=1
	fi
	#Copia de los archivos
	ERR_IC_FLAG=0
	ERR_IC=$(cp "$PATH_BASE/original/arrancarproceso.sh" "$PATH_BASE$PATH_EJECUTABLES" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		MENSAJE="Error copiando archivos: $ERR_IC"
		echo $MENSAJE
		log_message "ERR" "$MENSAJE" "nueva instalacion"
		ERR_IC_FLAG=1
	fi
	ERR_IC=$(cp "$PATH_BASE/original/frenarproceso.sh" "$PATH_BASE$PATH_EJECUTABLES" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		MENSAJE="Error copiando archivos: $ERR_IC"
		echo $MENSAJE
		log_message "ERR" "$MENSAJE" "nueva instalacion"
		ERR_IC_FLAG=1
	fi
	ERR_IC=$(cp "$PATH_BASE/original/iniciarambiente.sh" "$PATH_BASE$PATH_EJECUTABLES" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		MENSAJE="Error copiando archivos: $ERR_IC"
		echo $MENSAJE
		log_message "ERR" "$MENSAJE" "nueva instalacion"
		ERR_IC_FLAG=1
	fi
	ERR_IC=$(cp "$PATH_BASE/original/pprincipal.sh" "$PATH_BASE$PATH_EJECUTABLES" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		MENSAJE="Error copiando archivos: $ERR_IC"
		echo $MENSAJE
		log_message "ERR" "$MENSAJE" "nueva instalacion"
		ERR_IC_FLAG=1
	fi
	ERR_IC=$(cp "$PATH_BASE/original/comercios.txt" "$PATH_BASE$PATH_TABLAS" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		MENSAJE="Error copiando archivos: $ERR_IC"
		echo $MENSAJE
		log_message "ERR" "$MENSAJE" "nueva instalacion"
		ERR_IC_FLAG=1
	fi
	ERR_IC=$(cp "$PATH_BASE/original/tarjetashomologadas.txt" "$PATH_BASE$PATH_TABLAS" 2>&1 >/dev/null)
	if [[ $? != 0 ]]
	then
		MENSAJE="Error copiando archivos: $ERR_IC"
		echo $MENSAJE
		log_message "ERR" "$MENSAJE" "nueva instalacion"
		ERR_IC_FLAG=1
	fi

	if [[ $ERR_ID_FLAG != 0 ]] || [[ $ERR_IC_FLAG != 0 ]]
	then
		ESTADO_INSTALACION="ABORTADA"
		echo ""
		MENSAJE="Error de instalación!"
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "nueva instalacion"
		MENSAJE="Estado de la instalación: $ESTADO_INSTALACION. Utilice \"limpiarTP.sh\" para revertir el proceso."
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "nueva instalacion"
		echo ""
		MENSAJE="Fin - instalarTP (1)"
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "nueva instalacion"
		exit 1
	else
		#Escritura de archivo de configuración
		echo "GRUPO-\"$PATH_BASE\"" > "$PATH_CONFIGURACION"
		echo "DIRINST-\"$PATH_SCRIPT_INSTALACION\"" >> "$PATH_CONFIGURACION"
		echo "DIRBIN-\"$PATH_BASE$PATH_EJECUTABLES\"" >> "$PATH_CONFIGURACION"
		echo "DIRMAE-\"$PATH_BASE$PATH_TABLAS\"" >> "$PATH_CONFIGURACION"
		echo "DIRIN-\"$PATH_BASE$PATH_NOVEDADES\"" >> "$PATH_CONFIGURACION"
		echo "DIRRECH-\"$PATH_BASE$PATH_RECHAZADAS\"" >> "$PATH_CONFIGURACION"
		echo "DIRPROC-\"$PATH_BASE$PATH_LOTES\"" >> "$PATH_CONFIGURACION"
		echo "DIROUT-\"$PATH_BASE$PATH_TRANSACCIONES\"" >> "$PATH_CONFIGURACION"
		echo "INTSTALACION-\"$(date -R)\"-$USER" >> "$PATH_CONFIGURACION"
	
		#Instalación finalizada
		ESTADO_INSTALACION="COMPLETADA"
		MENSAJE="Estado de la instalación: $ESTADO_INSTALACION"
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "nueva instalacion"
	fi
}

#Funcion para reparación
repair_install() {

	#Resumen de parámetros de la reparación
	TIPO_INSTALACION="REPARACION"
	ESTADO_INSTALACION="LISTA"
	show_details
	#Pedimos al usuario confirmación
	echo ""
	echo -n "¿Confirma la reparación? (SI-[NO]): "
	IFS= read -r CONFIRMA_REPAIR
	MENSAJE="¿Confirma la reparación? (SI-[NO]):"
	log_message "INF" "$MENSAJE" "reparar instalacion"
	log_message "INF" "$CONFIRMA_REPAIR" "reparar instalacion"
	if [[ $CONFIRMA_REPAIR == "SI" ]] || [[ $CONFIRMA_REPAIR == "si" ]]
	then
		#Reparación de directorios
		ERR_RD_FLAG=0
		if [[ $FIX_PATH_EJECUTABLES = 1 ]]
		then
			ERR_RD=$(mkdir -p "$PATH_EJECUTABLES" 2>&1 >/dev/null)
			if [[ $? != 0 ]]
			then
				MENSAJE="Error creando directorio: $ERR_RD"
				echo $MENSAJE
				log_message "ERR" "$MENSAJE" "reparar instalacion"
				ERR_RD_FLAG=1
			fi
		fi
		if [[ $FIX_PATH_TABLAS = 1 ]]
		then
			ERR_RD=$(mkdir -p "$PATH_TABLAS" 2>&1 >/dev/null)
			if [[ $? != 0 ]]
			then
				MENSAJE="Error creando directorio: $ERR_RD"
				echo $MENSAJE
				log_message "ERR" "$MENSAJE" "reparar instalacion"
				ERR_RD_FLAG=1
			fi
		fi
		if [[ $FIX_PATH_NOVEDADES = 1 ]]
		then
			ERR_RD=$(mkdir -p "$PATH_NOVEDADES" 2>&1 >/dev/null)
			if [[ $? != 0 ]]
			then
				MENSAJE="Error creando directorio: $ERR_RD"
				echo $MENSAJE
				log_message "ERR" "$MENSAJE" "reparar instalacion"
				ERR_RD_FLAG=1
			fi
		fi
		if [[ $FIX_PATH_ACEPTADAS = 1 ]]
		then
			ERR_RD=$(mkdir -p "$PATH_ACEPTADAS" 2>&1 >/dev/null)
			if [[ $? != 0 ]]
			then
				MENSAJE="Error creando directorio: $ERR_RD"
				echo $MENSAJE
				log_message "ERR" "$MENSAJE" "reparar instalacion"
				ERR_RD_FLAG=1
			fi
		fi
		if [[ $FIX_PATH_RECHAZADAS = 1 ]]
		then
			ERR_RD=$(mkdir -p "$PATH_RECHAZADAS" 2>&1 >/dev/null)
			if [[ $? != 0 ]]
			then
				MENSAJE="Error creando directorio: $ERR_RD"
				echo $MENSAJE
				log_message "ERR" "$MENSAJE" "reparar instalacion"
				ERR_RD_FLAG=1
			fi
		fi
		if [[ $FIX_PATH_LOTES = 1 ]]
		then
			ERR_RD=$(mkdir -p "$PATH_LOTES" 2>&1 >/dev/null)
			if [[ $? != 0 ]]
			then
				MENSAJE="Error creando directorio: $ERR_RD"
				echo $MENSAJE
				log_message "ERR" "$MENSAJE" "reparar instalacion"
				ERR_RD_FLAG=1
			fi
		fi
		if [[ $FIX_PATH_TRANSACCIONES = 1 ]]
		then
			ERR_RD=$(mkdir -p "$PATH_TRANSACCIONES" 2>&1 >/dev/null)
			if [[ $? != 0 ]]
			then
				MENSAJE="Error creando directorio: $ERR_RD"
				echo $MENSAJE
				log_message "ERR" "$MENSAJE" "reparar instalacion"
				ERR_RD_FLAG=1
			fi
		fi
		if [[ $FIX_PATH_COMISIONES = 1 ]]
		then
			ERR_RD=$(mkdir -p "$PATH_COMISIONES" 2>&1 >/dev/null)
			if [[ $? != 0 ]]
			then
				MENSAJE="Error creando directorio: $ERR_RD"
				echo $MENSAJE
				log_message "ERR" "$MENSAJE" "reparar instalacion"
				ERR_RD_FLAG=1
			fi
		fi
		#Reparación de archivos
		ERR_RF_FLAG=0
		if [[ $FIX_ARCHIVO_ARRANCAR = 1 ]]
		then
			ERR_RF=$(cp "$PATH_BASE/original/arrancarproceso.sh" "$PATH_EJECUTABLES" 2>&1 >/dev/null)
			if [[ $? != 0 ]]
			then
				MENSAJE="Error copiando archivos: $ERR_RF"
				echo $MENSAJE
				log_message "ERR" "$MENSAJE" "reparar instalacion"
				ERR_RF_FLAG=1
			fi
		fi
		if [[ $FIX_ARCHIVO_FRENAR = 1 ]]
		then
			ERR_RF=$(cp "$PATH_BASE/original/frenarproceso.sh" "$PATH_EJECUTABLES" 2>&1 >/dev/null)
			if [[ $? != 0 ]]
			then
				MENSAJE="Error copiando archivos: $ERR_RF"
				echo $MENSAJE
				log_message "ERR" "$MENSAJE" "reparar instalacion"
				ERR_RF_FLAG=1
			fi
		fi
		if [[ $FIX_ARCHIVO_INICIAR = 1 ]]
		then
			ERR_RF=$(cp "$PATH_BASE/original/iniciarambiente.sh" "$PATH_EJECUTABLES" 2>&1 >/dev/null)
			if [[ $? != 0 ]]
			then
				MENSAJE="Error copiando archivos: $ERR_RF"
				echo $MENSAJE
				log_message "ERR" "$MENSAJE" "reparar instalacion"
				ERR_RF_FLAG=1
			fi
		fi
		if [[ $FIX_ARCHIVO_PRINCIPAL = 1 ]]
		then
			ERR_RF=$(cp "$PATH_BASE/original/pprincipal.sh" "$PATH_EJECUTABLES" 2>&1 >/dev/null)
			if [[ $? != 0 ]]
			then
				MENSAJE="Error copiando archivos: $ERR_RF"
				echo $MENSAJE
				log_message "ERR" "$MENSAJE" "reparar instalacion"
				ERR_RF_FLAG=1
			fi
		fi
		if [[ $FIX_ARCHIVO_COMERCIOS = 1 ]]
		then
			ERR_RF=$(cp "$PATH_BASE/original/comercios.txt" "$PATH_TABLAS" 2>&1 >/dev/null)
			if [[ $? != 0 ]]
			then
				MENSAJE="Error copiando archivos: $ERR_RF"
				echo $MENSAJE
				log_message "ERR" "$MENSAJE" "reparar instalacion"
				ERR_RF_FLAG=1
			fi
		fi
		if [[ $FIX_ARCHIVO_TARJETAS = 1 ]]
		then
			ERR_RF=$(cp "$PATH_BASE/original/tarjetashomologadas.txt" "$PATH_TABLAS" 2>&1 >/dev/null)
			if [[ $? != 0 ]]
			then
				MENSAJE="Error copiando archivos: $ERR_RF"
				echo $MENSAJE
				log_message "ERR" "$MENSAJE" "reparar instalacion"
				ERR_RF_FLAG=1
			fi
		fi
		
		if [[ $ERR_RD_FLAG != 0 ]] || [[ $ERR_RF_FLAG != 0 ]]
		then
			ESTADO_INSTALACION="ABORTADA"
			echo ""
			MENSAJE="Error de reparación!"
			echo $MENSAJE
			log_message "INF" "$MENSAJE" "reparar instalacion"
			MENSAJE="Estado de la reparación: $ESTADO_INSTALACION. Utilice \"limpiarTP.sh\" para revertir el proceso."
			echo $MENSAJE
			log_message "INF" "$MENSAJE" "reparar instalacion"
			echo ""
			MENSAJE="Fin - instalarTP (1)"
			echo $MENSAJE
			log_message "INF" "$MENSAJE" "reparar instalacion"
			exit 1
		else
			#Agregamos al archivo de configuración el registro de reparación
			echo "REPARACION-\"$(date -R)\"-$USER" >> "$PATH_CONFIGURACION"
	
			#Reparación finalizada
			ESTADO_INSTALACION="REPARADA"
			MENSAJE="Estado de la instalación: $ESTADO_INSTALACION"
			echo $MENSAJE
			log_message "INF" "$MENSAJE" "reparar instalacion"
		fi
	else
		ESTADO_INSTALACION="CANCELADA"
		echo ""
		MENSAJE="Reparación cancelada."
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "reparar instalacion"
		MENSAJE="Estado de la reparación: $ESTADO_INSTALACION"
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "reparar instalacion"
		echo ""
		MENSAJE="Fin - instalarTP (1)"
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "reparar instalacion"
		exit 1
	fi
} 

#Funcion para chequeo
check_install() {
	
	echo ""
	MENSAJE="Comprobando instalación..."
	echo $MENSAJE
	log_message "INF" "$MENSAJE" "chequear instalacion"
	
	#Lectura del archivo de configuración
	while IFS= read -r LINEA
	do
		CONFIG="$(echo "$LINEA" | cut -d- -f1)"
		if [[ $CONFIG == "GRUPO" ]]
		then
			PATH_BASE="$(echo "$LINEA" | cut -d- -f2)"
			PATH_BASE="${PATH_BASE//\"}"
		fi
		if [[ $CONFIG == "DIRINST" ]]
		then
			PATH_SCRIPT_INSTALACION="$(echo "$LINEA" | cut -d- -f2)"
			PATH_SCRIPT_INSTALACION="${PATH_SCRIPT_INSTALACION//\"}"
		fi
		if [[ $CONFIG == "DIRBIN" ]]
		then
			PATH_EJECUTABLES="$(echo "$LINEA" | cut -d- -f2)"
			PATH_EJECUTABLES="${PATH_EJECUTABLES//\"}"
		fi
		if [[ $CONFIG == "DIRMAE" ]]
		then
			PATH_TABLAS="$(echo "$LINEA" | cut -d- -f2)"
			PATH_TABLAS="${PATH_TABLAS//\"}"
		fi
		if [[ $CONFIG == "DIRIN" ]]
		then
			PATH_NOVEDADES="$(echo "$LINEA" | cut -d- -f2)"
			PATH_NOVEDADES="${PATH_NOVEDADES//\"}"
		fi
		if [[ $CONFIG == "DIRRECH" ]]
		then
			PATH_RECHAZADAS="$(echo "$LINEA" | cut -d- -f2)"
			PATH_RECHAZADAS="${PATH_RECHAZADAS//\"}"
		fi
		if [[ $CONFIG == "DIRPROC" ]]
		then
			PATH_LOTES="$(echo "$LINEA" | cut -d- -f2)"
			PATH_LOTES="${PATH_LOTES//\"}"
		fi
		if [[ $CONFIG == "DIROUT" ]]
		then
			PATH_TRANSACCIONES="$(echo "$LINEA" | cut -d- -f2)"
			PATH_TRANSACCIONES="${PATH_TRANSACCIONES//\"}"
		fi
	done < "$PATH_CONFIGURACION"

	#Reconstrucción de paths compuestos a verificar
	PATH_ACEPTADAS="$PATH_NOVEDADES$PATH_ACEPTADAS"
	PATH_COMISIONES="$PATH_TRANSACCIONES$PATH_COMISIONES"

	DEBE_REPARAR=0
	#Verificación de directorios
	if [[ ! -d "$PATH_EJECUTABLES" ]]
	then
		MENSAJE="No se encontró el directorio: \"$PATH_EJECUTABLES\""
		echo $MENSAJE
		log_message "ALE" "$MENSAJE" "chequear instalacion"
		FIX_PATH_EJECUTABLES=1
		DEBE_REPARAR=1
	fi
	if [[ ! -d "$PATH_TABLAS" ]]
	then
		MENSAJE="No se encontró el directorio: \"$PATH_TABLAS\""
		echo $MENSAJE
		log_message "ALE" "$MENSAJE" "chequear instalacion"
		FIX_PATH_TABLAS=1
		DEBE_REPARAR=1
	fi
	if [[ ! -d "$PATH_NOVEDADES" ]]
	then
		MENSAJE="No se encontró el directorio: \"$PATH_NOVEDADES\""
		echo $MENSAJE
		log_message "ALE" "$MENSAJE" "chequear instalacion"
		FIX_PATH_NOVEDADES=1
		DEBE_REPARAR=1
	fi
	if [[ ! -d "$PATH_ACEPTADAS" ]]
	then
		MENSAJE="No se encontró el directorio: \"$PATH_ACEPTADAS\""
		echo $MENSAJE
		log_message "ALE" "$MENSAJE" "chequear instalacion"
		FIX_PATH_ACEPTADAS=1
		DEBE_REPARAR=1
	fi
	if [[ ! -d "$PATH_RECHAZADAS" ]]
	then
		MENSAJE="No se encontró el directorio: \"$PATH_RECHAZADAS\""
		echo $MENSAJE
		log_message "ALE" "$MENSAJE" "chequear instalacion"
		FIX_PATH_RECHAZADAS=1
		DEBE_REPARAR=1
	fi
	if [[ ! -d "$PATH_LOTES" ]]
	then
		MENSAJE="No se encontró el directorio: \"$PATH_LOTES\""
		echo $MENSAJE
		log_message "ALE" "$MENSAJE" "chequear instalacion"
		FIX_PATH_LOTES=1
		DEBE_REPARAR=1
	fi
	if [[ ! -d "$PATH_TRANSACCIONES" ]]
	then
		MENSAJE="No se encontró el directorio: \"$PATH_TRANSACCIONES\""
		echo $MENSAJE
		log_message "ALE" "$MENSAJE" "chequear instalacion"
		FIX_PATH_TRANSACCIONES=1
		DEBE_REPARAR=1
	fi
	if [[ ! -d "$PATH_COMISIONES" ]]
	then
		MENSAJE="No se encontró el directorio: \"$PATH_COMISIONES\""
		echo $MENSAJE
		log_message "ALE" "$MENSAJE" "chequear instalacion"
		FIX_PATH_COMISIONES=1
		DEBE_REPARAR=1
	fi
	#Verificación de archivos
	if [[ ! -f "$PATH_EJECUTABLES/arrancarproceso.sh" ]]
	then
		MENSAJE="No se encontró el archivo: \"$PATH_EJECUTABLES/arrancarproceso.sh\""
		echo $MENSAJE
		log_message "ALE" "$MENSAJE" "chequear instalacion"
		FIX_ARCHIVO_ARRANCAR=1
		DEBE_REPARAR=1
	fi
	if [[ ! -f "$PATH_EJECUTABLES/frenarproceso.sh" ]]
	then
		MENSAJE="No se encontró el archivo: \"$PATH_EJECUTABLES/frenarproceso.sh\""
		echo $MENSAJE
		log_message "ALE" "$MENSAJE" "chequear instalacion"
		FIX_ARCHIVO_FRENAR=1
		DEBE_REPARAR=1
	fi
	if [[ ! -f "$PATH_EJECUTABLES/iniciarambiente.sh" ]]
	then
		MENSAJE="No se encontró el archivo: \"$PATH_EJECUTABLES/iniciarambiente.sh\""
		echo $MENSAJE
		log_message "ALE" "$MENSAJE" "chequear instalacion"
		FIX_ARCHIVO_INICIAR=1
		DEBE_REPARAR=1
	fi
	if [[ ! -f "$PATH_EJECUTABLES/pprincipal.sh" ]]
	then
		MENSAJE="No se encontró el archivo: \"$PATH_EJECUTABLES/pprincipal.sh\""
		echo $MENSAJE
		log_message "ALE" "$MENSAJE" "chequear instalacion"
		FIX_ARCHIVO_PRINCIPAL=1
		DEBE_REPARAR=1
	fi
	if [[ ! -f "$PATH_TABLAS/comercios.txt" ]]
	then
		MENSAJE="No se encontró el archivo: \"$PATH_TABLAS/comercios.txt\""
		echo $MENSAJE
		log_message "ALE" "$MENSAJE" "chequear instalacion"
		FIX_ARCHIVO_COMERCIOS=1
		DEBE_REPARAR=1
	fi
	if [[ ! -f "$PATH_TABLAS/tarjetashomologadas.txt" ]]
	then
		MENSAJE="No se encontró el archivo: \"$PATH_TABLAS/tarjetashomologadas.txt\""
		echo $MENSAJE
		log_message "ALE" "$MENSAJE" "chequear instalacion"
		FIX_ARCHIVO_TARJETAS=1
		DEBE_REPARAR=1
	fi

	#Vemos si se debe reparar o no la instalación
	if [[ $DEBE_REPARAR = 1 ]]
	then
		#Llamamos a la funcion que reparará la instalación
		repair_install
	else
		#La instalación es correcta!
		echo ""
		MENSAJE="Instalación verificada correctamente."
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "chequear instalacion"
		#Instalación finalizada
		ESTADO_INSTALACION="CHEQUEADA"
		MENSAJE="Estado de la instalación: $ESTADO_INSTALACION"
		echo $MENSAJE
		log_message "INF" "$MENSAJE" "chequear instalacion"
	fi
} 

#FLUJO PRINCIPAL
#Limpiamos la pantalla antes de comenzar
clear

#Mensaje y log de inicio
MENSAJE="TP1 - SO75.08 - 2do Cuatrimestre 2020 - Curso Martes Copyright © Grupo 3"
echo "$MENSAJE"
log_message "INF" "$MENSAJE" "instalarTP"
MENSAJE="Inicio - instalarTP"
echo "$MENSAJE"
log_message "INF" "$MENSAJE" "instalarTP"
echo ""

#Validacion de existencia del archivo de configuración
if [[ ! -f "$PATH_CONFIGURACION" ]]
then
	MENSAJE="El archivo \""$PATH_CONFIGURACION\"" no existe."
	echo "$MENSAJE"
	log_message "INF" "$MENSAJE" "instalarTP"
	MENSAJE="Tipo de ejecución: INSTALACIÓN."
	echo "$MENSAJE"
	log_message "INF" "$MENSAJE" "instalarTP"
	TIPO_INSTALACION="INSTALACION"
else	
	MENSAJE="El archivo \""$PATH_CONFIGURACION\"" fue encontrado."
	echo "$MENSAJE"
	log_message "INF" "$MENSAJE" "instalarTP"
	MENSAJE="Tipo de ejecución: CHEQUEO."
	echo "$MENSAJE"
	log_message "INF" "$MENSAJE" "instalarTP"
	TIPO_INSTALACION="CHEQUEO"
fi

#Llamada a las operaciones de instalacion y reparacion
if [[ $TIPO_INSTALACION = "INSTALACION" ]]
then
	clean_install
else
	if [[ $TIPO_INSTALACION = "CHEQUEO" ]]
	then
		check_install
	else
		MENSAJE="Fin - instalarTP (1). Operación inválida."
		echo "$MENSAJE"
		log_message "INF" "$MENSAJE" "instalarTP"
		exit 1
	fi
fi

#Mensaje y log de fin de ejecución
echo ""
MENSAJE="Fin - instalarTP (0)"
echo "$MENSAJE"
log_message "INF" "$MENSAJE" "instalarTP"

#Retorno al shell con código de éxito
exit 0
