# SISTEMAS OPERATIVOS (75.08) - 2C 2020 - GRUPO 3

## TP1 - README

### Integrantes:
79979 - GONZALEZ, JUAN MANUEL (juagonzalez@fi.uba.ar)

85881 - SILVESTRI, ANDRES PABLO (asilvestri@fi.uba.ar)

91076 - PORRAS CARHUAMACA, SHERLY KATERIN (sporras@fi.uba.ar)

97524 - PIZZINI, PATRICIO NICOLÁS (ppizzini@fi.uba.ar)

## Guías de instalación

### 1. Guía para la descarga del sistema:

1. Ingresar al repositorio: *https://github.com/patopizzini/Sistemas_Operativos_2C2020.* 
2. Descargarlo, haciendo ***Code -> "Download ZIP"***.
3. Extraer del ZIP el directorio ***"/TP1/Grupo3"*** y depositarlo en la locación deseada.

El sistema se encuentra inicialmente desinstalado, por lo que debe proceder a instalarlo como se explica a continuación para poder utilizarlo.

### 2. Guía para la instalación del sistema:

1. En una terminal, navegue a la carpeta ***"Grupo3"***, creada en el punto 3 de la sección anterior.
2. En la terminal, navegue al direcctorio ***/so7508***.
3. Ejecute el comando ***./instalarTP.sh***.

Si no se detecta el archivo de configuración, se procede a realizar una instalación limpia y el usuario debe nombrar las carpetas que desee utilizar, si solamente toca enter, se instalará en los paths por defecto.

Los nombres reservados, y que no se pueden utilizar, son: 
- **Grupo3**
- **so7508**
- **original**
- **catedra**
- **propios**
- **testeos**

Además, no se puede repetir paths usados en otras carpetas.

Los paths a ingresar son relativos al directorio base y debe iniciarse con '**/**'.

El directorio de binarios (por defecto es **/bin**) debe encontrase en el primer nivel de la estructura. El resto es libre, por ejemplo se puede agrupar en un solo sub-directorio.
No se deben utilizar comillas ni escapear los espacios.

Si se detecta que existe un archivo de configuración, se ejecuta un chequeo automático y se repara automáticamente en caso de ser necesario. 
El usuario debe confirmar que desea reparar.

En caso de producirse un error fatal, podrá utilizar el script ***limpiarTP.sh*** para borrar los archivos generados por el instalador (sólo funciona con valores default).

Una instalación exitosa genera los siguientes directorios (nombres por default):
- **bin**: ejecutables del sistema.
- **input**: directorio para novedades.
- **input/ok**: directorio para novedades aceptadas.
- **lotes**: lotes ya procesados.
- **master**: tablas maestras del sistema.
- **output**: directorio de resultados. 
- **output/comisiones**: archivo con el cálculo del service charge.
- **rechazos**: archivos rechazados.

Se crea un log de la instalación, ver en seccion 5 cuál es este archivo.

### 3. Guía para la inicialización del sistema:

1. En una terminal, navegue a la carpeta ***"Grupo3"***, creada en el punto 3 de la primera sección.
2. En la terminal, navegue al directorio de ejecutables (por defecto es **/bin**).
3. Ejecute el comando ***. ./inicializarTP.sh*** . Es importante respetar el formato de llamada de este comando, para conservar el entorno generado.

El script correrá en forma no interactiva y dejara el ambiente inicializado. El mismo infomará todas las operaciones realizadas.
En los directorios ***so7508/instalarTP.log*** y ***so7508/instalarTP.conf*** podrá ver los paths seleccionados luego de la instalación, en el últimoo tambien podrá ver la fecha de la instalación y de las reparaciones realizadas.

### 4. Guía para arrancar o detener el proceso principal:

1. En una terminal, navegue a la carpeta ***"Grupo3"***, creada en el punto 3 de la primera sección.
2. En la terminal, navegue al directorio de ejecutables (por defecto es **/bin**).
3. Ejecute el comando ***./arrancarproceso.sh*** para arrancar el proceso o el comando ***./frenarproceso.sh*** para detenerlo.

El script ***arrancarproceso.sh*** mismo hace los chequeos pertinentes y detecta si está corriendo o no antes de ejecutar la acción.

### 5. Archivos de log:

Los archivos de log se encuentran en los siguientes directorios:

1. Instalar TP: ***Grupo3/so7508/instalarTP.log***
2. Iniciar TP: ***Grupo3/so7508/iniciarambiente.log***
3. Proceso principal: ***Grupo3/so7508/pprincipal.log***

### 6. Pruebas completas:

Una vez que se ejecutaron los pasos ***1, 2 y 3*** se dispondrá de un sistema en ejecución. Podrá tomar cualquier archivo del directorio ***catedra o propios*** y depositarlo en el directorio input para procesarlo.
