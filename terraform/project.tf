resource "google_project" "project" {
  name            = var.project_name
  project_id      = var.project_id
  billing_account = var.project_billing_account
  skip_delete     = true
}

# Enable Google services on the project
resource "google_project_service" "project_service_compute" {
  project                    = var.project_id
  service                    = "compute.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    google_project.project
  ]
}

resource "google_project_service" "project_service_iam" {
  project                    = var.project_id
  service                    = "iam.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    google_project.project
  ]
}

resource "google_project_service" "project_service_logging" {
  project                    = var.project_id
  service                    = "logging.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    google_project.project
  ]
}

resource "google_project_service" "project_service_monitoring" {
  project                    = var.project_id
  service                    = "monitoring.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    google_project.project
  ]
}

resource "google_project_service" "project_service_stackdriver" {
  project                    = var.project_id
  service                    = "stackdriver.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    google_project.project
  ]
}

resource "google_compute_project_default_network_tier" "default" {
  project      = var.project_id
  network_tier = "STANDARD"
}