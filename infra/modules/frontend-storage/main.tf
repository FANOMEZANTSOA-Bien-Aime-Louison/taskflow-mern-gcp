
# ─── Bucket GCS ───────────────────────────────────────────
resource "google_storage_bucket" "frontend_bucket" {
  name          = "${var.project_name}-frontend"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true

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

# ─── Backend Bucket pour Load Balancer ────────────────────
resource "google_compute_backend_bucket" "frontend_backend" {
  name        = "${var.project_name}-frontend-backend"
  bucket_name = google_storage_bucket.frontend_bucket.name
  enable_cdn  = true

  cdn_policy {
    cache_mode        = "CACHE_ALL_STATIC"
    default_ttl       = 3600
    max_ttl           = 86400
    client_ttl        = 3600
    serve_while_stale = 86400

    cache_key_policy {
      include_http_headers = ["Origin"]
    }
  }
}

# ─── Adresse IP externe statique ──────────────────────────
resource "google_compute_global_address" "frontend_ip" {
  name = "${var.project_name}-frontend-ip"
}

# ─── URL Map ──────────────────────────────────────────────
resource "google_compute_url_map" "frontend_url_map" {
  name            = "${var.project_name}-frontend-url-map"
  default_service = google_compute_backend_bucket.frontend_backend.id

  # Règle SPA : tout renvoie vers index.html
  host_rule {
    hosts        = [var.domain]
    path_matcher = "frontend-paths"
  }

  path_matcher {
    name            = "frontend-paths"
    default_service = google_compute_backend_bucket.frontend_backend.id

    path_rule {
      paths   = ["/static/*", "/assets/*"]
      service = google_compute_backend_bucket.frontend_backend.id
    }
  }
}

# ─── URL Map HTTP → HTTPS redirect ────────────────────────
resource "google_compute_url_map" "http_redirect" {
  name = "${var.project_name}-http-redirect"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

# ─── Certificat SSL Google Managed ────────────────────────
resource "google_compute_managed_ssl_certificate" "frontend_cert" {
  name = "${var.project_name}-frontend-cert"

  managed {
    domains = [var.domain]
  }
}

# ─── HTTPS Proxy ──────────────────────────────────────────
resource "google_compute_target_https_proxy" "frontend_https_proxy" {
  name             = "${var.project_name}-frontend-https-proxy"
  url_map          = google_compute_url_map.frontend_url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.frontend_cert.id]
}

# ─── HTTP Proxy (redirect) ────────────────────────────────
resource "google_compute_target_http_proxy" "frontend_http_proxy" {
  name    = "${var.project_name}-frontend-http-proxy"
  url_map = google_compute_url_map.http_redirect.id
}

# ─── Forwarding Rules ─────────────────────────────────────
resource "google_compute_global_forwarding_rule" "frontend_https" {
  name       = "${var.project_name}-frontend-https"
  target     = google_compute_target_https_proxy.frontend_https_proxy.id
  port_range = "443"
  ip_address = google_compute_global_address.frontend_ip.address
}

resource "google_compute_global_forwarding_rule" "frontend_http" {
  name       = "${var.project_name}-frontend-http"
  target     = google_compute_target_http_proxy.frontend_http_proxy.id
  port_range = "80"
  ip_address = google_compute_global_address.frontend_ip.address
}
