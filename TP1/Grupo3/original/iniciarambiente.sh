#!/bin/bash
#
#75.08 - 2C 2020 - GRUPO 3
#
#79979 - GONZALEZ, JUAN MANUEL (juagonzalez@fi.uba.ar)
#85881 - SILVESTRI, ANDRES (asilvestri@fi.uba.ar)
#91076 - PORRAS CARHUAMACA, SHERLY KATERIN (sporras@fi.uba.ar)
#97524 - PIZZINI, PATRICIO (ppizzini@fi.uba.ar)
#
#TP1 - iniciarambiente

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
CODIGOS="GRUPO;DIRINST;DIRBIN;DIRMAE;DIRIN;DIRRECH;DIRPROC;DIROUT;INSTALACION"
ARCHIVOS="archivo1.txt;archivo2.txt;archivo3.txt"
IDENTIFICADOR_ERRONEO=""
PATH_ERRONEO=""

#Funcion para registrar mensajes en el log
log_message() {
	echo "$(date -R): $1" >> "$PATH_LOG_INICIALIZACION"
}

validar_identificador(){
    CODIGO_DEFINIDO=$(echo $CODIGOS | sed 's-\(.*\);\(.*\);\(.*\);\(.*\);\(.*\);\(.*\);\(.*\);\(.*\);\(.*\)-\'"$3"'-g')
    if [ "$1" == "$CODIGO_DEFINIDO" ]
    then
        validar_directorio "$1" "$2"
    else
        IDENTIFICADOR_ERRONEO="$CODIGO_DEFINIDO"
    fi
}

validar_directorio(){
    if [ ! -d "$2" ]; 
    then
        MENSAJE="El directorio \""$2\"" no existe, correspondiente al código: \""$1\""."
        echo "$MENSAJE"
        log_message "$MENSAJE"
        PATH_ERRONEO="$1"
    else	
        MENSAJE="El directorio \""$2\"" fue encontrado, correspondiente al código: \""$1\""."
        echo "$MENSAJE"
        log_message "$MENSAJE"
    fi
}

#Leer el archivo instalarTP.conf y verificar que todos esos directorios existen
# | Verificar directorios |
validar_configuracion() {
    let CANTIDAD=1
    while read -r LINEA
    do
        IDENTIFICADOR=$(echo $LINEA | cut -f1 -d-)
        VALOR=$(echo $LINEA | cut -f2 -d-)
        MENSAJE="El identificador: \""$IDENTIFICADOR\"" tiene el siguiente valor: \""$VALOR\""."
        log_message "$MENSAJE"

        PATH_ERRONEO=""
        IDENTIFICADOR_ERRONEO=""
        #El noveno registro tiene un tratamiento especial.
        if [ "$CANTIDAD" -lt 10 ]
        then
            validar_identificador "$IDENTIFICADOR" "$VALOR" "$CANTIDAD"
            if [ "$IDENTIFICADOR_ERRONEO" != "" ]
            then
                MENSAJE="En la posición: \""$CANTIDAD\"" del archivo instalarTP.conf está mal especificado el código: \""$IDENTIFICADOR_ERRONEO\""." 
                echo "$MENSAJE"
                log_message "$MENSAJE"
                MENSAJE="Por favor vuelva a ejecutar instalarTP con la opción reparar." 
                echo "$MENSAJE"
                log_message "$MENSAJE"
                break
            fi
            if [ "$PATH_ERRONEO" != "" ]
            then
                MENSAJE="En la posición: \""$CANTIDAD\"" del archivo instalarTP.conf está mal especificado el directorio para el código: \""$PATH_ERRONEO\""."
                echo "$MENSAJE"
                log_message "$MENSAJE"
                MENSAJE="Por favor vuelva a ejecutar instalarTP con la opción reparar." 
                echo "$MENSAJE"
                log_message "$MENSAJE"
                break
            fi
            let CANTIDAD="$CANTIDAD"+1
        else
            MENSAJE="El identificador: \""$IDENTIFICADOR\"" NO tiene uso alguno dentro del sistema, será omitido."
            echo "$MENSAJE"
            log_message "$MENSAJE"
        fi
    done < "$PATH_CONFIGURACION"
}

#Los archivos del directorio de tablas maestras deben tener permiso de lectura
#Los archivos del directorio de ejecutables deben tener permiso de ejecución
# | Verificar permisos |
validar_permisos() {
    DIRECTORIO_TEMPORAL="/home/andres/Documents/SISTEMAS OPERATIVOS/TEST/"
    chmod -R u=r,g=r,o=r "$DIRECTORIO_TEMPORAL"
    #chmod -R u=rwx,g=rwx,o=rwx "$PATH_EJECUTABLES"
    echo "listo"
}

#Ir al directorio de tablas maestras y verificar que existan
# | Verificar archivos |
validar_archivos() {
    DIRECTORIO_TEMPORAL="/home/andres/Documents/SISTEMAS OPERATIVOS/TEST/"
    ARCHIVOS=${ARCHIVOS//;/$'\n'}  # change the semicolons to white space
    for word in $ARCHIVOS
    do
        CONCATENADO="${DIRECTORIO_TEMPORAL}${word}"
        if [ ! -f "$CONCATENADO" ]; 
        then
            MENSAJE="Falta el archivo del directorio de tablas maestras:  \""$CONCATENADO\""."
            echo "$MENSAJE"
            log_message "$MENSAJE"
            MENSAJE="Por favor vuelva a ejecutar instalarTP con la opción reparar."
            echo "$MENSAJE"
            log_message "$MENSAJE"
        else	
            MENSAJE="Se encontró el archivo del directorio de tablas maestras:  \""$CONCATENADO\""."
            echo "$MENSAJE"
            log_message "$MENSAJE"
        fi
    done
}


#Todos los identificadores del archivo de configuración deben convertirse en variables de ambiente
# | Variables de ambiente |
variables_ambiente() {
    echo "validar_ambiente"
}

#Invocar al script pprincipal ADVERTENCIA: no invocar el proceso si ya hay uno corriendo. Avisar cuando pasa eso
# | Arrancar el proceso |
arrancar_proceso() {
    echo "arrancar_proceso"
}

#Invocar al script pprincipal ADVERTENCIA: no invocar el proceso si ya hay uno corriendo. Avisar cuando pasa eso
# | Informar process id, como detener y arrancar el proceso |
informar_resultados() {
    MENSAJE="process id que le asigno el sistema operativo."
    echo "$MENSAJE"
    log_message "$MENSAJE"
    MENSAJE="si se quiere detener el proceso se debe usar frenarproceso."
    echo "$MENSAJE"
    log_message "$MENSAJE"
    MENSAJE="si luego se quiere arrancar hay que hacerlo con arrancarproceso."
    echo "$MENSAJE"
    log_message "$MENSAJE"
}

#Limpiamos la pantalla
clear

#Mensaje y log de inicio
echo 'TP1 - SO75.08 - 2do Cuatrimestre 2020 - Curso Martes Copyright © Grupo 3'
MENSAJE="Inicio - iniciarambiente"
echo "$MENSAJE"
log_message "$MENSAJE"
echo ""

#Validacion de existencia del archivo de configuración
# | Verificar configuración |
if [ ! -f "$PATH_CONFIGURACION" ]; then
	MENSAJE="El archivo \""$PATH_CONFIGURACION\"" no existe."
	echo "$MENSAJE"
	log_message "$MENSAJE"
	MENSAJE="Por favor vuelva a ejecutar instalarTP con la opción reparar."
	echo "$MENSAJE"
	log_message "$MENSAJE"
else	
	MENSAJE="El archivo \""$PATH_CONFIGURACION\"" fue encontrado."
	echo "$MENSAJE"
	log_message "$MENSAJE"
	MENSAJE="Procedemos a revisar los directorios."
	echo "$MENSAJE"
	log_message "$MENSAJE"
    ##Validamos configuracion y directorios.
    validar_configuracion
    ##Validamos archivos.
    validar_archivos
    ##Validamos permisos.
    validar_permisos
    ##Variables de ambiente
    variables_ambiente
    ##Arrancar el proceso
    arrancar_proceso
    ##Informar process id, como detener y arrancar el proceso
    informar_resultados
fi

exit 0
