if [ "$#" -ne 1 ]; then
  echo "Usage docker-build IMAGENAME"
  exit 1
fi

IMAGENAME=${1}
echo "Will build ${IMAGENAME}"

docker build -t ${IMAGENAME} .
