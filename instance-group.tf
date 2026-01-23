# Instance Group Manager for web tier
resource "google_compute_instance_group_manager" "web" {
  name               = "web-instance-group"
  base_instance_name = "web-instance"
  zone               = "us-central1-a"
  target_size        = 1  # Start with 1 instance
  
  version {
    instance_template = google_compute_instance_template.web.id
  }
  
  named_port {
    name = "http"
    port = 80
  }
}