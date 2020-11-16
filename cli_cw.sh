# ! /bin/bash
# programa para ejemplificar facilitar las actividades de monitoreo
# autor: Oscar Vargas IG :EcoGeekco

option=""

#Funcion para instalar cw agent en distribuciones debian
cwagent_deb-ubu () {
    apt install unzip
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    aws --version
    aws configure
    wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
    sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
    amazon-cloudwatch-agent-ctl -a start
    amazon-cloudwatch-agent-ctl -a status
    echo -e "Agente de CloudWatch ha sido instalado con exito"
    read -p "Ingrese el arn del parameter store  " ssmps
    amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c $ssmps -s
    ./update_alarms.sh 1
    }

#Funcion para instalar cw agent en distribuciones debian
cwagent_deb-ec2l-rh () {
    yum install unzip -y
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    aws --version
    aws configure
    wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
    sudo rpm -U ./amazon-cloudwatch-agent.rpm
    amazon-cloudwatch-agent-ctl -a start
    amazon-cloudwatch-agent-ctl -a status
    echo -e "Agente de CloudWatch ha sido instalado con exito"
    read -p "Ingrese el arn del parameter store  " ssmps
    amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c $ssmps -s
    ./update_alarms.sh 2
    }



while :
do
   # Limpiar pantalla
   clear
   # Ascii art
   echo -e "
   ___ _       _______    _______       __   \n
  /   | |     / / ___/   / ____/ |     / /   \n
 / /| | | /| / /\__ \   / /    | | /| / /    \n
/ ___ | |/ |/ /___/ /  / /___  | |/ |/ /     \n
/_/  |_|__/|__//____/   \____/  |__/|__/     \n
                                             \n
   "
     #Desplegar menu de opciones
   echo "___________________________________________"
   echo "     Instalacion y donfiguracion Cwagent   "
   echo "___________________________________________"
   echo "              MENU PRINCIPAL               "
   echo "___________________________________________"
   echo "1. Instalación agente CW | creación de alarmas CPU/MEM/DISK dist deb   "
   echo "2. Instalación agente CW | creación de alarmas CPU/MEM/DISK dist rh   "
   echo "0. Salir"

   # leer los datos del usuario
   read -n1 -p "Ingrese una opción [0-2]" option

  # validar la opcion de ingresada
  case $option in
  1)
     echo -e  "\n Iniciando..."
     cwagent_deb-ubu
     sleep 5
     echo -e  "\n Finalizado..."
     ;;
  2)
     echo -e  "\n Iniciando..."
     cwagent_deb-ec2l-rh
     sleep 5
     echo -e  "\n Finalizado..."
     ;;

  0)
    echo -e "\n Bye Bye "
    exit 0
    ;;
  esac
done
