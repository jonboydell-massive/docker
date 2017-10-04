if [ "$#" -lt 5 ]; then
  echo "Usage ecs-docker-build.sh image-name aws-profile-name aws-account-id aws-ecr-region build-number [build-ref-name]"
  exit 1
fi

DOCKER_IMAGE_NAME=${1}
AWS_PROFILE=${2}
AWS_ACCOUNT_ID=${3}
AWS_ECR_REGION=${4}
BUILD_NUMBER=${5}
BUILD_REF_NAME=${6}

echo ---- variables
echo DOCKER_IMAGE_NAME ${DOCKER_IMAGE_NAME} ${1}
echo AWS_PROFILE ${AWS_PROFILE} ${2}
echo AWS_ACCOUNT_ID ${AWS_ACCOUNT_ID} ${3}
echo AWS_ECR_REGION ${AWS_ECR_REGION} ${4}
echo BUILD_NUMBER ${BUILD_NUMBER} ${5}
if [ -n "${BUILD_REF_NAME}" ]; then
  echo BUILD_REF_NAME ${BUILD_REF_NAME} ${6}
fi

docker build -t ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} .

DOCKER_LOGIN=$(aws --profile ${AWS_PROFILE} ecr get-login --no-include-email --region ${AWS_ECR_REGION})
eval ${DOCKER_LOGIN}

docker tag ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_ECR_REGION}.amazonaws.com/${DOCKER_IMAGE_NAME}:latest
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_ECR_REGION}.amazonaws.com/${DOCKER_IMAGE_NAME}:latest
docker rmi ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_ECR_REGION}.amazonaws.com/${DOCKER_IMAGE_NAME}:latest

docker tag ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_ECR_REGION}.amazonaws.com/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_ECR_REGION}.amazonaws.com/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}
docker rmi ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_ECR_REGION}.amazonaws.com/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}

if [ -n "${BUILD_REF_NAME}" ]; then
  docker tag ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_ECR_REGION}.amazonaws.com/${DOCKER_IMAGE_NAME}:${BUILD_REF_NAME}
  docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_ECR_REGION}.amazonaws.com/${DOCKER_IMAGE_NAME}:${BUILD_REF_NAME}
  docker rmi ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_ECR_REGION}.amazonaws.com/${DOCKER_IMAGE_NAME}:${BUILD_REF_NAME}
fi

docker rmi ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}