variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "domain" {
  type        = string
  description = "Domaine frontend ex: taskflow.fblouison.com"
  default     = "taskflow.fblouison.com"
}
