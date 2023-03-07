data "http" "nvidia_driver_installer_manifest" {
  url = "https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-preloaded.yaml"
}

data "local_file" "fluentd_config_yaml" {
  filename = "${path.module}/config/fluentd_config.yaml"
}

resource "kubectl_manifest" "nvidia_driver_installer" {
  yaml_body = data.http.nvidia_driver_installer_manifest.response_body
}

resource "kubernetes_namespace" "ml" {
  metadata {
    name = var.namespace
  }
}

resource "kubectl_manifest" "fluentd_config" {
  override_namespace = var.namespace
  yaml_body = data.local_file.fluentd_config_yaml.content
}
