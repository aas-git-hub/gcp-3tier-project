# cloudrun.tf - Cloud Run Service
# Cloud Run Service - FIXED: Changed from api_backend to api
resource "google_cloud_run_service" "api" {
  name     = var.cloud_run_service_name
  location = var.region

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"

        ports {
          container_port = 8080
        }

        # REMOVE DB references for now - they cause circular dependencies
        # We'll add these later after database is created
        # env {
        #  name  = "PORT"
        #  value = "8080"
        # }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [
    google_project_service.apis["run.googleapis.com"]
  ]
}

# Allow internal access only
resource "google_cloud_run_service_iam_member" "internal_access" {
  location = google_cloud_run_service.api.location
  project  = google_cloud_run_service.api.project
  service  = google_cloud_run_service.api.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.default.email}"
}

# VPC Connector - Comment out for now to avoid dependencies
# resource "google_vpc_access_connector" "connector" {
#   name          = "cloud-run-connector"
#   region        = var.region
#   network       = google_compute_network.main.name
#   ip_cidr_range = "10.100.200.0/28"
#   
#   depends_on = [google_project_service.apis["vpcaccess.googleapis.com"]]
# }