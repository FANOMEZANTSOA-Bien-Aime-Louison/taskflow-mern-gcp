terraform {
  backend "gcs" {
    bucket = "tfstate-model-nexus-mern-dev-001"
    prefix = "dev"
  }
}