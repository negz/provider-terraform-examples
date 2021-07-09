variable "location" {
  type    = string
  default = "US"
}

output "url" {
  value = google_storage_bucket.example.self_link
}

resource "google_storage_bucket" "example" {
  name     = terraform.workspace
  location = var.location
}

provider "google" {
  credentials = "gcp-credentials.json"
  project     = "crossplane-playground"
}

terraform {
  backend "gcs" {
    bucket      = "crossplane-example-tf"
    prefix      = "provider-terraform/default"
    credentials = "gcp-credentials.json"
  }
}
