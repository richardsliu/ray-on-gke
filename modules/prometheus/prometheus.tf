data "local_file" "pod_monitor_yaml" {
  filename = "${path.module}/config/pod_monitor.yaml"
}

data "local_file" "frontend_deployment" {
  filename = "${path.module}/config/frontend-deployment.yaml"
}

data "local_file" "grafana_deployment" {
  filename = "${path.module}/config/grafana-deployment.yaml"
}

data "local_file" "frontend_service" {
  filename = "${path.module}/config/frontend-service.yaml"
}

data "local_file" "grafana_service" {
  filename = "${path.module}/config/grafana-service.yaml"
}

resource "kubectl_manifest" "pod_monitor" {
  override_namespace = var.namespace
  yaml_body = data.local_file.pod_monitor_yaml.content
}

resource "kubectl_manifest" "prometheus_frontend" {
  override_namespace = var.namespace
  yaml_body = replace(data.local_file.frontend_deployment.content, "$PROJECT_ID", var.project_id)
}

resource "kubectl_manifest" "prometheus_grafana" {
  override_namespace = var.namespace
  yaml_body = data.local_file.grafana_deployment.content
}

resource "kubectl_manifest" "prometheus_frontend_service" {
  override_namespace = var.namespace
  yaml_body = data.local_file.frontend_service.content
}

resource "kubectl_manifest" "prometheus_grafana_service" {
  override_namespace = var.namespace
  yaml_body = data.local_file.grafana_service.content
}
