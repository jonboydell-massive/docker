

if [ "$#" -ne 7 ]; then
  echo "Updates the ECS task with a new container definition (in ecs-task.json) and deploys it to the named service (and cluster)"
  echo "Usage: ecs-docker-deploy ECS_TASK_NAME ECS_SERVICE_NAME ECS_CLUSTER_NAME DOCKER_IMAGE_NAME_AND_TAG AWS_ECS_REGION AWS_PROFILE_NAME AWS_ACCOUNT_ID"
  exit 1
fi

ECS_TASK_NAME=${1}
ECS_SERVICE_NAME=${2}
ECS_CLUSTER_NAME=${3}
DOCKER_IMAGE_NAME=${4}
AWS_ECS_REGION=${5}
AWS_PROFILE_NAME=${6}
AWS_ACCOUNT_ID=${7}

echo ---- variables
echo ECS_TASK_NAME ${ECS_TASK_NAME}
echo ECS_SERVICE_NAME ${ECS_SERVICE_NAME}
echo ECS_CLUSTER_NAME ${ECS_CLUSTER_NAME}
echo DOCKER_IMAGE_NAME ${DOCKER_IMAGE_NAME}
echo AWS_ECS_REGION ${AWS_ECS_REGION}
echo AWS_PROFILE_NAME ${AWS_PROFILE_NAME}
echo AWS_ACCOUNT_ID ${AWS_ACCOUNT_ID}

CONTAINER_PORT=80
IMAGE_URL=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_ECS_REGION}.amazonaws.com/${DOCKER_IMAGE_NAME}

CONTAINERS=$(jo volumesFrom=[] portMappings=[$(jo hostPort=0 containerPort=${CONTAINER_PORT} protocol=tcp)] memory=256 essential=true mountPoints=[] name=name image=${IMAGE_URL} cpu=0 environment=[])
jo networkMode=bridge placementConstraints=[] volumes=[] family=${ECS_TASK_NAME} containerDefinitions=[${CONTAINERS}] >> tmp-ecs-task.json
ECS_TASK_VERSION=`aws --profile ${AWS_PROFILE_NAME} --region ${AWS_ECS_REGION} ecs register-task-definition --cli-input-json file://tmp-ecs-task.json | jq .taskDefinition.revision`
#TEXT OUTPUT - | awk 'NR==1{ print $4 }'`
aws --profile ${AWS_PROFILE_NAME} --region ${AWS_ECS_REGION} ecs update-service --cluster ${ECS_CLUSTER_NAME} --service ${ECS_SERVICE_NAME} --task-definition ${ECS_TASK_NAME}:${ECS_TASK_VERSION}
rm tmp-ecs-task.json