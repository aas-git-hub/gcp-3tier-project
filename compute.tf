# Web Tier Instance Template ONLY
resource "google_compute_instance_template" "web" {
  name_prefix  = "web-template-"
  description  = "Web tier instance template (serves static + proxies to Cloud Run)"
  machine_type = var.web_machine_type

  # Add proper tags for firewall rules
  tags = ["web"]

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
    disk_size_gb = 20
  }

  network_interface {
    network    = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.web[0].id

    access_config {
      # Ephemeral IP
    }
  }

  metadata = {
    startup-script = <<-EOF
      #!/bin/bash
      apt-get update
      apt-get install -y nginx
      
      # Create health check endpoint
      mkdir -p /var/www/html
      echo "OK" > /var/www/html/health
      
      # Get Cloud Run URL (we'll use a placeholder for now)
      CLOUD_RUN_URL="https://${var.cloud_run_service_name}-api-12345-uc.a.run.app"
      
      # Configure nginx
      cat > /etc/nginx/sites-available/default <<'NGINX_CONFIG'
      server {
          listen 80;
          root /var/www/html;
          index index.html;
          
          location / {
              try_files $uri $uri/ =404;
          }
          
          location /api/ {
              proxy_pass $CLOUD_RUN_URL;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
          }
          
          location /health {
              return 200 "healthy\n";
              add_header Content-Type text/plain;
          }
      }
      NGINX_CONFIG
      
      systemctl enable nginx
      systemctl restart nginx
    EOF
  }

  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }

  lifecycle {
    create_before_destroy = true
  }
}