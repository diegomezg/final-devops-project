provider "helm" {
  kubernetes {
    host                   = "${var.host}"
    client_certificate     = "${var.client_certificate}"
    client_key             = "${var.client_key}"
    cluster_ca_certificate = "${var.cluster_ca_certificate}"
  }
}

resource "helm_release" "helm_chart" {
  create_namespace = true
  name             = var.release_name
  repository       = var.repository
  namespace        = var.ns_name
  chart            = var.chart
}