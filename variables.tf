variable "project_id" {}
variable "region" {
  default = "us-central1"
}
variable "zone" {
  default = "us-central1-a"
}

variable "bastion_iam_user" {
  description = "User who can SSH into the Bastion via IAP"
  type        = string
}