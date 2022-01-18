#!/bin/bash

type psql
if [[ $? -ne 0 ]]; then
    echo "Please install PostgreSQL then try again."
    exit 1
else
    psql -U postgres -h localhost -p 5433 -a -f ./scripts/local/hub-db-starter-data.sql
fi
