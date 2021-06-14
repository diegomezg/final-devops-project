variable "prefix" {
  description = "A prefix used for all resources in this example"
  default     = "teamthree"
  type        = string
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  default     = "CentralUS"
  type        = string
}


variable "client_id" {
  description = "Service Principal client id"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Service Principal client secret (password)"
  type        = string
  sensitive   = true
}


variable "node_count" {
  description = "Number of nodes for the Kubernetes cluster"
  default     = 1
  type        = number
}

variable "vm_size" {
  description = "VM size for each node"
  default     = "Standard_DS2_v2"
  type        = string
}

variable "os_disk_size_gb" {
  description = "VM disk size in Gb"
  default     = 40
  type        = number
}

variable "resource_group_name" {
  description = "Resource Group Name"
  default     = "diego-gomez"
  type        = string
}