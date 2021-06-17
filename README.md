# Digital On Us Demo Project TEAM 3
## Teamates:
### Daniel Flores | Diego Gómez | Paulo Mateos | Martín Salazar

## Project Background
There is a company that had build its e-commerce aplication using microservices solutions and deployed them on many VMs that are consuming many resources (infrastructure and billing) so we developed this solution to integrate, automate, accelerate and protect the application deployment and infrastructure using CI/CD tools Git for version control and branching model, Azure Repositories to host the source code, Azure Pipelines to run automated processes based on Azure Cloud Provider and its services using Kubernetes for running microservices on an isolated environment and Terraform for Infrastructure as Code.

## Infrastructure
![Infrastructure diagram](/documentation/img/infra-diagram.png)
This project uses a [demo e-commerce app](https://github.com/GoogleCloudPlatform/microservices-demo)  

The terraform code deploys on Azure the resources that are going to be used including Azure Container Registry, Azure Kubernetes Service and a Backend Container. Once the AKS is created it will install helm and host a monitoring namespace where a Prometheus and Grafana agent will be deployed.  

Skaffold feature requires the present project to integrate the Kubernetes manifests which are the deployment task responsible through the Azure Kubernetes Service (AKS). Those Kubernetes manifests check for the micro-service features as containers, images, resources utilization as well as the kind of service they gonna be use.  

Skaffold agent code builds docker images, uploads images to Azure Container Registry and pulls images to be deployed on Azure Resources. Also create pods on a namespace within the cluster and provides a Public IP where the frontend application will be displayed.  

### Pipelines  
#### Infrastructure  
![Infrastructure pipeline diagram](/documentation/img/diagram-infra.png)
This pipelines is triggered when a new commit is uploaded to Deployment-App reposiroty hosted on Azure Repos also use a task to connect to Azure CLI to provide resources and credentials 
* Terraform Installation 
Provide to pipeline agent latest Terraform version
* Terraform Init task  
Validation of backend state and verifies Tf providers are correctly called
* Terraform Plan  
Display which changes are going to be applied on resources
* Terraform Apply  
Apply changes specified on Tf Plan stage and upload infrastructure
#### Web Application  
![Web App pipeline diagram](/documentation/img/diagram-web-app.png)
This pipelines is triggered when a new commit is uploaded to Web App reposiroty hosted on Azure Repos also use a task to connect to Azure CLI to provide resources and credentials  
* Skaffold installation   
Provide to pipeline agent latest Skaffold version
* Skaffold run  
Build, upload and deploy images to Kubernetes cluster
* Performance test  
Run k6 load-test to determine system behaviour under both normal and anticipated peak load conditions. It helps to identify maximum operating capacity of the application as well as any bottlenecks and determine which element is causing degradation.  

## Technologies justification
We decided to make the infrastructure on a cloud because on-premise datacenters are becoming obsoletes because they are very expensive, requires more people to maintain the physical machines and are exposed to no break issues. In other hand a cloud infrastructure offers a more reliable, flexible and affordable solution.

We used Azure Cloud because is the cloud where we have more experience, also Microsoft has made it one of the most reliable cloud solutions offering some of the best resources like Azure Devops, Azure Kubernetes Service (AKS), Azure Container Registry (ACR), etc. Where you can have all the resources in the same environment and it's easier to handle them, for example you can store your secrets in a key vault and it can be accessed easily form anywhere inside the Azure environment.

Using some features of Azure Devops like Azure Repos and Azure Pipelines we were able to extract most of the benefits that it offers like an easier integration of the repos with our pipelines without the need of using any tool outside of the Azure environment, also sensitive data can be stored in environment variables so it can be available inside the pipelines without hardcoding them. This can be very helpful because you will not have any issues importing a repo from outside and also if you have any problem the Azure documentation is very complete and friendly. 

For the Infrastructure as Code (IaC) we used Terraform because is a tool for building, changing, and versioning infrastructure safely and efficiently. In this case it was helpful for automate the creation of the infrastructure resources and to have a control of everything that has been build so every change made can be tracked and safely released. In case of Disaster Recovery scenario you can just change of resource group, create a new service principal and build again the infrastructure with the Terraform code.

For the Kubernetes package manager we decided to use Helm because it has a big community that is always updating and making new charts to offer an easier way to manage applications in Kubernetes. For this project we use Helm to install Prometheus and Grafana for monitoring the app inside the cluster. These tools are one of the best combo options for monitoring because both are open source and while Prometheus is a robust tool that stores and queries data, Grafana complements visualizing this data so it is possible to identify issues quickly, also this tool can provide you with dashboards that you can personalize to show all the data you want.

We decided to use Skaffold because is an innovating tool that is growing everyday and compared to Docker Compose it's more friendly and oriented to Kubernetes. Skaffold offers a variety of benefits for example when you run the Skaffold yaml file it builds the images based on the dockerfile code, then uploads them to a container in this case Azure Container Registry (ACR), then it pulls them to the Kubernetes cluster and deploys them in different pods. For the containers we used Docker because is the most common and used container tool in the industry and it's easier to use it with Skaffold than any other tool.

## Usage  
### Contents

* [1. Infrastructure CI/CD](./documentation/infrastructure/infra-pipeline.md)
* [2. Web App CI/CD](./documentation/web-app/web-app-pipeline.md)  

* Como correrlo
* Que debe existir al correrlo (que obtengo / resultado)
Azure CLI must be use to generate backend credentials

Aram:
puedes describir en detalle la arquitectura de tu solucion e ilustrar como funciona, requerimientos de la misma e instrucciones concretas para hacer que funcione
Paulo:
Que tecnologías vamos a usar y porque
Usage de nuestra infra