# outputs.tf - Minimal working version
output "vpc_name" {
  value = google_compute_network.main.name
}

output "service_account" {
  value = google_service_account.default.email
}

output "project" {
  value = var.project_id
}