variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kube_config)
  }
}

provider "kubernetes" {
  config_path = pathexpand(var.kube_config)
}

resource "helm_release" "jupyterhub" {
  name       = "jupyterhub"
  repository = "https://jupyterhub.github.io/helm-chart"
  chart      = "jupyterhub"
  namespace  = var.namespace

  values = [
    file("${path.module}/jupyterhub-values.yaml")
  ]
}

