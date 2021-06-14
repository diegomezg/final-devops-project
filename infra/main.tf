provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "helm" {
  kubernetes {
    host                   = module.aks.host
    client_key             = module.aks.client_key
    client_certificate     = module.aks.client_certificate
    cluster_ca_certificate = module.aks.cluster_ca_certificate
  }
}

terraform {
  backend "azurerm" {
    resource_group_name  = "diego-gomez"
    storage_account_name = "team3demodou"
    container_name       = "tstate"
    key                  = "prod.terraform.tfstate"
  }
}


# module "resource_group" {
#   source              = "./modules/resource_group"
#   resource_group_name = "diego-gomez"
#   location            = var.location
# }

module "acr" {
  source              = "./modules/acr"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = "diego-gomez"
}

module "aks" {
  source              = "./modules/aks"
  prefix              = var.prefix
  location            = var.location
  client_id           = var.client_id
  client_secret       = var.client_secret
  node_count          = var.node_count
  vm_size             = var.vm_size
  os_disk_size_gb     = var.os_disk_size_gb
  resource_group_name = "diego-gomez"
}

module "helm" {
  source                 = "./modules/helm"
  prefix                 = var.prefix
  location               = var.location
  client_id              = var.client_id
  client_secret          = var.client_secret
  node_count             = var.node_count
  resource_group_name    = "diego-gomez"
}

module "load_balancer" {
  source               = "./modules/load_balancer"
  public_ip_address_id = module.public_ip.id
  location             = var.location
  prefix               = var.prefix
  resource_group_name  = "diego-gomez"
}

module "public_ip" {
  source              = "./modules/public_ip"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = "diego-gomez"
}
