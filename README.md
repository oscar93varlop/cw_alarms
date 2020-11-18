# Automatiacion Cloudwatch 
en este repo quedara refelejado el proceso de instalacion y posible automatizacion de creacion de alarmas de CloudWatch



Pre-requisitos 📋
Tener una cuenta aws "ojala de uso personal"
Tener permisos en slack para agregar apps
crear un usuario IAM con FullAccessAdministrator y descargar el .csv 
Crear un role con los siguientes permisos : 
AmazonEC2RoleforSSM 
CloudWatchAgentAdminPolicy 
CloudWatchAgentServerPolicy

Comenzando 🚀

Estas instrucciones te permitirán obtenerlos prerequisitos para poder crear las alarmas basicas de Disk, mem y cpu.

Creacion de usuario IAM 🔧 
link : https://www.loom.com/share/cec0262c8bef4b2e8faf77c4034d9adf

Creacion de Role en IAM 🔧 
Realizaremos la creacion del Role que le asignaremos al la instancia EC2 para que pueda enviar dichas metricas a CloudWatch
link: https://www.loom.com/share/cde355b0e9304002be615d30b4587537

Crear webhook de Slack 🔧(crear en caso de contar con slack, de lo contrario puede omitir este paso ) 
Crearemos el webhook el cual le permite a la funcion lambda escribir/enviar el mensaje a Slack 
link : https://www.loom.com/share/b5434775e280458fbc45de65e5099bdb?sharedAppSource=personal_library

Creacion de Funciones LAMBDA 🔧 (crear en caso de contar con slack, de lo contrario puede omitir este paso )
Crearemos las dos funciones lambda la cuales nos llegara un mensaje de estado ok y alarm  a Slack 
link : https://www.loom.com/share/e809b03f85ae4053b01f5e1c16917ba7?sharedAppSource=personal_library

Creacion  de Supcripciones de SNS de email y slack 🔧 
Creamos estas suscripciones de notificacion puesto que queremos algun tipo de alertamietno cuando entren en estado de alarma y pasen a estado ok, estas notificaciones llegaran al correo como al Slack (tener en cuenta la concideracion de arriba )
link : https://www.loom.com/share/e809b03f85ae4053b01f5e1c16917ba7?sharedAppSource=personal_library

Creacion  de parameter store 🔧 
Crear el parameter store  en SSM el Json que contiene la configuracion de las metricas que el agente la cual se descarga antes de activar el agente 
Link: https://www.loom.com/share/e8b75814744a49339caa3e3544f3d0c9


Creacion  de de instancia EC2🔧
Procedemos a crear una instancia EC2 en este caso utilize las AMI por defecto de ubuntu y linux EC2 
en este proceso SOLO debemos atachar el rol creado a la instancia y debemos asignar unas tags con el Key=ENV, Value=XXXX generalmente el valor del ambiente depende de la empresa pero el estandar es QA/DEV/PROD
Link: https://www.loom.com/share/a95619aa989b4c4f85dbf9cd5ac63317

Ingreso y ejecucion del progroma ⚙️
tener en cuenta que en la creacion de la EC2 debiamos abrir el puerto 22 
ingresamos en nuestro programa de preferencia (putty/termius/mobaXterm) a la ip publica 
y descargaremos el programa a traves de este repo 

'git clone https://github.com/oscar93varlop/cw_alarms.git' (NO incluya las comillas sencillas)
ingresamos a la carpeta 
'cd cw_alarms'
cambiamos permisos de ejecución
'chmod +x cw.sh'
y ejecutamos el script
'./cw.sh'

y debemos ingresar los siguientes 
* el tipo de distribucion linux al cual le vamos a instalar el agente de CW debian/redHat
* Access key ID
* Secret access key
* la zona en la que se encuentra trabajando  en mi caso us-east-1 
* el tipo de output /en mi caso solamente le di enter/
* el nombre del parameter store que creamos anterior 
* el nombre del proyecto o empresa de las que esas instancias pertenescan para este ejemplo coloque mi nombre 
* el ARN del SNS de email
* el ARN del SNS de cw_ok
* el ARN del SNS de cw_alarm

esperar de 5 a 10 min mientras se crean las alarmas y estan empiezan a reportar datos 5 min despues de creadas 

Link : 



Lambda - El framework web usado
SNS - Manejador de dependencias
EC2 - Usado para generar RSS
SSM_ParameterStore- Manejador de dependencias
CW - Usado para generar RSS
Contribuyendo 🖇️
Por favor lee el CONTRIBUTING.md para detalles de nuestro código de conducta, y el proceso para enviarnos pull requests.

Wiki 📖
Puedes encontrar mucho más de cómo utilizar este proyecto en nuestra Wiki

Versionado 📌
Usamos SemVer para el versionado. Para todas las versiones disponibles, mira los tags en este repositorio.

Autores ✒️
Menciona a todos aquellos que ayudaron a levantar el proyecto desde sus inicios

Andrés Villanueva - Trabajo Inicial - villanuevand
Fulanito Detal - Documentación - fulanitodetal
También puedes mirar la lista de todos los contribuyentes quíenes han participado en este proyecto.

Licencia 📄
Este proyecto está bajo la Licencia (Tu Licencia) - mira el archivo LICENSE.md para detalles

Expresiones de Gratitud 🎁
Comenta a otros sobre este proyecto 📢
Invita una cerveza 🍺 o un café ☕ a alguien del equipo.
Da las gracias públicamente 🤓.
etc.
