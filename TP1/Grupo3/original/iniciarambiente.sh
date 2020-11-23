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
PATH_LOG_INICIALIZACION="$PATH_BASE/so7508/iniciarambiente.log"
PATH_LOG_PROCESO_PPAL="$PATH_BASE/so7508/pprincipal.log"

#Variable para los strings que van a stdout y al log
MENSAJE=""
CODIGOS="GRUPO;DIRINST;DIRBIN;DIRMAE;DIRIN;DIRRECH;DIRPROC;DIROUT;INSTALACION"
ARCHIVOS="/comercios.txt-/tarjetashomologadas.txt"
IDENTIFICADOR_ERRONEO=""
PATH_ERRONEO=""

#Variables de control de flujo
ERRORLVL_CONFIG=1
ERRORLVL_FILES=1

#Función para registrar mensajes en el log
#$1 - TIPO (INF/ALE/ERR)
#$2 - MENSAJE
#$3 - ORIGEN
log_message() {
	echo "\"$(date -R)\"-\"$1\"-\"$2\"-\"$3\"-\"$USER\"" >> "$PATH_LOG_INICIALIZACION"
}

validar_identificador(){
	
    CODIGO_DEFINIDO=$(echo $CODIGOS | sed 's-\(.*\);\(.*\);\(.*\);\(.*\);\(.*\);\(.*\);\(.*\);\(.*\);\(.*\)-\'"$3"'-g')

    if [[ "$1" == "$CODIGO_DEFINIDO" ]]
    then
        validar_directorio "$1" "$2"
    else
        IDENTIFICADOR_ERRONEO="$CODIGO_DEFINIDO"
    fi
}

limpiar_variables(){
    #Si falla cualquiera limpiamos todas las variables de entorno/ambiente.
    export GRUPO=""
    export DIRINST=""
    export DIRBIN=""
    export DIRMAE=""
    export DIRIN=""
    export DIRRECH=""
    export DIRPROC=""
    export DIROUT=""
}

validar_directorio(){
    PATHACTUAL=$(echo $2 | sed 's-\"--g')

    if [[ "$1" == "DIRINST" ]]
    then
        if [[ ! -f "$PATHACTUAL" ]]
        then
            MENSAJE="El archivo de instalación \""$PATHACTUAL\"" no existe, correspondiente al código: \""$1\""."
            echo "$MENSAJE"
            log_message "ERR" "$MENSAJE" "validar_directorio"
            PATH_ERRONEO="$1"
            limpiar_variables
			
            return
        else	
            MENSAJE="El archivo de instalación \""$PATHACTUAL\"" fue encontrado, correspondiente al código: \""$1\""."
            echo "$MENSAJE"
            log_message "INF" "$MENSAJE" "validar_directorio"
            #Seteamos en caso de corresponder la variable de entorno/ambiente.
            variables_ambiente "$1" "$PATHACTUAL"
        fi
    else
        if [[ ! -d "$PATHACTUAL" ]]
        then
            MENSAJE="El directorio \""$PATHACTUAL\"" no existe, correspondiente al código: \""$1\""."
            echo "$MENSAJE"
            log_message "ERR" "$MENSAJE" "validar_directorio"
            PATH_ERRONEO="$1"
            limpiar_variables
			
            return
        else	
            MENSAJE="El directorio \""$PATHACTUAL\"" fue encontrado, correspondiente al código: \""$1\""."
            echo "$MENSAJE"
            log_message "INF" "$MENSAJE" "validar_directorio"
            #Seteamos en caso de corresponder la variable de entorno/ambiente.
            variables_ambiente "$1" "$PATHACTUAL"
        fi
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
        log_message "INF" "$MENSAJE" "validar_configuracion"

        PATH_ERRONEO=""
        IDENTIFICADOR_ERRONEO=""
        #El noveno registro tiene un tratamiento especial.
        if [[ "$CANTIDAD" -lt 10 ]]
        then

            if [[ "$CANTIDAD" -eq 9 ]]
            then
                if [[ "$IDENTIFICADOR" != "INTSTALACION" ]]
                then
                    MENSAJE="En la posición 9 del archivo de configuración no se encuentra el código INSTALACION, por favor vuelva a correr instalarTP.sh con la opción de reparar." 
                    echo "$MENSAJE"
                    log_message "ERR" "$MENSAJE" "validar_configuracion"
                    ERRORLVL_CONFIG=1

					return
                else
                    MENSAJE="En la posición 9 del archivo de configuración encontramos el valor INSTALACION, con lo cual proseguimos la inicialización." 
                    echo "$MENSAJE"
                    log_message "INF" "$MENSAJE" "validar_configuracion"
                fi
            else
				echo "$IDENTIFICADOR" "$VALOR" "$CANTIDAD"
                validar_identificador "$IDENTIFICADOR" "$VALOR" "$CANTIDAD"
                if [[ "$IDENTIFICADOR_ERRONEO" != "" ]]
                then
                    MENSAJE="En la posición: \""$CANTIDAD\"" del archivo instalarTP.conf está mal especificado el código: \""$IDENTIFICADOR_ERRONEO\""." 
                    echo "$MENSAJE"
                    log_message "ERR" "$MENSAJE" "validar_configuracion"
                    MENSAJE="Por favor vuelva a ejecutar instalarTP con la opción reparar." 
                    echo "$MENSAJE"
                    log_message "ERR" "$MENSAJE" "validar_configuracion"
                    ERRORLVL_CONFIG=1

					return
                fi
                if [[ "$PATH_ERRONEO" != "" ]]
                then
                    MENSAJE="En la posición: \""$CANTIDAD\"" del archivo instalarTP.conf está mal especificado el directorio para el código: \""$PATH_ERRONEO\""."
                    echo "$MENSAJE"
                    log_message "ERR" "$MENSAJE" "validar_configuracion"
                    MENSAJE="Por favor vuelva a ejecutar instalarTP con la opción reparar." 
                    echo "$MENSAJE"
                    log_message "ERR" "$MENSAJE" "validar_configuracion"
                    ERRORLVL_CONFIG=1

					return
                fi
            fi
            let CANTIDAD="$CANTIDAD"+1
        else
            MENSAJE="El identificador: \""$IDENTIFICADOR\"" NO tiene uso alguno dentro del sistema, será omitido."
            echo "$MENSAJE"
            log_message "ALE" "$MENSAJE" "validar_configuracion"
        fi
    done < "$PATH_CONFIGURACION"
	
    ERRORLVL_CONFIG=0
}

#Los archivos del directorio de tablas maestras deben tener permiso de lectura
#Los archivos del directorio de ejecutables deben tener permiso de ejecución
# | Verificar permisos |
validar_permisos() {
    chmod -R u=rwx,g=rwx,o=rwx "$DIRMAE"
    MENSAJE="Se otorgó el permiso de lectura para el directorio de las tablas maestras." 
    echo "$MENSAJE"
    log_message "INF" "$MENSAJE" "validar_permisos"
    chmod -R u=rwx,g=rwx,o=rwx "$DIRBIN"
    MENSAJE="Se otorgó el permiso de ejecución para el directorio de los ejecutables." 
    echo "$MENSAJE"
    log_message "INF" "$MENSAJE" "validar_permisos"
}

#Ir al directorio de tablas maestras y verificar que existan
# | Verificar archivos |
validar_archivos() {
    VAR_COMERCIOS=$(echo $ARCHIVOS | cut -f1 -d-)
    VAR_TARJETAS=$(echo $ARCHIVOS | cut -f2 -d-)

    CONCATENADO_COMERCIO="${DIRMAE}${VAR_COMERCIOS}"
    if [[ ! -f "$CONCATENADO_COMERCIO" ]]
    then
        MENSAJE="Falta el archivo del directorio de tablas maestras:  \""$CONCATENADO_COMERCIO\""."
        echo "$MENSAJE"
        log_message "ERR" "$MENSAJE" "validar_archivos"
        MENSAJE="Por favor vuelva a ejecutar instalarTP con la opción reparar."
        echo "$MENSAJE"
        log_message "ERR" "$MENSAJE" "validar_archivos"
        ERRORLVL_FILES=1

		return
    else	
        MENSAJE="Se encontró el archivo del directorio de tablas maestras:  \""$CONCATENADO_COMERCIO\""."
        echo "$MENSAJE"
        log_message "INF" "$MENSAJE" "validar_archivos"
    fi

    CONCATENADO_TARJETA="${DIRMAE}${VAR_TARJETAS}"
    if [[ ! -f "$CONCATENADO_TARJETA" ]]
    then
        MENSAJE="Falta el archivo del directorio de tablas maestras:  \""$CONCATENADO_TARJETA\""."
        echo "$MENSAJE"
        log_message "ERR" "$MENSAJE" "validar_archivos"
        MENSAJE="Por favor vuelva a ejecutar instalarTP con la opción reparar."
        echo "$MENSAJE"
        log_message "ERR" "$MENSAJE" "validar_archivos"
        ERRORLVL_FILES=1
		
		return
    else	
        MENSAJE="Se encontró el archivo del directorio de tablas maestras:  \""$CONCATENADO_TARJETA\""."
        echo "$MENSAJE"
        log_message "INF" "$MENSAJE" "validar_archivos"
    fi
	
    ERRORLVL_FILES=0
}


#Todos los identificadores del archivo de configuración deben convertirse en variables de ambiente
# | Variables de ambiente |
variables_ambiente() {        
        if [[ "$1" == "GRUPO" ]]
        then
            export GRUPO="$2"        
            MENSAJE="Seteada variable de ambiente GRUPO."
            echo "$MENSAJE"
            log_message "INF" "$MENSAJE" "variables_ambiente"
        fi
        if [[ "$1" == "DIRINST" ]]
        then
            export DIRINST="$2" 
            MENSAJE="Seteada variable de ambiente DIRINST."
            echo "$MENSAJE"
            log_message "INF" "$MENSAJE" "variables_ambiente"
        fi
        if [[ "$1" == "DIRBIN" ]]
        then
            export DIRBIN="$2"
            MENSAJE="Seteada variable de ambiente DIRBIN."
            echo "$MENSAJE"
            log_message "INF" "$MENSAJE" "variables_ambiente"
        fi
        if [[ "$1" == "DIRMAE" ]]
        then
            export DIRMAE="$2"
            MENSAJE="Seteada variable de ambiente DIRMAE."
            echo "$MENSAJE"
            log_message "INF" "$MENSAJE" "variables_ambiente"
        fi
        if [[ "$1" == "DIRIN" ]]
        then
            export DIRIN="$2"
            MENSAJE="Seteada variable de ambiente DIRIN."
            echo "$MENSAJE"
            log_message "INF" "$MENSAJE" "variables_ambiente"
        fi
        if [[ "$1" == "DIRRECH" ]]
        then
            export DIRRECH="$2"
            MENSAJE="Seteada variable de ambiente DIRRECH."
            echo "$MENSAJE"
            log_message "INF" "$MENSAJE" "variables_ambiente"
        fi
        if [[ "$1" == "DIRPROC" ]]
        then
            export DIRPROC="$2"
            MENSAJE="Seteada variable de ambiente DIRPROC."
            echo "$MENSAJE"
            log_message "INF" "$MENSAJE" "variables_ambiente"
        fi
        if [[ "$1" == "DIROUT" ]]
        then
            export DIROUT="$2"
            MENSAJE="Seteada variable de ambiente DIROUT."
            echo "$MENSAJE"
            log_message "INF" "$MENSAJE" "variables_ambiente"
        fi
}

#Invocar al script pprincipal ADVERTENCIA: no invocar el proceso si ya hay uno corriendo. Avisar cuando pasa eso
# | Arrancar el proceso |
arrancar_proceso() {
    #Variable de entorno que hace referencia el estado de la inicialización.
    export INICIALIZAR="EXITO"
    MENSAJE="La inicialización ha sido exitosa, procedemos a arrancar el proceso principal."
    echo "$MENSAJE"
    log_message "INF" "$MENSAJE" "arrancar_proceso"
    ./pprincipal.sh &
	export PID_PPAL=$!
	MENSAJE="Proceso principal iniciado, con PID: $PID_PPAL."
    echo "$MENSAJE"
    log_message "INF" "$MENSAJE" "arrancar_proceso"
}

#Invocar al script pprincipal ADVERTENCIA: no invocar el proceso si ya hay uno corriendo. Avisar cuando pasa eso
# | Informar process id, como detener y arrancar el proceso |
informar_resultados() {
    MENSAJE="process id que le asigno el sistema operativo."
    echo "$MENSAJE"
    log_message "INF" "$MENSAJE" "informar_resultados"
    MENSAJE="si se quiere detener el proceso se debe usar \"./frenarproceso.sh\" ."
    echo "$MENSAJE"
    log_message "INF" "$MENSAJE" "informar_resultados"
    MENSAJE="si luego se quiere arrancar hay que hacerlo con \"./arrancarproceso.sh\" ."
    echo "$MENSAJE"
    log_message "INF" "$MENSAJE" "informar_resultados"
}

#Limpiamos la pantalla
clear

#Mensaje y log de inicio
echo 'TP1 - SO75.08 - 2do Cuatrimestre 2020 - Curso Martes Copyright © Grupo 3'
MENSAJE="Inicio - iniciarambiente"
echo "$MENSAJE"
log_message "INF" "$MENSAJE" "iniciarambiente.sh"
echo ""

#Validacion de existencia del archivo de configuración
# | Verificar configuración |
if [[ ! -f "$PATH_CONFIGURACION" ]]
then
	MENSAJE="El archivo \""$PATH_CONFIGURACION\"" no existe."
	echo "$MENSAJE"
    log_message "ERR" "$MENSAJE" "iniciarambiente.sh"
	MENSAJE="Por favor vuelva a ejecutar instalarTP con la opción reparar."
	echo "$MENSAJE"
    log_message "ERR" "$MENSAJE" "iniciarambiente.sh"
else
	PID_PPAL=$(pgrep -fn pprincipal)
	if [[ "$PID_PPAL" -gt 0 ]]
	then
		MENSAJE="El proceso principal ya se encuentra corriendo, con PID: $PID_PPAL."
		echo "$MENSAJE"
		log_message "ALE" "$MENSAJE" "iniciarambiente.sh"
		MENSAJE="Si se quiere iniciar de nuevo, antes debe detener el proceso con frenarproceso"
		echo "$MENSAJE"
		log_message "ALE" "$MENSAJE" "iniciarambiente.sh"
	else
		#Variables a exportar al ambiente
		export GRUPO=""
		export DIRINST=""
		export DIRBIN=""
		export DIRMAE=""
		export DIRIN=""
		export DIRRECH=""
		export DIRPROC=""
		export DIROUT=""
		export INICIALIZAR="ERROR"
		
		MENSAJE="El archivo \""$PATH_CONFIGURACION\"" fue encontrado."
		echo "$MENSAJE"
		log_message "INF" "$MENSAJE" "iniciarambiente.sh"
		MENSAJE="Procedemos a revisar los directorios."
		echo "$MENSAJE"
		log_message "INF" "$MENSAJE" "iniciarambiente.sh"
		##Validamos configuracion y directorios.
		validar_configuracion
		if [[ $ERRORLVL_CONFIG -eq 0 ]]
		then
			##Validamos archivos.
			validar_archivos
			if [[ $ERRORLVL_FILES -eq 0 ]]
			then
				##Validamos permisos.
				validar_permisos
				##Variables de ambiente
				variables_ambiente
				##Arrancar el proceso
				arrancar_proceso
				##Informar process id, como detener y arrancar el proceso
				informar_resultados
			fi
		fi
	fi
fi
