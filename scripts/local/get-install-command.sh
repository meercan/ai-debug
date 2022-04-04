#!/bin/bash

AUTH_TOKEN=
OWNER_ORG=
SMALL_ONPREM_REQ_BODY=
VERSION_ID=
SAMPLE_INSTANCE_NAME='sample-instance-create-for-debug'

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

#  getSampleInstance() {
#     SAMPLE_INSTANCE=$(curl --silent --location --request GET 'http://localhost:9001/hub/v1/aiware_instances?aiwareInstanceName=${SAMPLE_INSTANCE_NAME}' \
# --header 'Authorization: Bearer ${AUTH_TOKEN}')
# echo "SAMPLE_INSTANCE : ${SAMPLE_INSTANCE}"
#     return $?
#  }

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
    authenticate
    getVersionID
    createSmallOnPrem "$SMALL_ONPREM_REQ_BODY" && getInstanceInstallationCommands
    echo "*****************************************"
    echo "WARNING: This script is going to login and create a new instance every time it is run."
    echo "         So, don't run it too often. Save the installation command."
    echo "*****************************************"
}
