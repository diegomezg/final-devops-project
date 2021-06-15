# Digital On Us Demo Project TEAM 3
## Teamates:
### Daniel Flores | Diego Gómez | Paulo Mateos | Martín Salazar

## Project Background
There is a company that had build its e-commerce aplication using microservices solutions and deployed them on many VMs that are consuming many resources (infrastructure and billing) so we developed this solution to integrate, automate, accelerate and protect the application deployment and infrastructure using CI/CD tools Git for version control and branching model, Azure Repositories to host the source code, Azure Pipelines to run automated processes based on Azure Cloud Provider and its services using Kubernetes for running microservices on an isolated environment and Terraform for Infrastructure as Code.

## Infrastructure
![Infrastructure diagram](/documentation/img/infra-diagram.png)
This project uses a [demo e-commerce app](https://github.com/GoogleCloudPlatform/microservices-demo)  
# Falta describir el key vault

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

## Tools and Justification

## Usage
* Prerequisitos
* Como correrlo
* Que debe existir al correrlo (que obtengo / resultado)
Azure CLI must be use to generate backend credentials
Aram:
puedes describir en detalle la arquitectura de tu solucion e ilustrar como funciona, requerimientos de la misma e instrucciones concretas para hacer que funcione
Paulo:
Que tecnologías vamos a usar y porque
Usage de nuestra infra