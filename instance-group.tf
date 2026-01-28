# Instance Group Manager for web tier
resource "google_compute_instance_group_manager" "web" {
  name               = "${var.project_id}-web-mig"
  base_instance_name = "web-instance"
  zone               = var.zone
  target_size        = var.web_min_instances  # Use variable instead of hardcoded 1
  
  version {
    instance_template = google_compute_instance_template.web.id
  }
  
  named_port {
    name = "http"
    port = 80
  }
  
  # Add auto-healing
  auto_healing_policies {
    health_check      = google_compute_health_check.web_health_check.id
    initial_delay_sec = 300
  }
}

# ADD THIS NEW RESOURCE for auto-scaling
resource "google_compute_autoscaler" "web_autoscaler" {
  name   = "${var.project_id}-web-autoscaler"
  zone   = var.zone
  target = google_compute_instance_group_manager.web.id
  
  autoscaling_policy {
    max_replicas    = var.web_max_instances
    min_replicas    = var.web_min_instances
    cooldown_period = 60
    
    cpu_utilization {
      target = 0.7
    }
  }
}