#!/bin/bash

# exit when any command fails
set -e

# Check if number of arguments isn't equal to 2
if [ "$#" -ne 2 ]; then
    echo "You must enter 2 command line arguments: CLOUD_ONE_REGION CLOUD_ONE_API_KEY"
    exit
fi

# Check if helm is installed.
if ! command -v helm &> /dev/null
then
    echo "helm could not be found. Install it following this: https://helm.sh/docs/intro/install/"
    exit
fi

# Check if jq is installed.
if ! command -v jq &> /dev/null
then
    echo "jq could not be found. Install it following this: https://stedolan.github.io/jq/download/"
    exit
fi

# First parameter is the cloudone api key.
REGION=$1
C1APIKEY=$2
echo $C1APIKEY

CSAPIKEY=$(curl --location --request POST "https://container.${REGION}.cloudone.trendmicro.com/api/clusters" \
--header 'api-version: v1' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--header "Authorization: ApiKey ${C1APIKEY}" \
--data-raw '{
  "name": "DemoCluster",
  "description": "My Demo Cluster description"
}' | jq -r '.apiKey')

echo "Your Container Security Cluster API Key is ${CSAPIKEY}"

sed -e "s/YOUR_REGION_HERE/${REGION}/" -e "s/YOUR_API_HERE/${CSAPIKEY}/" overrides.yaml > overrides.yaml

helm install \
     trendmicro \
     --namespace trendmicro-system --create-namespace \
     --values overrides.yaml \
     https://github.com/trendmicro/cloudone-container-security-helm/archive/master.tar.gz