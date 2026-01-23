project_id  = "aas-metroc-project"
region      = "us-central1"
environment = "prod"
domain_name = "three-tier-app.com"

# Update this with your actual IP address
allowed_ips = ["0.0.0.0/0"]

# Instance counts
web_min_instances = 2
web_max_instances = 5
app_min_instances = 2
app_max_instances = 5

# Machine types
web_machine_type = "e2-small"
app_machine_type = "e2-small"

# Cloud SQL
db_tier          = "db-custom-1-3840"
db_instance_name = "three-tier-db"

# Cloud Run
cloud_run_service_name = "app-backend"

# VPC
vpc_name = "three-tier-vpc"