#!/bin/bash

type psql
if [[ $? -ne 0 ]]; then
    echo "Please install PostgreSQL then try again."
    exit 1
else
    # here I am assuming:
    # - ai-dev-postgres container is already running
    # - hub-controller server has already run at least once to create the hub db schema
    psql -U postgres -h localhost -p 5433 -a -f ./scripts/local/hub-db-starter-data.sql
fi
