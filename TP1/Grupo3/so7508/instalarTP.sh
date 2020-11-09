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
PATH_EJECUTABLES="$PATH_BASE/bin"
PATH_TABLAS="$PATH_BASE/master"
PATH_NOVEDADES="$PATH_BASE/input"
PATH_ACEPTADAS="$PATH_BASE/input/ok"
PATH_RECHAZADAS="$PATH_BASE/rechazos"
PATH_LOTES="$PATH_BASE/lotes"
PATH_TRANSACCIONES="$PATH_BASE/output"
PATH_COMISIONES="$PATH_BASE/output/comisiones"

#Variables con ubicacion de archivos
PATH_SCRIPT_INSTALACION="$PATH_BASE/so7508/instalarTP.sh"
PATH_LOG_INSTALACION="$PATH_BASE/so7508/instalarTP.log"
PATH_CONFIGURACION="$PATH_BASE/so7508/instalarTP.conf"
PATH_LOG_INICIALIZACION="$PATH_BASE/so7508/inicarambiente.log"
PATH_LOG_PROCESO_PPAL="$PATH_BASE/so7508/pprincipal.log"

#Variable para los strings que van a stdout y al log
MENSAJE=""

#Funcion para registrar mensajes en el log
log_message() {
	echo "$(date -R): $1" >> "$PATH_LOG_INSTALACION"
}

#Funcion para intalación
clean_install() {

	echo "FUNCION PARA INSTALAR DE 0"
	return 0
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

show_details() {
	
	MENSAJE="Mostrando detalles de instalación."
	log_message "$MENSAJE"

	#Mostramos el mensaje por pantalla
	echo "Directorio padre: \""$PATH_BASE"\""
	echo "Ubicación script de instalación: \""$PATH_SCRIPT_INSTALACION"\""
	echo "Log de la instalación: \""$PATH_LOG_INSTALACION"\""
	echo "Archivo de configuración: \""$PATH_CONFIGURACION"\""
	echo "Log de la inicialización: \""$PATH_LOG_INICIALIZACION"\""
	echo "Log del proceso principal: \""$PATH_LOG_PROCESO_PPAL"\""
	echo "Directorio de ejecutables: \""$PATH_EJECUTABLES"\""
	echo "Directorio de tablas maestras: \""$PATH_TABLAS"\""
	echo "Directorio de novedades: \""$PATH_NOVEDADES"\""
	echo "Directorio novedades aceptadas: \""$PATH_ACEPTADAS"\""
	echo "Directorio de rechazados: \""$PATH_RECHAZADAS"\""
	echo "Directorio de lotes procesados: \""$PATH_LOTES"\""
	echo "Directorio de transacciones: \""$PATH_TRANSACCIONES"\""
	echo "Directorio de comisiones: \""$PATH_COMISIONES"\""
	echo "Estado de la instalación: \""$ESTADO_INSTALACION"\""

	return 0
}

#Función para confirmación
confirm_operation() {

	#Leemos la respuesta del usuario
	read respuesta

	return $respuesta
}

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
	
	MENSAJE="El archivo \""$PATH_CONFIGURACION\"" no existe. Tipo de ejecución: INSTALACIÓN."
	echo "$MENSAJE"
	log_message "$MENSAJE"
	TIPO_INSTALACION="INSTALACION"
else	
	MENSAJE="El archivo \""$PATH_CONFIGURACION\"" fue encontrado. Tipo de ejecución: CHEQUEO."
	echo "$MENSAJE"
	log_message "$MENSAJE"
	TIPO_INSTALACION="CHQUEO"
fi

#Llamada a las operaciones de instalacion y reparacion
if [ $TIPO_INSTALACION = "INSTALACION" ]; then
	clean_install
else
	if [ $TIPO_INSTALACION = "CHEQUEO" ]; then
		check_install
	else
		MENSAJE="Fin - instalarTP (1). Operación inválida."
		echo ""
		echo "$MENSAJE"
		log_message "$MENSAJE"
		exit 1
	fi
fi

#Mostramos los detalles de la instación
#********* VER DONDE VA ESTO! *********
echo ""
show_details

#Mensaje y log de fin de ejecución
MENSAJE="Fin - instalarTP (0)"
echo ""
echo "$MENSAJE"
log_message "$MENSAJE"

#Retorno al shell con código de éxito
exit 0
