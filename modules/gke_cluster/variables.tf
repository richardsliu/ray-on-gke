variable "project_id" {
    type = string
    description = "GCP project id"
    default = "ricliu-gke-dev"
}

variable "region" {
    type = string
    description = "GCP project region or zone"
    default = "us-central1"
}

variable "cluster_name" {
    type = string
    description = "GKE cluster name"
    default = "ml-cluster"
}

variable "namespace" {
    type = string
    description = "Kubernetes namespace where resources are deployed"
    default = "ray"
}
