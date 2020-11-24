# Limpiar pantalla
clear
# Ascii art
echo -e "
    ___ _       _______    _______       __   \n
   /   | |     / / ___/   / ____/ |     / /   \n
  / /| | | /| / /\__ \   / /    | | /| / /    \n
 / ___ | |/ |/ /___/ /  / /___  | |/ |/ /     \n
/_/  |_|__/|__//____/   \____/  |__/|__/     \n

   "
   echo "___________________________________________"
   echo "     Instalacion y donfiguracion Cwagent   "
   echo "___________________________________________"
   echo "              MENU PRINCIPAL               "
   echo "___________________________________________"
   echo "1. Instalación agente CW | creación de alarmas CPU/MEM/DISK dist deb   "
   echo "2. Instalación agente CW | creación de alarmas CPU/MEM/DISK dist rh   "
opcion=""
read -n1 -p   "ingrese el tipo de file system que tiene su sistema 1 Dist deb 2 Dist rh  [1-2]" opcion
if [ $opcion -eq 1 ]; then
   echo "su fstype es una distribucion debian"
   sudo apt install unzip
   wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
   sudo sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
   device="xvda1"
   fstype="ext4"
elif [ $opcion -eq 2 ]; then
   echo "u fstype es una distribucion rh"
   sudo yum install unzip
   wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
   sudo rpm -U ./amazon-cloudwatch-agent.rpm
    device="xvda1"
    fstype="xfs"
else
   echo "opcion equivocada vuelva a intentarlo"
fi
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
aws configure
amazon-cloudwatch-agent-ctl -a start
amazon-cloudwatch-agent-ctl -a status
echo -e "Agente de CloudWatch ha sido instalado con exito"
read -p "Ingrese el arn del parameter store  " ssmps
amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:$ssmps -s
##El siguiente script es con el fin de automatizar el proceso de creaci�n de alarmas en las instancias EC2
##1-Variables ATENCION  estos valores se deben ingresar por los valores correctos, depende del cliente o proyecto al cual lo estemos aplicando
PROJECT=""
ARN_EMAIL=""
ARN_SLACK_OK=""
ARN_SLACK_ALARM=""
read -p "Ingresar el nombre de prueba o proyecto o empresa " PROJECT
read -p "Ingresar el ARN de la SNS de correo " ARN_EMAIL
read -p "Ingresar el ARN de la SNS de envio de notificacion a slack en estado OK " ARN_SLACK_OK
read -p "Ingresar el ARN de la SNS de envio de notificacion a slack en estado ALARM " ARN_SLACK_ALARM
##2-Variables-Metadata EC2, en esta secci�n se captura los metadatos de la instancia
ASG_NAME=$(aws autoscaling describe-auto-scaling-instances --instance-ids `curl --silent http://169.254.169.254/latest/meta-data/instance-id 2>&1` | grep AutoScalingGroupName | sed 's/ //g' | sed 's/"//g' | sed 's/^.\{,21\}//' | sed 's/,//g')
AMI_ID=$(curl --silent http://169.254.169.254/latest/meta-data/ami-id)
INST_ID=$(curl --silent http://169.254.169.254/latest/meta-data/instance-id)
INST_TYPE=$(curl --silent http://169.254.169.254/latest/meta-data/instance-type)
REGION=$(curl --silent http://169.254.169.254/latest/meta-data/placement/region)
##3-Esta variable se usa cuando haya mas de 1 instancia en el mismo ambiente (captura los ultimos 3 caracteres del id de la instancia)
ID_CUT=$(echo ${INST_ID:16})
##4-Capturamos el tag del ambiente de la instancia
GET_TAG=$(aws ec2 describe-tags --filters Name=resource-id,Values=$INST_ID Name=key,Values=Name | grep Value | tr -d '[[:space:]]' | tr -d "\":,")
TAG_ENV=$(echo ${GET_TAG:5})
##5-Crear las alarmas de Cloudwatch
#Disco
aws cloudwatch put-metric-alarm --alarm-name $PROJECT-DISK-70%-Warning-$TAG_ENV-$ID_CUT --alarm-description "$PROJECT-DISK-70%-Warning-$TAG_ENV-$ID_CUT" --metric-name disk_used_percent --namespace CWAgent --statistic Average --period 300 --threshold 70 --comparison-operator GreaterThanThreshold  --dimensions Name=InstanceId,Value=$INST_ID Name=InstanceType,Value=$INST_TYPE Name=path,Value=/  Name=device,Value=$device Name=fstype,Value=$fstype  Name=ImageId,Value=$AMI_ID  --evaluation-periods 1 --alarm-actions $ARN_EMAIL $ARN_SLACK_ALARM --ok-actions $ARN_EMAIL $ARN_SLACK_OK --unit Percent
aws cloudwatch put-metric-alarm --alarm-name $PROJECT-DISK-90%-Critical-$TAG_ENV-$ID_CUT --alarm-description "$PROJECT-DISK-90%-Critical-$TAG_ENV-$ID_CUT" --metric-name disk_used_percent --namespace CWAgent --statistic Average --period 300 --threshold 90 --comparison-operator GreaterThanThreshold  --dimensions Name=InstanceId,Value=$INST_ID Name=InstanceType,Value=$INST_TYPE Name=path,Value=/  Name=device,Value=$device Name=fstype,Value=$fstype  Name=ImageId,Value=$AMI_ID  --evaluation-periods 1 --alarm-actions $ARN_EMAIL $ARN_SLACK_ALARM --ok-actions $ARN_EMAIL $ARN_SLACK_OK --unit Percent
#Memoria
aws cloudwatch put-metric-alarm --alarm-name $PROJECT-MEMORY-70%-Warning-$TAG_ENV-$ID_CUT --alarm-description "$PROJECT-MEMORY-70%-Warning-$TAG_ENV-$ID_CUT" --metric-name mem_used_percent --namespace CWAgent --statistic Average --period 300 --threshold 70 --comparison-operator GreaterThanThreshold  --dimensions Name=InstanceId,Value=$INST_ID Name=InstanceType,Value=$INST_TYPE  Name=ImageId,Value=$AMI_ID  --evaluation-periods 1 --alarm-actions $ARN_EMAIL $ARN_SLACK_ALARM --ok-actions $ARN_EMAIL $ARN_SLACK_OK --unit Percent
aws cloudwatch put-metric-alarm --alarm-name $PROJECT-MEMORY-90%-Critical-$TAG_ENV-$ID_CUT --alarm-description "$PROJECT-MEMORY-90%-Critical-$TAG_ENV-$ID_CUT" --metric-name mem_used_percent --namespace CWAgent --statistic Average --period 300 --threshold 90 --comparison-operator GreaterThanThreshold  --dimensions Name=InstanceId,Value=$INST_ID Name=InstanceType,Value=$INST_TYPE  Name=ImageId,Value=$AMI_ID  --evaluation-periods 1 --alarm-actions $ARN_EMAIL $ARN_SLACK_ALARM --ok-actions $ARN_EMAIL $ARN_SLACK_OK --unit Percent
##CPU
aws cloudwatch put-metric-alarm --alarm-name $PROJECT-CPU-70%-Warning-$TAG_ENV-$ID_CUT --alarm-description "$PROJECT-CPU-70%-Warning-$TAG_ENV-$ID_CUT" --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold 70 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions Name=InstanceId,Value=$INST_ID --evaluation-periods 1 --alarm-actions $ARN_EMAIL $ARN_SLACK_ALARM --ok-actions $ARN_EMAIL $ARN_SLACK_OK --unit Percent
aws cloudwatch put-metric-alarm --alarm-name $PROJECT-CPU-90%-Critical-$TAG_ENV-$ID_CUT --alarm-description "$PROJECT-CPU-90%-Critical-$TAG_ENV-$ID_CUT" --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold 90 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions Name=InstanceId,Value=$INST_ID --evaluation-periods 1 --alarm-actions $ARN_EMAIL $ARN_SLACK_ALARM --ok-actions $ARN_EMAIL $ARN_SLACK_OK --unit Percent
