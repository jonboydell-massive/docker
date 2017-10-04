if [ "$#" -ne 1 ]; then
  echo "Usage docker-logs IMAGENAME"
  exit 1
fi

IMAGENAME=${1}
CONTAINER=`docker ps -a | grep ${IMAGENAME} | awk '{ print $1 }'`

if [ `echo ${CONTAINER} | wc -m ` -lt 2 ]; then 
  echo "Container with image ${IMAGENAME} is not available"
  exit 1 
fi

docker logs -f ${CONTAINER}
