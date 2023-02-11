data "terraform_remote_state" "gke" {
  backend = "local"

  config = {
    path = "../gke_cluster/terraform.tfstate"
  }
}

# Retrieve GKE cluster information
provider "google" {
  project = data.terraform_remote_state.gke.outputs.project_id
  region  = data.terraform_remote_state.gke.outputs.region
}


data "google_client_config" "provider" {}

data "google_container_cluster" "my_cluster" {
  name     = data.terraform_remote_state.gke.outputs.cluster_name
  location = data.terraform_remote_state.gke.outputs.region
}

provider "helm" {
  kubernetes {
    host = data.terraform_remote_state.gke.outputs.kubernetes_host

    token                  = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
  }
}

resource "helm_release" "kuberay-operator" {
  name       = "kuberay-operator"
  chart      = "./kuberay-operator"
}

resource "helm_release" "ray-cluster" {
  name	     = "example-cluster"
  chart      = "./ray-cluster"
  namespace  = var.namespace
}
