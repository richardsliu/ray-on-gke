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

variable "namespace" {
    type = string
    description = "Kubernetes namespace where resources are deployed"
    default = "ray"
}
