#!/bin/bash

RES="$(curl --silent --location --request POST 'http://localhost:9001/hub/v1/admin/users/login' \
    --header 'Content-Type: application/json' \
    --data-raw '{
"username": "test@veritone.com",
"password": "welcome2veritone"
}')"

echo "${RES}" | jq -r .token
