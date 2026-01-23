# Cloud Storage bucket for shared content
resource "google_storage_bucket" "shared_assets" {
  name          = "${var.project_id}-shared-assets"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true

  cors {
    origin          = ["https://${var.domain_name}"]
    method          = ["GET", "HEAD", "PUT", "POST"]
    response_header = ["*"]
    max_age_seconds = 3600
  }

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}

# Make bucket publicly readable (adjust for production)
resource "google_storage_bucket_iam_member" "public_read" {
  bucket = google_storage_bucket.shared_assets.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}