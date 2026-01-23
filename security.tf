# Minimal security.tf - Just Cloud Armor
resource "google_compute_security_policy" "armor_policy" {
  name = "aas-metroc-armor-policy"

  rule {
    action   = "allow"
    priority = 2147483647
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default allow rule"
  }
}