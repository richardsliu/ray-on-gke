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


data "local_file" "wait_gcs_ready_yaml" {
  filename = "${path.module}/config/wait-gcs-ready.yaml"
}

resource "kubectl_manifest" "wait_gcs_ready_configmap" {
  override_namespace = var.namespace
  yaml_body          = data.local_file.wait_gcs_ready_yaml.content
}

resource "helm_release" "ray-cluster" {
  name       = "example-cluster"
  repository = "https://ray-project.github.io/kuberay-helm/"
  chart      = "ray-cluster"
  namespace  = var.namespace
  values = [
    file("${path.module}/kuberay-values.yaml")
  ]
}
