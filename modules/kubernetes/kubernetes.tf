data "http" "nvidia_driver_installer_manifest" {
  url = "https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-preloaded.yaml"
}


resource "kubectl_manifest" "nvidia_driver_installer" {
  yaml_body = data.http.nvidia_driver_installer_manifest.body
}

resource "kubernetes_namespace" "ml" {
  metadata {
    name = var.namespace
  }
}
