data "google_client_config" "provider" {}

data "google_container_cluster" "ml_cluster" {
  name     = var.cluster_name
  location = var.region
  depends_on  = [ module.gke_cluster ]
}

provider "google" {
  project = var.project_id   
  region  = var.region 
}

provider "kubernetes" {
    #config_path = pathexpand("~/.kube/config")
    host =  data.google_container_cluster.ml_cluster.endpoint
    token                  = data.google_client_config.provider.access_token
    cluster_ca_certificate =  base64decode(
        data.google_container_cluster.ml_cluster.master_auth[0].cluster_ca_certificate
    ) 
}

provider "kubectl" {
  ###load_config_file       = false
  host                   = data.google_container_cluster.ml_cluster.endpoint
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
      data.google_container_cluster.ml_cluster.master_auth[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    #config_path = pathexpand("~/.kube/config")
    host =  data.google_container_cluster.ml_cluster.endpoint
    token                  = data.google_client_config.provider.access_token
    cluster_ca_certificate =  base64decode(
        data.google_container_cluster.ml_cluster.master_auth[0].cluster_ca_certificate
    )
  }
}

module "gke_cluster" {
  source    = "./modules/gke_cluster"

  project_id = var.project_id
  region = var.region
}

module "kubernetes" {
  source    = "./modules/kubernetes"

  depends_on = [ module.gke_cluster ]
  region       = var.region
  cluster_name = var.cluster_name
  namespace    = var.namespace
}

module "kuberay" {
  source    = "./modules/kuberay"

  depends_on  = [ module.gke_cluster, module.kubernetes ]
  region       = var.region
  cluster_name = var.cluster_name 
  namespace    = var.namespace
}

module "prometheus" {
  source    = "./modules/prometheus"
  
  depends_on =  [ module.kuberay ]
  project_id = var.project_id
}

module "jupyterhub" {
  source    = "./modules/jupyterhub"

  depends_on = [ module.gke_cluster, module.kubernetes ]
  region        = var.region
  cluster_name  = var.cluster_name
  namespace   = var.namespace
}
