variable "gke_num_nodes" {
  default     = 3
  description = "number of gke nodes"
}

provider "google" {
  project = var.project_id
  region  = var.region
}


# GKE cluster
resource "google_container_cluster" "ml_cluster" {
  name     = var.cluster_name
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
    managed_prometheus {
      enabled = "true"
    }
  }
}

resource "google_container_node_pool" "gpu_pool" {
  name       = google_container_cluster.ml_cluster.name
  location   = var.region
  cluster    = google_container_cluster.ml_cluster.name
  node_count = var.gke_num_nodes

  autoscaling {
    min_node_count = "1"
    max_node_count = "5"
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    image_type   = "cos_containerd"
    machine_type = "a2-highgpu-1g"
    tags         = ["gke-node", "${var.project_id}-gke"]

    disk_size_gb = "30"
    disk_type    = "pd-standard"

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
