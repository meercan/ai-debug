#!/bin/sh

echo "Switching to debug config - Inserting debug env configs in hub.config"

truncate_script_file=hub-db-truncate-config.sql
sql_script_file=hub-db-debug-config.sql

docker cp "./scripts/sql/${sql_script_file}" ai-dev-postgres:/
docker cp "./scripts/sql/${truncate_script_file}" ai-dev-postgres:/
docker exec -i ai-dev-postgres psql -U postgres -d postgres -f "./${truncate_script_file}"
docker exec -i ai-dev-postgres psql -U postgres -d postgres -f "./${sql_script_file}"
