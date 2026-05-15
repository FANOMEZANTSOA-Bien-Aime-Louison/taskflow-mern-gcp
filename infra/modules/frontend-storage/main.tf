resource "google_storage_bucket" "frontend_bucket" {
  name          = "${var.project_name}-frontend"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true

  # IMPORTANT: pas de website config en production CDN
  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
}
resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.frontend_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
