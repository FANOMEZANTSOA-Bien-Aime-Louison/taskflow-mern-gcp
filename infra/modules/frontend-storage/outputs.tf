output "frontend_bucket_name" {
  value = google_storage_bucket.frontend_bucket.name
}

output "frontend_ip" {
  value       = google_compute_global_address.frontend_ip.address
  description = "IP à pointer dans Cloudflare (enregistrement A)"
}

output "frontend_cdn_url" {
  value = "https://${var.domain}"
}
