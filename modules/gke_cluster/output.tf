output "host" {
  description   =   "Kubernetes cluster endpoint"
  value         =   "https://${data.google_container_cluster.ml_cluster.endpoint}"
  sensitive     =   true
}

output "token" {
  description  =    "Kubernetes cluster token"
  value        =    data.google_client_config.provider.access_token
  sensitive    =    true
}

output "ca_certificate" {
  description  =    "Kubernetes cluster ca certificate"
  value        =    base64decode(
    data.google_container_cluster.ml_cluster.master_auth[0].cluster_ca_certificate,
  )
  sensitive    =    true
}
