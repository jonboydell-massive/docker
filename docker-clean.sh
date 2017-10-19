echo 'Removing all running containers'
docker ps -a | awk '{ print $1 }' | grep [a-z0-9] | xargs docker rm -f
echo 'Pruning non-running container volumes'
docker volume prune -f
