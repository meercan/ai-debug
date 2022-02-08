#!/bin/bash

echo "Inserting initial data needed to hub schema"
docker cp ./config/hub-db-starter-data.sql ai-dev-postgres:/
docker exec -i ai-dev-postgres psql -U postgres -d postgres -f ./hub-db-starter-data.sql
