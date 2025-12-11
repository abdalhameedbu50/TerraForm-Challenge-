variable "project_id" {}
variable "region" {}
variable "vpc_name" {
  default = "challenge-vpc"
}

variable "management_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "restricted_subnet_cidr" {
  default = "10.0.2.0/24"
}
