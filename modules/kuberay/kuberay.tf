provider "helm" {
  kubernetes {
    host      = var.host
    token     = var.token
    cluster_ca_certificate  = var.ca_certificate
}

resource "helm_release" "kuberay-operator" {
  name       = "kuberay-operator"
  chart      = "./kuberay-operator"
}

resource "helm_release" "ray-cluster" {
  name	     = "example-cluster"
  chart      = "./ray-cluster"
  namespace  = var.namespace
}
