##El siguiente script es con el fin de automatizar el proceso de creaci�n de alarmas en las instancias EC2
##1-Variables ATENCION  estos valores se deben remplazar por los valores correctos, depende del cliente o proyecto al cual lo estemos aplicando
PROJECT=""
ARN_EMAIL=""
ARN_SLACK_OK=""
ARN_SLACK_ALARM=""

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
aws cloudwatch put-metric-alarm --alarm-name $PROJECT-DISK-70%-Warning-$TAG_ENV-$ID_CUT --alarm-description "$PROJECT-DISK-70%-Warning-$TAG_ENV-$ID_CUT" --metric-name disk_used_percent --namespace CWAgent --statistic Average --period 300 --threshold 70 --comparison-operator GreaterThanThreshold  --dimensions Name=InstanceId,Value=$INST_ID Name=InstanceType,Value=$INST_TYPE Name=path,Value=/ Name=AutoScalingGroupName,Value=$ASG_NAME Name=device,Value=nvme0n1p1 Name=fstype,Value=ext4 Name=ImageId,Value=$AMI_ID --evaluation-periods 1 --alarm-actions $ARN_EMAIL $ARN_SLACK_ALARM --ok-actions $ARN_EMAIL $ARN_SLACK_OK --unit Percent

aws cloudwatch put-metric-alarm --alarm-name $PROJECT-DISK-90%-Critical-$TAG_ENV-$ID_CUT --alarm-description "$PROJECT-DISK-90%-Critical-$TAG_ENV-$ID_CUT" --metric-name disk_used_percent --namespace CWAgent --statistic Average --period 300 --threshold 90 --comparison-operator GreaterThanThreshold  --dimensions Name=InstanceId,Value=$INST_ID Name=InstanceType,Value=$INST_TYPE Name=path,Value=/ Name=AutoScalingGroupName,Value=$ASG_NAME Name=device,Value=nvme0n1p1 Name=fstype,Value=ext4 Name=ImageId,Value=$AMI_ID --evaluation-periods 1 --alarm-actions $ARN_EMAIL $ARN_SLACK_ALARM --ok-actions $ARN_EMAIL $ARN_SLACK_OK --unit Percent

#Memoria
aws cloudwatch put-metric-alarm --alarm-name $PROJECT-MEMORY-70%-Warning-$TAG_ENV-$ID_CUT --alarm-description "$PROJECT-MEMORY-70%-Warning-$TAG_ENV-$ID_CUT" --metric-name mem_used_percent --namespace CWAgent --statistic Average --period 300 --threshold 70 --comparison-operator GreaterThanThreshold  --dimensions Name=InstanceId,Value=$INST_ID Name=InstanceType,Value=$INST_TYPE --evaluation-periods 1 --alarm-actions $ARN_EMAIL $ARN_SLACK_ALARM --ok-actions $ARN_EMAIL $ARN_SLACK_OK --unit Percent

aws cloudwatch put-metric-alarm --alarm-name $PROJECT-MEMORY-90%-Critical-$TAG_ENV-$ID_CUT --alarm-description "$PROJECT-MEMORY-90%-Critical-$TAG_ENV-$ID_CUT" --metric-name mem_used_percent --namespace CWAgent --statistic Average --period 300 --threshold 90 --comparison-operator GreaterThanThreshold  --dimensions Name=InstanceId,Value=$INST_ID Name=InstanceType,Value=$INST_TYPE --evaluation-periods 1 --alarm-actions $ARN_EMAIL $ARN_SLACK_ALARM --ok-actions $ARN_EMAIL $ARN_SLACK_OK --unit Percent

##CPU
aws cloudwatch put-metric-alarm --alarm-name $PROJECT-CPU-70%-Warning-$TAG_ENV-$ID_CUT --alarm-description "$PROJECT-CPU-70%-Warning-$TAG_ENV-$ID_CUT" --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold 70 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions Name=InstanceId,Value=$INST_ID --evaluation-periods 1 --alarm-actions $ARN_EMAIL $ARN_SLACK_ALARM --ok-actions $ARN_EMAIL $ARN_SLACK_OK --unit Percent

aws cloudwatch put-metric-alarm --alarm-name $PROJECT-CPU-90%-Critical-$TAG_ENV-$ID_CUT --alarm-description "$PROJECT-CPU-90%-Critical-$TAG_ENV-$ID_CUT" --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold 90 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions Name=InstanceId,Value=$INST_ID --evaluation-periods 1 --alarm-actions $ARN_EMAIL $ARN_SLACK_ALARM --ok-actions $ARN_EMAIL $ARN_SLACK_OK --unit Percent
