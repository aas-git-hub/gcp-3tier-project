variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "aas-metroc-project"
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "zones" {
  description = "GCP Zones for high availability"
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b", "us-central1-c"]
}

variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
  default     = "prod"
}

# VPC Configuration
variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "three-tier-vpc"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.100.0.0/16"
}

# Subnet Configuration
variable "web_subnet_cidrs" {
  description = "Web Tier Subnet CIDRs"
  type        = list(string)
  default     = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
}

variable "app_subnet_cidrs" {
  description = "App Tier Subnet CIDRs"
  type        = list(string)
  default     = ["10.100.11.0/24", "10.100.12.0/24", "10.100.13.0/24"]
}

variable "db_subnet_cidr" {
  description = "Database Subnet CIDR"
  type        = string
  default     = "10.100.21.0/24"
}

# Compute Configuration
variable "web_machine_type" {
  description = "Web Tier Machine Type"
  type        = string
  default     = "e2-medium"
}

variable "app_machine_type" {
  description = "App Tier Machine Type"
  type        = string
  default     = "e2-standard-2"
}

# Database Configuration (REQUIRED: Cloud SQL)
variable "db_instance_name" {
  description = "Cloud SQL Instance Name"
  type        = string
  default     = "three-tier-db"
}

variable "db_version" {
  description = "Database Version"
  type        = string
  default     = "MYSQL_8_0"
}

variable "db_tier" {
  description = "Database Tier"
  type        = string
  default     = "db-custom-1-3840"
}

# DNS Configuration (REQUIRED: Cloud DNS)
variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "three-tier-app.com"
}

variable "managed_zone_name" {
  description = "Cloud DNS Managed Zone name"
  type        = string
  default     = "three-tier-zone"
}

# Load Balancer Configuration (REQUIRED: Cloud Load Balancing)
variable "lb_name" {
  description = "Load Balancer name"
  type        = string
  default     = "three-tier-lb"
}

# Cloud Run Configuration (REQUIRED: Cloud Run Functions as Backend)
variable "cloud_run_service_name" {
  description = "Cloud Run Service Name"
  type        = string
  default     = "app-backend"
}

# Security Configuration
variable "allowed_ips" {
  description = "Allowed IP ranges for access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Auto-scaling Configuration
variable "web_min_instances" {
  description = "Minimum web tier instances"
  type        = number
  default     = 2
}

variable "web_max_instances" {
  description = "Maximum web tier instances"
  type        = number
  default     = 10
}

variable "app_min_instances" {
  description = "Minimum app tier instances"
  type        = number
  default     = 2
}

variable "app_max_instances" {
  description = "Maximum app tier instances"
  type        = number
  default     = 10
}