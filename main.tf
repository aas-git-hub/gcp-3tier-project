# Health Check
resource "google_compute_health_check" "lb" {
  name = "lb-health-check"
  
  http_health_check {
    port_specification = "USE_SERVING_PORT"
    request_path       = "/health"
  }
}

# Backend Service with instance group
resource "google_compute_backend_service" "web" {
  name        = "web-backend-service"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30
  
  # CRITICAL: This connects to the instance group
  backend {
    group = google_compute_instance_group_manager.web.instance_group
  }
  
  health_checks = [google_compute_health_check.lb.id]
}

# URL Map
resource "google_compute_url_map" "default" {
  name            = "three-tier-url-map"
  default_service = google_compute_backend_service.web.id
}

# Target HTTP Proxy
resource "google_compute_target_http_proxy" "default" {
  name    = "http-proxy"
  url_map = google_compute_url_map.default.id
}

# Global Forwarding Rule
resource "google_compute_global_forwarding_rule" "http" {
  name       = "http-forwarding-rule"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
}