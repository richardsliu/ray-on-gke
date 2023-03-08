resource "google_service_account" "sa" {
  account_id   = "${var.namespace}-gmp-account"
  display_name = "Managed prometheus service account"
}

resource "google_service_account_iam_binding" "workload-identity-user" {
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/default]",
  ]
}

resource "google_project_iam_binding" "monitoring-viewer" {
  project = "${var.project_id}"
  role    = "roles/monitoring.viewer"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/default]",
  ]
}

resource "kubernetes_annotations" "default" {
  api_version = "v1"
  kind        = "ServiceAccount"
  metadata {
    name = "default"
  }
  annotations = {
    "iam.gke.io/gcp-service-account" = "${google_service_account.sa.account_id}@${var.project_id}.iam.gserviceaccount.com"
  }
}
