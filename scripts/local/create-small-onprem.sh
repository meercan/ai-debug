#!/bin/bash

SMALL_ONPREM_REQ_BODY=$(cat <<-EOF 
{"aiwareInstance":{\
"ownerOrganizationID":"4f065315-5bb4-4abd-be62-d9ca0d553f07",\
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
"aiwareInstanceName":"Small-Full-Test-Instance",\
"description":"Created via aiWARE Hub Debug Kit",\
"managedBy":"self-managed",\
"infrastructureType":"virtual-machine",\
"status":"pending",\
"aiwareInstanceSize":"small",\
"deploymentType":"full",\
"aiwareVersionID":"212ca900-257e-42ff-a011-b19062e5b478"\
},\
"configs":[]\
}
EOF
)

AUTH_TOKEN=

authenticate() {
    AUTH_TOKEN=6380e83a-51d5-4113-9dfd-1eeb9c9bdef7
}

# Create a small instance via hub-controller
createSmallOnPrem() {
    curl 'https://localhost:9001/hub/v1/aiware_instance/create' \
    -H "authorization: Bearer ${AUTH_TOKEN}" \
    -H 'content-type: application/json' \
    --data-raw "${SMALL_ONPREM_REQ_BODY}"
}
# Get the installation command from the hub-controller
# Run commands to create the instance in remote machine

{
    authenticate
    createSmallOnPrem
}