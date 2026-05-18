module "network" {
  source = "../../modules/network"

  project_name    = var.project_name
  project_id      = var.project_id
  region          = var.region
  vpc_cidr        = var.vpc_cidr
  gke_subnet_cidr = var.gke_subnet_cidr
}

module "artifact_registry" {
  source = "../../modules/artifact-registry"

  project_id      = var.project_id
  region          = var.region
  repository_name = "mern-backend-repo"
}

module "frontend_storage" {
  source = "../../modules/frontend-storage"

  project_name = var.project_name
  region       = var.region
  domain       = "taskflow.fblouison.com"
}

module "gke" {
  source = "../../modules/gke"

  project_id   = var.project_id
  project_name = var.project_name
  region       = var.region

  vpc_name    = module.network.vpc_name
  subnet_name = module.network.subnet_name
}
