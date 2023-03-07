data "local_file" "pod_monitor_yaml" {
  filename = "${path.module}/config/pod_monitor.yaml"
}

data "http" "frontend_deployment" {
  url = "https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.5.0/examples/frontend.yaml"
}

data "http" "grafana_deployment" {
  url = "https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.5.0/examples/grafana.yaml"
}

data "local_file" "frontend_service" {
  filename = "${path.module}/config/frontend.yaml"
}

data "local_file" "grafana_service" {
  filename = "${path.module}/config/grafana.yaml"
}

resource "kubectl_manifest" "pod_monitor" {
  override_namespace = var.namespace
  yaml_body = data.local_file.pod_monitor_yaml.content
}

resource "kubectl_manifest" "prometheus_frontend" {
  override_namespace = var.namespace
  yaml_body = replace(data.http.frontend_deployment.response_body, "$PROJECT_ID", var.project_id)
}

resource "kubectl_manifest" "prometheus_grafana" {
  override_namespace = var.namespace
  yaml_body = data.http.grafana_deployment.response_body
}

resource "kubectl_manifest" "prometheus_frontend_service" {
  override_namespace = var.namespace
  yaml_body = data.local_file.frontend_service.content
}

resource "kubectl_manifest" "prometheus_grafana_service" {
  override_namespace = var.namespace
  yaml_body = data.local_file.grafana_service.content
}
