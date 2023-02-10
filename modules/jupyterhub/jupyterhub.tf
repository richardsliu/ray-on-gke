variable "host" {
  type          =   string
  description   =   "Kubernetes cluster endpoint"
}

variable "token" {
  type          =   string
  description   =   "Kubernetes cluster token"
}

variable "ca_certificate" {
  type         =    string
  description  =    "Kubernetes cluster ca certificate"
}

provider "helm" {
  kubernetes {
    host      = var.host
    token     = var.token
    cluster_ca_certificate  = var.ca_certificate
  }
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

