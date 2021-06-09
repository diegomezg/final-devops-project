#!/bin/bash

RESOURCE_GROUP_NAME=diego-gomez
STORAGE_ACCOUNT_NAME=team3demodou
CONTAINER_NAME=tstate

# Create resource group
#az group create --name $RESOURCE_GROUP_NAME --location westeurope

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

# Create service principal
az ad sp create-for-rbac -n "final-project" --role Contributor --scopes /subscriptions/$ACCOUNT_ID/resourceGroups/$RESOURCE_GROUP_NAME

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"