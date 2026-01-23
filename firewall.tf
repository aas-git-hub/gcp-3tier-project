# firewall.tf - Corrected Security Rules
# 1. Allow HTTP/HTTPS from internet to web tier
resource "google_compute_firewall" "allow_http" {
  name    = "${var.vpc_name}-allow-http-https"
  network = google_compute_network.main.name

  allow {
     protocol = "tcp"
     ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
  direction     = "INGRESS"
  priority      = 1000
}

# 2. Allow SSH for management
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.vpc_name}-allow-ssh"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.allowed_ips
  target_tags   = ["web"]
  direction     = "INGRESS"
  priority      = 1000
}

# 3. Allow all internal traffic within VPC
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.vpc_name}-allow-internal"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [var.vpc_cidr]
  direction     = "INGRESS"
  priority      = 65534
}

# 4. Allow Cloud SQL access
resource "google_compute_firewall" "allow_sql" {
  name    = "${var.vpc_name}-allow-sql"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  source_ranges = ["10.100.0.0/16"]
  direction     = "INGRESS"
  priority      = 1000
}

# 5. Allow health checks from Google
resource "google_compute_firewall" "allow_health_check" {
  name    = "${var.vpc_name}-allow-health-check"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["web"]
  direction     = "INGRESS"
  priority      = 1000
}