variable "prefix" {
  description = "A prefix used for all resources in this example"
  type = string
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  type = string
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type = string
}

variable "client_id" {
  description = "Service Principal client id"
  type = string
}

variable "client_secret" {
  description = "Service Principal client secret (password)"
  type = string
}

variable "node_count" {
  description = "Number of nodes for the Kubernetes cluster"
  type = number
}

variable "host" {
    description = "Kubernetes host"
    type = string
}

variable "client_key" {
    description = "Kubernetes client_key"
    type = string
}

variable "client_certificate" {
    description = "Kubernetes client_certificate"
    type = string
}

variable "cluster_ca_certificate" {
    description = "cluster_ca_certificate"
    type = string
}

variable "ns_name" {
  type        = string
  default     = "monitoring"
  description = "Namespace name for prometheus and grafana"
}

variable "chart" {
  type        = string
  default     = "kube-prometheus-stack"
  description = "Chart name"
}


variable "repository" {
  type        = string
  default     = "https://prometheus-community.github.io/helm-charts"
  description = "Repository name"
}

variable "release_name" {
  type        = string
  default     = "prometheus"
  description = "Helm release name"
}