#!/bin/bash

AUTH_TOKEN=
OWNER_ORG=
SMALL_ONPREM_REQ_BODY=
VERSION_ID=
SAMPLE_INSTANCE_NAME='sample-instance-create-for-debug'

hubCtrlAlive() {
    curl -s -o /dev/null http://localhost:9001/hub/v1/ping
}

checkHubCtrl() {
    # Check if local hub-controller server is running, fail if so
    if ! hubCtrlAlive; then
        echo ""
        echo "[ERROR] Hub controller is not running at http://localhost:9001 - Run you local hub-controller and try again."
        echo ""
        exit 1
    fi
}

authenticate() {
    echo "...Authenticating"
    RES="$(curl --silent --location --request POST 'http://localhost:9001/hub/v1/admin/users/login' \
        --header 'Content-Type: application/json' \
        --data-raw '{
    "username": "test@veritone.com",
    "password": "12345678"
    }')"

    OWNER_ORG=$(echo "${RES}" | jq -r ".result.internalOrganizationID")
    AUTH_TOKEN=$(echo "${RES}" | jq -r .token)
}

getVersionID() {
    echo "...Getting the version ID for the aiw instance"
    VERSION_ID=$(curl --silent --location --request GET 'http://localhost:9001/hub/v1/versions' \
        --header "Authorization: Bearer ${AUTH_TOKEN}" \
        --data-raw '' | jq -r ".result[0].versionID")
}

# Create a small instance via hub-controller
CREATE_INSTANCE_RESP=
createSmallOnPrem() {
    SMALL_ONPREM_REQ_BODY=$(
        cat <<-EOF
{"aiwareInstance":{\
"ownerOrganizationID":"${OWNER_ORG}",\
"awsRegion":"",\
"awsAccountNumber":"",\
"awsZone":"",\
"regionID":"",\
"availabilityZoneID":"",\
"azureSubscriptionID":"",\
"azureTenantID":"",\
"azureResourceGroup":"",\
"azureClientID":"",\
"azureSecret":"",\
"azureLocation":"",\
"aiwareInstanceName":"${SAMPLE_INSTANCE_NAME}",\
"description":"Created via aiWARE Hub Debug Kit",\
"managedBy":"self-managed",\
"infrastructureType":"virtual-machine",\
"status":"pending",\
"aiwareInstanceSize":"small",\
"deploymentType":"full",\
"aiwareVersionID":"${VERSION_ID}"\
},\
"configs":[]\
}
EOF
    )

    echo "...Creating an aiware instance named $SAMPLE_INSTANCE_NAME"
    CREATE_INSTANCE_RESP=$(curl -s 'http://localhost:9001/hub/v1/aiware_instance/create' \
        -H "authorization: Bearer ${AUTH_TOKEN}" \
        -H 'content-type: application/json' \
        --data-raw "$SMALL_ONPREM_REQ_BODY")
}

getInstanceInstallationCommands() {
    echo "...Getting installation commands"
    ID=$(echo "${CREATE_INSTANCE_RESP}" | jq -r ".resultID")
    COMMANDS=$(curl -s 'http://localhost:9001/hub/v1/installation/'"${ID}"'/commands/on_premises' \
        -H "authorization: Bearer ${AUTH_TOKEN}" \
        -H 'content-type: application/json')

    echo "${COMMANDS}" | jq -r .result
}

{
    checkHubCtrl
    authenticate
    getVersionID
    createSmallOnPrem "$SMALL_ONPREM_REQ_BODY" && getInstanceInstallationCommands
    echo "*****************************************"
    echo "WARNING: This script is going to login and create a new instance every time it is run."
    echo "         So, don't run it too often. Save the installation command."
    echo "*****************************************"
}
