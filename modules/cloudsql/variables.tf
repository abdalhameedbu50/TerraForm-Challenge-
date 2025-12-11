variable "project_id" {}
variable "region" {}

variable "vpc_self_link" {
  description = "Self link of the VPC to attach private IP to"
}

variable "instance_name" {
  description = "Cloud SQL instance name"
  default     = "mysql-cloudsql"
}

variable "db_name" {
  description = "Application database name"
  default     = "webapp_db"
}

variable "db_user" {
  description = "Database username"
  default     = "appuser"
}
