#!/bin/bash
#
#75.08 - 2C 2020 - GRUPO 3
#
#79979 - GONZALEZ, JUAN MANUEL (juagonzalez@fi.uba.ar)
#85881 - SILVESTRI, ANDRES (asilvestri@fi.uba.ar)
#91076 - PORRAS CARHUAMACA, SHERLY KATERIN (sporras@fi.uba.ar)
#97524 - PIZZINI, PATRICIO (ppizzini@fi.uba.ar)
#
#TP1 - limpiarTP

#Variables con directorios, valores por default
#El path base es un nivel arriba de donde ejecuta el script de instalación
PATH_BASE=$(pwd)
PATH_BASE=${PATH_BASE%/*}

#Limpieza de directorios
rm -rd $PATH_BASE/bin
rm -rd $PATH_BASE/master
rm -rd $PATH_BASE/input
rm -rd $PATH_BASE/rechazos
rm -rd $PATH_BASE/lotes
rm -rd $PATH_BASE/output

#Limpieza de archivo de configuración
rm $PATH_BASE/so7508/instalarTP.conf

#Aviso y retorno al SO
echo "Fin - limpiarTP (0)"
exit 0
