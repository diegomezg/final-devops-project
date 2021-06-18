resource "helm_release" "helm_chart" {
  create_namespace = true
  name             = var.release_name
  repository       = var.repository
  namespace        = var.ns_name
  chart            = var.chart
}

resource "kubernetes_namespace" "dev" {
  metadata {
    annotations = {
      name = "dev-namespace"
    }

    labels = {
      mylabel = "dev-namespace"
    }

    name = "dev"
  }
}

resource "kubernetes_namespace" "test-demo" {
  metadata {
    annotations = {
      name = "test-demo-namespace"
    }

    labels = {
      mylabel = "test-demo-namespace"
    }

    name = "test-demo"
  }
}