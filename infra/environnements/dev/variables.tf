variable "project_name" {
  type = string
}

variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "vpc_cidr" {
  type = string
}

variable "gke_subnet_cidr" {
  type = string
}