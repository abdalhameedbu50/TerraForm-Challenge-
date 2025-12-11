variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "vpc_network" {
  type        = string
  description = "Name of the VPC network (e.g. challenge-vpc)"
}

variable "worker_pool_name" {
  type    = string
  default = "challenge-build-pool"
}

variable "cloudbuild_sa" {
  type        = string
  description = "Cloud Build service account email"
}
