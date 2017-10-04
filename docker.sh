docker ps | grep nginx-redirect | awk '{print $1}' | xargs docker rm -f
docker build -t nginx-redirect .
docker run -dt -p 3000:80 nginx-redirect:latest
docker ps