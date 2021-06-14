# resource "azurerm_kubernetes_cluster" "example" {

#   name                = "${var.prefix}-k8s"
#   location            = "${var.location}"  
#   resource_group_name = "${var.resource_group_name}"
#   dns_prefix          = "${var.prefix}-k8s"

#   agent_pool_profile {
#     name            = "agentpool"
#     count           = "${var.node_count}"
#     vm_size         = "${var.vm_size}"
#     os_type         = "Linux"
#     os_disk_size_gb = "${var.os_disk_size_gb}"
#   }

#   service_principal {
#     client_id     = "${var.client_id}"
#     client_secret = "${var.client_secret}"
#   }
  
#   tags = {
#     Environment = "Development"
#     Creator = "Terraform"
#   }

# }
//NEW VERSION
resource "azurerm_kubernetes_cluster" "example" {
  name                = "${var.prefix}-k8s"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  dns_prefix          = "demoaks1"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Development"
  }
}

# output "client_certificate" {
#   value = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
# }

# output "kube_config" {
#   value = azurerm_kubernetes_cluster.example.kube_config_raw
# }
