#!/bin/bash

psql --version
if [[ $? -eq 0 ]]; then
    echo "PostgreSQL is installed."
    echo "Trying to connect to PostgreSQL..."
    echo "---------------------------------"
else
    echo "Installing postgressql cli client"
    sudo apt install -y postgresql-client-common postgresql postgresql-contrib
    systemctl stop postgresql
fi

psql -h localhost -U postgres
