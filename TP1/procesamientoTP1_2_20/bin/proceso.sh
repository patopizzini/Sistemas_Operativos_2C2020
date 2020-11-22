#!/bin/bash

PATH_INPUT="../input/"
PATH_ACEPTADOS="../input/ok"
PATH_RECHAZADOS="../rechazados"
PATH_OUTPUT="../output"
PATH_OUTPUT_COMISIONES=".../output/comisiones"
PATH_PROCESADOS="../lotes"
ARCH_COMERCIO="../master/comercios.csv"
ARCH_TARJETASHOMOLOGAS="../master/comercios.csv"



validarNombreLongitud(){
#verifico que el nombre de los archivos sea, "C<MerchantCode>_Lote<BatchNumber>"
#<MerchantCode> pertenezca al archivo comercios.
#<BatchNumber> es un numero de 4 digitos.

find "$PATH_INPUT" -type f -not -name "C[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_Lote[0-9][0-9][0-9][0-9].csv"|
while read file
do
    if [ -f "$file" ]
    then
        echo "El archivo" "$file " "se guardo en rechazados"
        mv "$file" "$PATH_RECHAZADOS"
    fi
done

}
function validarNombreArchivoInput(){
    #estoy en archivo input


codComercio="$ARCH_COMERCIO"
while IFS=',' read merchantCode col2 col3 col4
do
    if [[ "$posibleMerchantCode" == "$merchantCode" ]];#verificamos que merchantcode esta en al archivo de comercios
    then
        return 0       
    fi    
done <"$codComercio"

}
#vemos en archivo Imput/ok que son los archivos que pasaron el primerfiltro
function verificarRegistroCabecera()
{
    let cantRegistroPorArch=0;
    for file in "$PATH_ACEPTADOS/"*.csv;
    do
       
        if [ "$(ls $PATH_ACEPTADOS/)" ];
        then
            #me quedo hasta el ultimo / osea *.csv
            #fraccionamos el nombre del archivo
            nomarchivoAceptado="${file##*$PATH_ACEPTADOS/}"
            nomarchMerchantCode="${nomarchivoAceptado:1:8}"
            #vamos por el registro de un archivo
            registroArch="$PATH_ACEPTADOS/$nomarchivoAceptado"
            contadorRegistro=00000001;
            while IFS=',' read col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11 col12 col13 col14
            do
                  echo "$nomarchMerchantCode"
                  echo "$col1"
                  echo "$col3"
                  echo "$col7"
                  echo "$col2"

                #estamos en el registro cero
                if  [[ contadorRegistro -eq 00000001 ]] && [[ $col1 == "TFH" ]] && [[ $col3 == "$nomarchMerchantCode" ]] && [[ $col7 -ne 0 ]]
                then
                    let contadorRegistro=contadorRegistro+1;
                    cantRegistroPorArch=$col7;
                    cumplecabecera=0;
                    echo "$contadorRegistro"
                    echo "$cantRegistroPorArch"
                   
                fi
                if                 
                

                
                   echo "$"
                 #  return 0
                    



            done <"$registroArch"
        fi
    done
   
}

#============Principal===================
validarNombreLongitud
for file in "$PATH_INPUT/"*.csv;
do
    if [ "$(ls $PATH_INPUT/)" ];
    then
        #me quedo hasta el ultimo /*.csv
        nomArchivo="${file##*$PATH_INPUT/}"
        posibleMerchantCode="${nomArchivo:1:8}"
        
        #validarNombreLongitud
        if validarNombreArchivoInput
        then
         mv "$file" "$PATH_ACEPTADOS"
         verificarRegistroCabecera        

        else
        mv "$file" "$PATH_RECHAZADOS"
      fi


   fi
done
