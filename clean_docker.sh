# Do not use this in production

# Stops all container
docker stop $(docker ps -q -a)

# Delete all containers
docker rm $(docker ps -q -a)

# Delete all networks
docker network rm $(docker network ls)

# Delete all volumes
docker volume rm $(docker volume ls)