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



Dí cómo será ese paso

Da un ejemplo
Y repite

hasta finalizar
Finaliza con un ejemplo de cómo obtener datos del sistema o como usarlos para una pequeña demo

Ejecutando las pruebas ⚙️
Explica como ejecutar las pruebas automatizadas para este sistema

Analice las pruebas end-to-end 🔩
Explica que verifican estas pruebas y por qué

Da un ejemplo
Y las pruebas de estilo de codificación ⌨️
Explica que verifican estas pruebas y por qué

Da un ejemplo
Despliegue 📦
Agrega notas adicionales sobre como hacer deploy

Construido con 🛠️
Menciona las herramientas que utilizaste para crear tu proyecto

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
