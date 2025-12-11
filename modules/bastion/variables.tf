variable "project_id" {}
variable "region" {}
variable "zone" {}

variable "network" {}
variable "subnet" {}

variable "bastion_name" {
  default = "bastion-host"
}

variable "bastion_iam_user" {
  description = "User who can access Bastion via IAP SSH"
}
