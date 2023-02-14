resource "helm_release" "kuberay-operator" {
  name       = "kuberay-operator"
  chart      = "${path.module}/kuberay-operator"
}

resource "helm_release" "ray-cluster" {
  name	     = "example-cluster"
  chart      = "${path.module}/ray-cluster"
  namespace  = var.namespace
}
