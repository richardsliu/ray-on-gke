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

output "project_id" {
  description = "GCP project id"
  value       = resource.google_container_cluster.ml_cluster.project
}

output "region" {
  description = "GCP region"
  value       = resource.google_container_cluster.ml_cluster.location
}

output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = resource.google_container_cluster.ml_cluster.name
}

output "kubernetes_host" {
  description = "Kubernetes cluster host"
  value       = resource.google_container_cluster.ml_cluster.endpoint
}

output "cluster_certicicate" {
  description = "Kubernetes cluster ca certificate"
  value       = base64decode(resource.google_container_cluster.ml_cluster.master_auth[0].cluster_ca_certificate)
  sensitive   = true
}
