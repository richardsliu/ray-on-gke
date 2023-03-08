terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.56.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.18.1"
    }
  }
}
