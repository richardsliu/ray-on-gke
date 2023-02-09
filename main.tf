module "gke" {
  source    = "./modules/gke"

  project_id = var.project_id
  region = var.region
}

module "kuberay" {
  source    = "./modules/kuberay"

  namespace    = var.namespace
}

module "jupyterhub" {
  source    = "./modules/jupyterhub"

  namespace   = var.namespace
}
