# Cloud DNS Managed Zone (REQUIRED: Cloud DNS)
resource "google_dns_managed_zone" "primary" {
  name        = var.managed_zone_name
  dns_name    = "${var.domain_name}."
  description = "Managed DNS zone for three-tier application"
  visibility  = "public"

  depends_on = [google_project_service.apis["dns.googleapis.com"]]
}

# A record pointing to load balancer
resource "google_dns_record_set" "www" {
  name         = "www.${google_dns_managed_zone.primary.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.primary.name

  rrdatas = [google_compute_global_forwarding_rule.http.ip_address]
}

# Root domain record
resource "google_dns_record_set" "root" {
  name         = google_dns_managed_zone.primary.dns_name
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.primary.name

  rrdatas = [google_compute_global_forwarding_rule.http.ip_address]
}