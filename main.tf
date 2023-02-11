module "gke_cluster" {
  source    = "./modules/gke_cluster"

  project_id = var.project_id
  region = var.region
}

module "kubernetes" {
  source    = "./modules/kuberay"

  region       = var.region
  cluster_name = var.cluster_name
  namespace    = var.namespace
}

module "kuberay" {
  source    = "./modules/kuberay"

  region       = var.region
  cluster_name = var.cluster_name 
  namespace    = var.namespace
}

module "jupyterhub" {
  source    = "./modules/jupyterhub"

  region        = var.region
  cluster_name  = var.cluster_name
  namespace   = var.namespace
}
