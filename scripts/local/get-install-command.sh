#!/bin/bash

OWNER_ORG=
AUTH_TOKEN=
SMALL_ONPREM_REQ_BODY=
VERSION_ID=
SAMPLE_INSTANCE_NAME='sample-instance-create-by-hubkit'

authenticate() {
    RES="$(curl --silent --location --request POST 'http://localhost:9001/hub/v1/admin/users/login' \
    --header 'Content-Type: application/json' \
    --data-raw '{
    "username": "eercan@veritone.com",
    "password": "welcome2veritone"
    }')"

    OWNER_ORG=$(echo "${RES}" | jq -r ".result.internalOrganizationID")
    AUTH_TOKEN=$(echo "${RES}" | jq -r .token)
}

 getVersionID() {
    VERSION_ID=$(echo "$(curl --silent --location --request GET 'http://localhost:9001/hub/v1/versions' \
    --header 'Authorization: Bearer ${AUTH_TOKEN}' \
    --data-raw '')" | jq -r ".result[0].versionID")
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
SMALL_ONPREM_REQ_BODY=$(cat <<-EOF 
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
    CREATE_INSTANCE_RESP=$(curl -s 'http://localhost:9001/hub/v1/aiware_instance/create' \
    -H "authorization: Bearer ${AUTH_TOKEN}" \
    -H 'content-type: application/json' \
    --data-raw "$SMALL_ONPREM_REQ_BODY")

    echo "${CREATE_INSTANCE_RESP}" | jq
}

getInstanceInstallationCommands() {
    ID=$(echo "${CREATE_INSTANCE_RESP}" | jq -r ".resultID")
    COMMANDS=$(curl -s 'http://localhost:9001/hub/v1/installation/'${ID}'/commands/on_premises' \
    -H "authorization: Bearer ${AUTH_TOKEN}" \
    -H 'content-type: application/json')

    echo "${COMMANDS}" | jq
}

{
    authenticate
    getVersionID
    createSmallOnPrem $SMALL_ONPREM_REQ_BODY && getInstanceInstallationCommands
}