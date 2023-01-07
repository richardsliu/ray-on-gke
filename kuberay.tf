provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.primary.endpoint}"
    token                  = data.google_client_config.default.access_token
  }
}

resource "helm_release" "example" {
  name  = "my-local-chart"
  chart = "./helm"

  depends_on = [
    google_container_cluster.primary
  ]
}