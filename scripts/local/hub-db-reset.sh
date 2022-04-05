#!/bin/bash

source ./system-scripts/common.sh

HUB_CTRL_DIR="$GOPATH$HUB_CTRL_PATH" # needs to be defined here so that GOPATH is available (can't be placed in .env)

info() {
    echo "-----"
    echo "[INFO] $1"
}

info "Removing ${DB_CONTAINER_NAME} container"
docker container rm -f "${DB_CONTAINER_NAME}"

info "Recreating ${DB_CONTAINER_NAME} container"
docker run -d -e POSTGRES_PASSWORD=postgres -e POSTGRES_USERNAME=postgres --name "${DB_CONTAINER_NAME}" -p 55432:5432 postgres:12

# Go to hub-controller dir for flyway actions
echo "Change directory to hub-controller"
cd "$HUB_CTRL_DIR" || exit 2

info "Creating hub schema with flyway"
flyway \
    -url=jdbc:postgresql://localhost:55432/postgres?sslmode=disable \
    -user=postgres \
    -password=postgres \
    -schemas=hub \
    -baselineOnMigrate=true \
    migrate

echo "Change directory back to ${TOOL_NAME}"
cd - || exit 2

# echo "Inserting initial data needed to hub schema"
docker cp ./scripts/sql/hub-db-starter-data.sql "${DB_CONTAINER_NAME}:/"
docker exec -i "${DB_CONTAINER_NAME}" psql -U postgres -d postgres -f ./hub-db-starter-data.sql
