#!/bin/bash

/opt/portainer/portainer --no-analytics &

PID=$!

portainer_password=$(cat /run/secrets/portainer_password)
portainer_user=$(cat /run/secrets/portainer_user)
sleep 5

curl -X POST -H "Content-Type: application/json" -d "{\"Username\":\"$portainer_user\",\"Password\":\"$portainer_password\"}" http://localhost:9000/api/users/admin/init

wait $PID