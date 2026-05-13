# ============================================
# Service Account pour le node pool
# ============================================
resource "google_service_account" "gke_sa" {
  account_id   = "${var.project_name}-gke-sa"
  display_name = "GKE Node Pool Service Account"
  project      = var.project_id
}

# Droit de lire les images Artifact Registry
resource "google_project_iam_member" "gke_sa_artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

# Droits de base pour GKE (logs, monitoring)
resource "google_project_iam_member" "gke_sa_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

resource "google_project_iam_member" "gke_sa_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

# ============================================
# Cluster GKE
# ============================================
resource "google_container_cluster" "gke_cluster" {
  name     = "${var.project_name}-gke"
  location = "${var.region}-b"

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.vpc_name
  subnetwork = var.subnet_name

  deletion_protection = false
}

# ============================================
# Node Pool
# ============================================
resource "google_container_node_pool" "primary_nodes" {
  name     = "${var.project_name}-node-pool"
  location = google_container_cluster.gke_cluster.location
  cluster  = google_container_cluster.gke_cluster.name

  node_count = 1

  node_config {
    machine_type = "e2-standard-2"
    disk_size_gb = 20
    disk_type    = "pd-standard"

    # ← Ajouter le service account ici
    service_account = google_service_account.gke_sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}