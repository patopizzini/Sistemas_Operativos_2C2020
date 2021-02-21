#75.08 - 2C 2020 - GRUPO 3
#
#79979 - GONZALEZ, JUAN MANUEL (juagonzalez@fi.uba.ar)
#85881 - SILVESTRI, ANDRES (asilvestri@fi.uba.ar)
#91076 - PORRAS CARHUAMACA, SHERLY KATERIN (sporras@fi.uba.ar)
#97524 - PIZZINI, PATRICIO (ppizzini@fi.uba.ar)
#
#TP2 - Ruta - Makefile

#Mensaje inicial
$(info 75.08 - 2C 2020 - GRUPO 3)
$(info )
$(info 79979 - GONZALEZ, JUAN MANUEL (juagonzalez@fi.uba.ar))
$(info 85881 - SILVESTRI, ANDRES (asilvestri@fi.uba.ar))
$(info 91076 - PORRAS CARHUAMACA, SHERLY KATERIN (sporras@fi.uba.ar))
$(info 97524 - PIZZINI, PATRICIO (ppizzini@fi.uba.ar))
$(info )
$(info TP2 - Ruta - Makefile)

#Opciones para la compilacion
CXXFLAGS= -std=c++17

#Target "all", genera los ejecutables para todos los programas del TP
#Target por default
all:
		$(info )
		$(info Generando ejecutables...)
		g++ $(CXXFLAGS) -o finalizador finalizador.cpp 
		g++ $(CXXFLAGS) -o inicializador inicializador.cpp
		g++ $(CXXFLAGS) -o status status.cpp
		g++ $(CXXFLAGS) -o terminador terminador.cpp
		g++ $(CXXFLAGS) -o vehiculoMV vehiculoMV.cpp
		g++ $(CXXFLAGS) -o vehiculoVM vehiculoVM.cpp
		
		chmod +x finalizador
		chmod +x inicializador
		chmod +x status
		chmod +x terminador
		chmod +x vehiculoMV
		chmod +x vehiculoVM
		
#Target "clean", limpia todos los archivos no fuente de los programas del TP
clean:
		$(info )
		$(info Limpiando instalación...)
		rm -f *.o
		rm -f finalizador
		rm -f inicializador
		rm -f status
		rm -f terminador
		rm -f vehiculoMV
		rm -f vehiculoVM
