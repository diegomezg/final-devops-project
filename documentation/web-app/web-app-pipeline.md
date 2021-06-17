## Prerequisites
- Verify all Terraform resources were sucessfully created on last pipeline  
- Create an [Azure DevOps Service Connection](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml), this allow to connect Azure Cloud resources to Azure DevoPS solutions

## Fork the Hipster Shop repository
Fork the [Web App](https://dev.azure.com/diegogomez0768/Final%20Project/_git/Web%20App) from Azure Repos:

 ## After the repo is forked, you must change the ip located in the script.js file:

![Test](../img/test-ip.png)

## Now you must create new pipeline 

 ![new pipeline](../img/create-pipeline-gui.png)

Select azure repo

![new pipeline](../img/repo-git.png)  

Select the repo you had fork  

![new pipeline](../img/select-repo.png)  

Select Existing Azure Pipeline

![new pipeline](../img/existing-pipeline.png)  

Select pipeline yaml file

![new pipeline](../img/pipe-file.png)  

And push CREATE button

## After this the yaml file will be displayed on Azure Pipelines text editor

![new pipeline](../img/text.png) 

### The last step before your first pipeline RUN is to create some Azure Pipelines variables, from the last pipeline you must have an Azure Container Registry credentials just as:
* SKAFFOLD_DEFAULT_REPO  
This is your ACR repository URL, something just like myACR.azurecr.io
* ACR_USER  
User to access at your ACR
* ACR_PASSWORD  
Password to access at your ACR  
>*Note: This variables must be marked as SECRETS to hide values from other users*

Now you only need to *RUN* (A new commit to the selected branch will be added) your pipeline and all the microservices images will be builded and pushed to your ACR then will be deployed to your AKS cluster  

A new job should be created and finished sucessfully.

![new pipeline](../img/end-pipe.png) 

** Everything in (azure-pipelines.yml)[../azure-pipelines.yml] is made using Azure Pipelines Tasks, you can see this menu on a side bar next to text editor, feel free to use them for improvements