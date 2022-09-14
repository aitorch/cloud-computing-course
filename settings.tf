
terraform {

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.36.0"
    }
  }
  backend "gcs" {
    bucket = "cloud101-tf-states"
    prefix = "state"
  }
}

provider "google" {
  project = "cloud-comp-101"
}
