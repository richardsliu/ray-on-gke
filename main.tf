module "gke_cluster" {
  source    = "./modules/gke_cluster"

  project_id = var.project_id
  region = var.region
}

module "kuberay" {
  source    = "./modules/kuberay"

  host         = module.gke_cluster.host
  token        = module.gke_cluster.token
  ca_certificate = module.gke_cluster.ca_certificate
  namespace    = var.namespace
}

module "jupyterhub" {
  source    = "./modules/jupyterhub"

  host         = module.gke_cluster.host
  token        = module.gke_cluster.token
  ca_certificate = module.gke_cluster.ca_certificate
  namespace   = var.namespace
}
