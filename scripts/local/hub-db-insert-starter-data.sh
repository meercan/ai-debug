#!/bin/bash

echo "Inserting initial data needed to hub schema"
docker cp ./scripts/sql/hub-db-starter-data.sql "${DB_CONTAINER_NAME}:/"
docker exec -i "${DB_CONTAINER_NAME}" psql -U postgres -d postgres -f ./hub-db-starter-data.sql
