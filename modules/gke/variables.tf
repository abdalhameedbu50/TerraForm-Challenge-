variable "project_id" {
  description = "GCP project ID"
}

variable "region" {
  description = "GCP region for the GKE cluster"
}



variable "network" {
  description = "Self link of the VPC network"
}

variable "subnet" {
  description = "Self link of the subnet where GKE nodes will run (restricted subnet)"
}



variable "cluster_name" {
  description = "GKE cluster name"
  default     = "challenge-gke"
}

variable "node_machine_type" {
  description = "Machine type for GKE nodes"
  default     = "e2-medium"
}

variable "min_node_count" {
  description = "Minimum number of nodes"
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes"
  default     = 3
}

variable "bastion_cidr" {
  type = string
}

