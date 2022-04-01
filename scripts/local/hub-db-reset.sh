#!/bin/bash
source .env
HUB_CTRL_DIR=$GOPATH$DEBUG_AIWARE_HUB_CONTROLLER_PATH

info() {
    echo "-----"
    echo "[INFO] $1"
}

info "Removing ai-dev-postgres container"
docker container rm -f ai-dev-postgres

info "Recreating ai-dev-postgres container"
docker run -d -e POSTGRES_PASSWORD=postgres -e POSTGRES_USERNAME=postgres --name ai-dev-postgres -p 55432:5432 postgres:12

# Go to hub-controller dir for flyway actions
cd "$HUB_CTRL_DIR" || exit
info "Creating hub schema with flyway"
# FLYWAY_LOCATIONS="filesystem:./sql"
# FLYWAY_CFG_FILE=config/flyway-hub.conf
flyway \
    -url=jdbc:postgresql://localhost:55432/postgres?sslmode=disable \
    -user=postgres \
    -password=postgres \
    -schemas=hub \
    -baselineOnMigrate=true \
    migrate
cd - || exit

# echo "Inserting initial data needed to hub schema"
# docker cp ./config/hub-db-starter-data.sql ai-dev-postgres:/
# docker exec -i ai-dev-postgres psql -U postgres -d postgres -f ./hub-db-starter-data.sql
