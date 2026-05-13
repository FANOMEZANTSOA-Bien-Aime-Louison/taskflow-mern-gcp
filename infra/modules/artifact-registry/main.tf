resource "google_artifact_registry_repository" "repo" {
  provider = google

  location      = var.region
  repository_id = var.repository_name
  description   = "Docker repository for Taskflow MERN backend"
  format        = "DOCKER"
}