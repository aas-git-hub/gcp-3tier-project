terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "google" {
  project = "aas-metroc-project"  # Use Project ID, not number
  region  = "us-central1"
  zone    = "us-central1-a"
}

provider "random" {}
