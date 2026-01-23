# database.tf - Cloud SQL Database
# Private IP allocation for Cloud SQL
resource "google_compute_global_address" "private_ip_address" {
  name          = "sql-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main.id

  depends_on = [google_project_service.apis["servicenetworking.googleapis.com"]]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.main.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]

  depends_on = [google_project_service.apis["servicenetworking.googleapis.com"]]
}

# Cloud SQL Instance - FIXED NAME: main
resource "google_sql_database_instance" "main" {
  name             = var.db_instance_name
  database_version = var.db_version
  region           = var.region

  deletion_protection = false

  settings {
    tier              = var.db_tier
    availability_type = "ZONAL"
    disk_size         = 20
    disk_type         = "PD_SSD"
    disk_autoresize   = true

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.main.id
    }

    backup_configuration {
      enabled    = true
      start_time = "02:00"
    }
  }

  depends_on = [
    google_service_networking_connection.private_vpc_connection
  ]
}

# Database - FIXED NAME: app_db
resource "google_sql_database" "app_db" {
  name     = "app_database"
  instance = google_sql_database_instance.main.name
}

# Database User - FIXED NAME: app_user
resource "random_password" "db_password" {
  length = 16
}

resource "google_sql_user" "app_user" {
  name     = "app_user"
  instance = google_sql_database_instance.main.name
  password = random_password.db_password.result
}