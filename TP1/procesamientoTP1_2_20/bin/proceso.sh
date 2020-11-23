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
function validarNombreTarjetasHomologadas(){
codTarjetasHomologadas="$ARCH_TARJETASHOMOLOGAS"
while IFS=',' read id_payment_method col2 col3 col4 col5 col6
do
    if [[ "$posibleIDpaymont" == "$id_payment_method" ]];
    then
         echo "esto es $id_payment_method"
        return 0
       
    fi
done < "$codTarjetasHomologadas"
}
#vemos en archivo Imput/ok que son los archivos que pasaron el primerfiltro
function verificarRegistroCabeceraYTransaccion()
{
    
    for fileAceptado in "$PATH_ACEPTADOS/"*.csv;
    do
       
        if [ "$(ls $PATH_ACEPTADOS/)" ];
        then
            #me quedo hasta el ultimo / osea *.csv
            #fraccionamos el nombre del archivo
            nomarchivoAceptado="${fileAceptado##*$PATH_ACEPTADOS/}"
            nomarchMerchantCode="${nomarchivoAceptado:1:8}"
            #vamos por el registro de un archivo
            registroArch="$PATH_ACEPTADOS/$nomarchivoAceptado"
            cantidaDeRegistros=$(wc -l "$registroArch" | awk '{print $1}');
            
            
            let "cantidaDeRegistros = cantidaDeRegistros - 1"
            numregistro=1
            while IFS=',' read col1 col2 col3 col4 posibleIDpaymont col6 col7 col8 col9 col10 col11 col12 col13 col14
            do
               
                nozerocol2=$(echo $col2 | sed 's/^0*//')
               
                if [[ $nozerocol2 == $numregistro ]] && [[ $col1 == "TFH" ]] && [[ $col3 == "$nomarchMerchantCode" ]] && [[ $col7  == $cantidaDeRegistros ]]
                then
                                  
                    cumplecabecera=0;                
                    
                fi
                
                if [[ "$cumplecabecera" == 0 ]]
                then
                    if validarNombreTarjetasHomologadas #validamos la columna 5 con tarjetas homologadas
                    then
                         if [[ $nozerocol2 == $numregistro ]] && [[ $col1 == "TFD" ]]
                         then
                            if [ $col12 == "000000" ] || [ $col12 == "111111" ]
                            then
                             return 0
                            else
                                mv "$fileAceptado" "$PATH_RECHAZADOS"
                            fi
                        fi
                    fi 
                fi
                let "numregistro=numregistro+1"
                 
            done <"$registroArch"
        fi
    done
   
}



function generarArchivoLiquidacion(){
    




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
         if verificarRegistroCabeceraYTransaccion        
         then
            echo "paso los filtros ahora  generar informes"
         fi

        else
        mv "$file" "$PATH_RECHAZADOS"
      fi


   fi
done
