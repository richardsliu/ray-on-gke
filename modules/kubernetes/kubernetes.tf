resource "kubernetes_namespace" "ml" {
  metadata {
    name = var.namespace
  }
}
