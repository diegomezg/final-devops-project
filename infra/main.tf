provider "azurerm" {
  subscription_id = "c4774376-bc4c-48e6-93eb-c0ac26c6345d"
  client_id       = "82062f05-5c47-4d67-af49-384242e0d83f"
  client_secret   = var.client_secret
  tenant_id       = "c8cd0425-e7b7-4f3d-9215-7e5fa3f439e8"
  #version         = "=2.0.0" #Can be overide as you wish
  features{}
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
#   resource_group_name = var.resource_group_name
#   location            = var.location
# }

module "acr" {
  source              = "./modules/acr"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = module.resource_group.name
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
  resource_group_name = module.resource_group.name
}

module "load_balancer" {
  source               = "./modules/load_balancer"
  public_ip_address_id = module.public_ip.id
  location             = var.location
  prefix               = var.prefix
  resource_group_name  = module.resource_group.name
}

module "public_ip" {
  source              = "./modules/public_ip"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = module.resource_group.name
}
