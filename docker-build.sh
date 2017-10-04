if [ "$#" -ne 1 ]; then
  echo "Usage docker-build IMAGENAME"
  exit 1
fi

docker build -t ${IMAGENAME} .
