=============================================================================
75.08 - 2C 2020 - GRUPO 3
=============================================================================
79979 - GONZALEZ, JUAN MANUEL (juagonzalez@fi.uba.ar)
85881 - SILVESTRI, ANDRES (asilvestri@fi.uba.ar)
91076 - PORRAS CARHUAMACA, SHERLY KATERIN (sporras@fi.uba.ar)
97524 - PIZZINI, PATRICIO (ppizzini@fi.uba.ar)
=============================================================================

=============================================================================
Lista de comandos en relación al makefile:
=============================================================================
make all : realiza las siguientes operaciones.
g++ -std=c++17 -o finalizador finalizador.cpp 
g++ -std=c++17 -o inicializador inicializador.cpp
g++ -std=c++17 -o status status.cpp
g++ -std=c++17 -o terminador terminador.cpp
g++ -std=c++17 -o vehiculoMV vehiculoMV.cpp
g++ -std=c++17 -o vehiculoVM vehiculoVM.cpp

make clean : realiza las siguientes operaciones. 
rm -f *.o
rm -f finalizador
rm -f inicializador
rm -f status
rm -f terminador
rm -f vehiculoMV
rm -f vehiculoVM
=============================================================================

=============================================================================
Para ejecutar tenemos los siguientes archivos:
=============================================================================
./inicializador 
Es necesario ejecutarlo para crear todas las estructuras básicas en la memoria compartida
como así también inicializar los semáforos correspondientes.

./finalizador
Se encarga de realizar una limpieza tanto de las estructuras en memoria compartida como de
los semáforos creados. Adicionalmente, se termina la ejecución de los vehículos que hubiere activos, quedando el ambiente en un estado óptimo para realizar nuevas invocaciones

./terminador
Con este comando lo que se hace es eliminar todas las estructuras en memoria compartida y borrar
los semáforos creados, luego de haber ejecutado este comando es necesario volver a correr el 
comando ./inicializador en caso de querer realizar nuevas pruebas.

./status
Este comando nos sirve para poder visualizar en todo momento el estado de la ruta, nos muestra
la siguiente información: Memoria compartida, Semáforos, Vehículos activos (PID), si bien cada
comando muestra la información pertinente esta es una manera de tener una visión general en 
un momento dado.

./vehiculoMV
Representa un vehículo que va del Monte al Valle. Cuando se ejecuta, en caso de que no haya ningún vehículo
en la ruta en dirección VM el proceso envía este vehículo a la ruta en dirección MV, caso contrario se queda
esperando, cuando la ruta se libere entraran aquellos que estuviesen esperando.

./vehiculoVM
Representa un vehículo que va del Valle al Monte. Cuando se ejecuta, en caso de que no haya ningún vehículo
en la ruta en dirección MV el proceso envía este vehículo a la ruta en dirección VM, caso contrario se queda
esperando, cuando la ruta se libere entraran aquellos que estuviesen esperando.
=============================================================================
