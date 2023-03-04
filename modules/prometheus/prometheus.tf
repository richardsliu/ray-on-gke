data "local_file" "pod_monitor_yaml" {
  filename = "${path.module}/config/pod_monitor.yaml"
}

data "http" "prometheus_frontend_yaml" {
  url = "https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.5.0/examples/frontend.yaml"
}

data "http" "prometheus_grafana_yaml" {
  url = "https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.5.0/examples/grafana.yaml"
}

resource "kubectl_manifest" "pod_monitor" {
  yaml_body = data.local_file.pod_monitor_yaml.content
}

resource "kubectl_manifest" "prometheus_frontend" {
  yaml_body = replace(data.http.prometheus_frontend_yaml.body, "$PROJECT_ID", var.project_id)
}

resource "kubectl_manifest" "prometheus_grafana" {
  yaml_body = data.http.prometheus_grafana_yaml.body
}
