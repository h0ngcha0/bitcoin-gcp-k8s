locals {
  node_pool_ingress_tag = "cluster-ingress"
}

resource "google_container_cluster" "cluster" {
  project = var.project_id
  name = "bitcoin-full-node"
  min_master_version = "latest"

  location = var.zone

  remove_default_node_pool = true
  initial_node_count = 1
  enable_legacy_abac = true

  master_auth {
    # Disables basic auth
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  depends_on = [
    "google_project_service.project_service_compute",
    "google_project_service.project_service_iam",
    "google_project_service.project_service_logging",
    "google_project_service.project_service_monitoring",
    "google_project_service.project_service_stackdriver"
  ]
}

resource "google_container_node_pool" "bitcoin_nodes_01" {
  project = var.project_id
  name = "bitcoin-node-pool-01"
  cluster = google_container_cluster.cluster.name
  location = var.zone

  initial_node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  node_config {
    preemptible = false
    machine_type = var.kubernetes_node_pool_machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      preemptible-node = "false"
    }

    tags = [local.node_pool_ingress_tag]

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  management {
    auto_repair = true
  }

  depends_on = [
    "google_container_cluster.cluster"
  ]
}
