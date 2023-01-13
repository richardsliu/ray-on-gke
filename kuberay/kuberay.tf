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

resource "helm_release" "kuberay-operator" {
  name       = "kuberay-operator"
  chart      = "./kuberay-operator"
}

resource "helm_release" "ray-cluster" {
  name	     = "example-cluster"
  chart      = "./ray-cluster"
}
