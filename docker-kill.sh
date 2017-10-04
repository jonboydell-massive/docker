if [ "$#" -ne 1 ]; then
  echo "Usage docker-kill IMAGENAME"
  exit 1
fi

IMAGENAME=${1}
CONTAINER=`docker ps | grep ${IMAGENAME} | awk '{ print $1 }'`

if [ `echo ${CONTAINER} | wc -m ` -lt 2 ]; then 
  echo "Container with image ${IMAGENAME} is not running"
  exit 1 
fi

echo "Killing container with image ${IMAGENAME}"

docker rm -f ${CONTAINER}
