#!/bin/bash

PATH_INPUT="../input/"
PATH_ACEPTADOS="../input/ok"
PATH_RECHAZADOS="../rechazados"
PATH_OUTPUT="../output"
PATH_OUTPUT_COMISIONES=".../output/comisiones"
PATH_PROCESADOS="../lotes"
ARCH_COMERCIO="../master/comercios.csv"
ARCH_TARJETASHOMOLOGAS="../master/tarjetashomologadas.csv"



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
while IFS=',' read merchantCode merchantCode_Group col3 col4
do
   
    if [[ "$posibleMerchantCode" == "$merchantCode" ]];#verificamos que merchantcode esta en al archivo de comercios
    then
       grupoMerchant="$merchantCode_Group"
       
        return 0       
    fi    
done <"$codComercio" 

}




function validarPerteneceTarjetaHomologa(){


codTarjeta="$ARCH_TARJETASHOMOLOGAS"
while IFS=',' read idpay col2 col3 col4 col5 Settlement_file
do
    #echo "$idpay" #lee bien
    
    if [[ "$idarch" == "$idpay" ]];
    then 
        tipoDeTarjeta="$Settlement_file"     
        return 0 
    fi
    
        

done <"$codTarjeta" 

}


#vemos en archivo Imput/ok que son los archivos que pasaron el primerfiltro
function verificarRegistroCabecera()
{
    
    for fileAceptado in "$PATH_ACEPTADOS/"*.csv;
    do
       
        if [ ! "$(ls $PATH_ACEPTADOS/)" ]
        then
            echo "Se proceso todo aceptados"
            return 0
        fi
        #me quedo hasta el ultimo / osea *.csv
        #fraccionamos el nombre del archivo
        nomarchivoAceptado="${fileAceptado##*$PATH_ACEPTADOS/}"
        nomarchMerchantCode="${nomarchivoAceptado:1:8}"
        #vamos por el registro de un archivo
        registroArch="$PATH_ACEPTADOS/$nomarchivoAceptado"
        cantidaDeRegistros=$(wc -l "$registroArch" | awk '{print $1}');
                  
        let "cantidaDeRegistros = cantidaDeRegistros - 1"
        numregistro=1
        while IFS=',' read col1 col2 col3 col4 File_Creation_Date col6 col7 col8 col9 col10 col11 col12 col13 col14
        do  
            nozerocol2=$(echo $col2 | sed 's/^0*//')
                
            if [[ $nozerocol2 == $numregistro ]] && [[ $col1 == "TFH" ]] && [[ $col3 == "$nomarchMerchantCode" ]] && [[ $col7  == $cantidaDeRegistros ]]
            then
                echo "es valido cabecera"  
                           
                cumplecabecera=0;
                return 0
            else
                echo "salio"
                mv "$fileAceptado" "$PATH_RECHAZADOS"
            
            fi


            let "numregistro=numregistro+1"
                 
        done <"$registroArch"
        
    done
   
}


function verificarRegistroTransaccion()
{
    
    for fileAceptado in "$PATH_ACEPTADOS/"*.csv;
    do
       
        if [ ! "$(ls $PATH_ACEPTADOS/)" ]
        then
            echo "Se proceso todo aceptados"
            return 0
        fi
        #me quedo hasta el ultimo / osea *.csv
        #fraccionamos el nombre del archivo
        nomarchivoAceptado="${fileAceptado##*$PATH_ACEPTADOS/}"
        nomarchMerchantCode="${nomarchivoAceptado:1:8}"
        #vamos por el registro de un archivo
        registroArch="$PATH_ACEPTADOS/$nomarchivoAceptado"
        cantidaDeRegistros=$(wc -l "$registroArch" | awk '{print $1}');
                  
        let "cantidaDeRegistros = cantidaDeRegistros - 1"
        numregistro=1
        while IFS=',' read col1 col2 posibleMerchantCode col4 idarch col6 col7 col8 col9 col10 col11 col12 col13 col14
        do  
            nozerocol2=$(echo $col2 | sed 's/^0*//')
                
            
        if [[ $numregistro -ge 2 ]] && [[ $numregistro -lt $cantidaDeRegistros ]];
        then
              echo "entro"
              echo "$idarch"
              echo "$col1"
            if validarPerteneceTarjetaHomologa; #validamos la columna 5 con tarjetas homologadas
            then                          
                if [[ $nozerocol2 == $numregistro ]] && [[ $col1 == "TFD" ]]
                then
                    if [ $col12 == "000000" ] || [ $col12 == "111111" ]
                    then
                       echo "valido"
                       generarArchivoLiquidacionyComision
                       
                    else
                       mv "$fileAceptado" "$PATH_RECHAZADOS"
                    fi
                fi
            fi   
        fi

            let "numregistro=numregistro+1"
                 
        done <"$registroArch"
        
    done
   
}


function generarArchivoLiquidacionyComision()
{
    
    for fileAceptado in "$PATH_ACEPTADOS/"*.csv;
    do
       
        if [ ! "$(ls $PATH_ACEPTADOS/)" ]
        then
            echo "Se proceso todo aceptados"
            return 0
        fi
        #me quedo hasta el ultimo / osea *.csv
        #fraccionamos el nombre del archivo
        nomarchivoAceptado="${fileAceptado##*$PATH_ACEPTADOS/}"
        nomarchMerchantCode="${nomarchivoAceptado:1:8}"
        #vamos por el registro de un archivo
        registroArch="$PATH_ACEPTADOS/$nomarchivoAceptado"

        aaaa="${File_Creation_Date:0:4}"
        mm="${File_Creation_Date:4:2}"
        idTransaccion="$nomarchMerchantCode"
        nomarchSalidaLiquidacion="$tipoDeTarjeta-$aaaa-$mm"
        
        nomarchSalidaComision="$grupoMerchant-$aaaa-$mm"
        

        while IFS=',' read col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11 col12 col13 col14
        do       

        echo "$nomarchSalidaLiquidacion"
        echo "$nomarchSalidaComision"

                 
        done<"$registroArch"
        
    done
   
}






#}

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
        if validarNombreArchivoInput;
        then
        
         mv "$file" "$PATH_ACEPTADOS"  
             
        else
         mv "$file" "$PATH_RECHAZADOS"
        fi


   fi
done

if [ "$(ls $PATH_ACEPTADOS/)" ]
then
    verificarRegistroCabecera; 
    verificarRegistroTransaccion;       
fi
    

