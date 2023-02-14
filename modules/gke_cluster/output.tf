output "project_id" {
    description = "GCP project id"
    value = resource.google_container_cluster.ml_cluster.project
}

output "region" {
    description = "GCP region"
    value = resource.google_container_cluster.ml_cluster.location
}

output "cluster_name" {
    description = "The name of the GKE cluster"
    value = resource.google_container_cluster.ml_cluster.name 
}

output "kubernetes_host" {
    description = "Kubernetes cluster host"
    value = resource.google_container_cluster.ml_cluster.endpoint
}

output "cluster_certicicate" {
    description = "Kubernetes cluster ca certificate"
    value = base64decode(resource.google_container_cluster.ml_cluster.master_auth[0].cluster_ca_certificate)
    sensitive = true
}
