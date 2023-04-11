# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

data "google_client_config" "provider" {}

data "google_container_cluster" "ml_cluster" {
  name       = var.cluster_name
  location   = var.region
  depends_on = [module.gke_cluster]
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  host  = data.google_container_cluster.ml_cluster.endpoint
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.ml_cluster.master_auth[0].cluster_ca_certificate
  )
}

provider "kubectl" {
  host  = data.google_container_cluster.ml_cluster.endpoint
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.ml_cluster.master_auth[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    ##config_path = pathexpand("~/.kube/config")
    host  = data.google_container_cluster.ml_cluster.endpoint
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.ml_cluster.master_auth[0].cluster_ca_certificate
    )
  }
}

module "gke_cluster" {
  source = "./modules/gke_cluster"

  project_id = var.project_id
  region     = var.region
}

module "kubernetes" {
  source = "./modules/kubernetes"

  depends_on   = [module.gke_cluster]
  region       = var.region
  cluster_name = var.cluster_name
}

module "kuberay" {
  source = "./modules/kuberay"

  depends_on   = [module.kubernetes]
  region       = var.region
  cluster_name = var.cluster_name
}
