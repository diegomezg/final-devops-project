# Deployment Usage Guide (Infrastructure)

The first step to follow in this guide is consider to fork the repository [Infra App](https://dev.azure.com/diegogomez0768/Final%20Project/_git/Deployment-App?path=%2F&version=GBmaster&_a=contents)

## Prerequisites

### **Install software prerequisites**

You will need to install the following tools:

- [Azure Command Line Interface (CLI)](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest): To create Azure resources, use Terraform with your Azure account, and retrieve credentials Kubernetes configuration.
- [Azure Resource Group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal): You need to create a resource group in Azure.

## **Configure Azure CLI**

Use `az login` to log into your Azure account. A new browser window will open where you can finish the login procedure before returning to the terminal. If using a remote terminal or an environment without a browser, an special code and URL will be shown to open in another computer's browser to finish the login procedure.

```
az login
```

Note, we have launched a browser for you to login. For old experience with device code, use "az login --use-device-code"
You have logged in. Now let us find all the subscriptions to which you have access...  
```
[
  {
    "cloudName": "AzureCloud",
    "id": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
    "isDefault": true,
    "name": "Your-subscription-name",
    "state": "Enabled",
    "tenantId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
    "user": {
      "name": "your.email@your.domain.example.com",
      "type": "user"
    }
  }
]
```

Now your az command line instructions will use your account credentials. We will later need the "id" value shown when you log in.

## **Create Storage for Terraform to store plan**

We will use an storage volume in Azure to store the infrastructure state created with Terraform later. To do this we use the resource group of our co-worker Diego, and inside it, an storage with "team3demodou" name.

For more information, see: [https://docs.microsoft.com/en-us/azure/terraform/terraform-backend](https://docs.microsoft.com/en-us/azure/terraform/terraform-backend)

```#!/bin/bash

RESOURCE_GROUP_NAME=<resource-group-name>
STORAGE_ACCOUNT_NAME=<storage-account-name>
CONTAINER_NAME=<container-name>

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"`
```
At the end of the execution, the values of environment variables will be shown.

## **Create a Key Vault and store secrets**

We will need several secret values stored, but we don't want them to be stored on a file that can be stolen or uploaded to an unsafe place. To store them securely, we will create an Azure Key Vault resource.

To create a Key Vault resource in a resource group use:

```
az keyvault create --name "<name-keyvault>" --resource-group "<resource-group-name>"
```

To store the access key of the volume in the Key Vault:

```
az keyvault secret set --vault-name "<name-keyvault>" --name "<AccessKeyname>" --value $ACCOUNT_KEY
```

Any time later you need to retrieve this value, you can do so after having logged in with Azure CLI, using:

```
az keyvault secret show --name "<AccessKeyname>" --vault-name "<name-keyvault>" --query value -o tsv
```

## **Create a Service Principal with the command line**

A Service Principal is like a new user that we create to grant permissions to only do what we need it to do. That way we are not using our user with owner role.

AKS needs a service principal to be able to create virtual machines for the Kubernetes cluster infrastructure.

To create a new Service Principal use the following command, replacing 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX' with your account id shown when you log in with `az login`.  

Input:
```
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX" --name <ServPrincipalAKS>
```
Output:
```
Creating a role assignment under the scope of "/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  Retrying role assignment creation: 1/36
  Retrying role assignment creation: 2/36
{
  "appId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
  "displayName": "azure-cli-XXXX-XX-XX-XX-XX-XX",
  "name": "http://azure-cli-XXXX-XX-XX-XX-XX-XX",
  "password": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
  "tenant": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
}
```
## **Save Service Principal id and secret to Key Vault**

Take note of the appId (the id) and the password (the secret) for the service principal just created. We will store them in the Key Vault.

`az keyvault secret set --vault-name "<name-keyvault>" --name "spId" --value "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
az keyvault secret set --vault-name "<name-keyvault>" --name "spSecret" --value "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"`

Now, when we want to retrieve them and the storage access key to environment variables that Terraform can use, without having the written down in any file, we use:
```
TF_VAR_client_id=$(az keyvault secret show --name "spId" --vault-name "<name-keyvault>" --query value -o tsv)  
```
```
TF_VAR_client_secret=$(az keyvault secret show --name "spSecret" --vault-name "<name-keyvault>" --query value -o tsv)  
```
```
ARM_ACCESS_KEY=$(az keyvault secret show --name "tstateAccessKey" --vault-name "<name-keyvault>" --query value -o tsv)`
```
Those special variable names are expected by Terraform for those parameters. Remember, for those commands to work, we must have logged in with the Azure CLI first.

## Provision infrastructure with Terraform

We will store the infrastructure state in the volume storage created previously, so any other person trying to work with this infrastructure will have access to it. Also when executing changes, the state will be locked, preventing other users to try to change infrastructure at the same time.

Change to the `infra` directory. You will find several files and folders:

- `backend.tfconfig`: parameters for the resource group and volume name that will store the infrastructure state
- `terraform.tfvars`: input values to define a prefix* for all resource names, and default datacenter location
- `variables.tf`: inputs definitions, including the ones for the terraform.tfvars values, and the service principal id and secret.
- `main.tf`: main Terraform file that references all other modules
- `outputs.tf`: output variable definitions
- `modules` (folder)
    - `acr` (folder): files to define an Azure Container Registry provisioning
    - `aks` (folder): files to define an Azure Kubernetes Service provisioning
    - `load_balancer` (folder): files to define load balancer
    - `public_ip` (folder): files to define a public ip
    - `helm` (folder): files to install Prometheus with Helm and create kubernetes namespaces called monitoring and dev.
- The "prefix" must contain only alphabetical characters, because it is used for the name of the Azure Container Registry, and that only allows this kind of characters (no numbers, dashes or underscores).

Following of running the pipeline from the forked repo.

Now in the pipeline we run some tasks: 

In the Pipeline first we specify to install the terraform:

```bash
steps:
- task: TerraformInstaller@0
  displayName: 'Terraform version'
  inputs:
    terraformVersion: '1.0.0'
```

Now we install the Azure CLI in the pipeline and login to your azure account:

```bash
task: AzureCLI@2
  displayName: Azure CLI
  inputs:
    addSpnToEnvironment: true
    azureSubscription: ServConnectionName
    scriptType: bash
    scriptLocation: inlineScript
    inlineScript: |
      az --version
      az account show
```

 Now in the pipeline we specify to do the terraform init in the infra folder:

```bash
task: TerraformTaskV2@2
  inputs:
    provider: 'azurerm'
    command: 'init'
    workingDirectory: '$(System.DefaultWorkingDirectory)/infra'
    backendServiceArm: 'ServConnectionName'
    backendAzureRmResourceGroupName: '<resource-group-name>'
    backendAzureRmStorageAccountName: '<storage-account-name>'
    backendAzureRmContainerName: 'tstate'
    backendAzureRmKey: 'terraform.tfstate'
```

Then through the pipeline we defined some environment variables needed for establish connection with Azure resources and verify credentials:

```bash
task: CmdLine@2
  inputs:
    script: 'export TF_VAR_client_id=$(TF_VAR_client_id) TF_VAR_client_secret=$(TF_VAR_client_secret)'
```

The next step is to implement the terraform plan on the pipeline:

```bash
task: TerraformTaskV2@2
  displayName: TF PLAN
  inputs:
    provider: 'azurerm'
    command: 'plan'
    workingDirectory: '$(System.DefaultWorkingDirectory)/infra'
    commandOptions: '-lock=false -var="client_id=$(TF_VAR_client_id)" -var="client_secret=$(TF_VAR_client_secret)"'
    environmentServiceNameAzureRM: 'ServConnectionName'
```

Then we set up the terraform apply:

```bash
task: TerraformTaskV2@2
  displayName: TF APPLY
  inputs:
    provider: 'azurerm'
    command: 'apply'
    workingDirectory: '$(System.DefaultWorkingDirectory)/infra'
    commandOptions: '-lock=false -auto-approve -var="client_id=$(TF_VAR_client_id)" -var="client_secret=$(TF_VAR_client_secret)"'
    environmentServiceNameAzureRM: 'ServConnectionName'
```

The plan will be shown again. The provisioning process will last more than 10 minutes. At the beginning of this process, the plan will be saved on the Azure storage created previously, and the file marked as 'locked', so anybody else using the same plan will be prevented to do changes to infrastructure until you finish.

The last step before your first pipeline RUN is to create some Azure Pipelines variables, from the last pipeline you must have a Service Principal credentials just as:
* TENANT_ID  
This is the Service Principal tenant.
* TF_VAR_client_id  
This is the Service Principal app id.
* TF_VAR_SUBSCRIPTION_ID  
This is your subscription id.
* TF_VAR_client_secret  
This is the Service Principal password.  
>*Note: This variables must be marked as SECRETS to hide values from other users*

## **You will now have on your Azure account:**

- An storage account, that holds the rest of the resources
- An Azure Container Registry to store the images of the microservices containers
- A public IP assignment
- A load balancer assigned to that public IP
- An Azure Kubernetes Service managed cluster, using the previous load balancer
- Helm installed in your Kubernetes cluster
- Prometheus and Grafana installed in Kubernetes in monitoring namespace.
- A namespace called dev to deploy the app inside Kubernetes.

*You could omit the creation of the public IP and load balancer, as those resources would be automatically provisioned for your cluster. But when you provision them in an explicit way, if you later remove the Kubernetes cluster to replace it for a different one, you will maintain the same IP address.*