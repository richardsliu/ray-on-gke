variable "project_id" {
  type         =    string
  description  =    "GCP project id"
}

variable "namespace" {
    type = string
    description = "Kubernetes namespace where resources are deployed"
    default = "ray"
}
