resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# --------------------------
# Management subnet (bastion)
# --------------------------
resource "google_compute_subnetwork" "management" {
  name          = "management-subnet"
  ip_cidr_range = var.management_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id

  private_ip_google_access = true
}

# --------------------------
# Restricted subnet (GKE + CloudSQL)
# --------------------------
resource "google_compute_subnetwork" "restricted" {
  name          = "restricted-subnet"
  ip_cidr_range = var.restricted_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods-range"
    ip_cidr_range = "10.4.0.0/14"
  }

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "10.8.0.0/20"
  }
}


# ---------------------------------------------------
# Private service connection required for Cloud SQL
# ---------------------------------------------------
resource "google_compute_global_address" "private_ip_range" {
  name          = "google-managed-services-${var.project_id}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}


# Allow bastion to access Google APIs (private.googleapis.com)
resource "google_compute_firewall" "bastion_to_google_apis" {
  name    = "bastion-allow-google-apis"
  network = google_compute_network.vpc.name

  direction = "EGRESS"
  priority  = 1000

  destination_ranges = [
    "199.36.153.8/30"
  ]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = ["bastion"]
}


# Allow bastion to access the GKE private control plane
resource "google_compute_firewall" "bastion_to_gke_master" {
  name    = "bastion-allow-gke-master"
  network = google_compute_network.vpc.name

  direction = "EGRESS"
  priority  = 1001

  destination_ranges = [
    "172.16.0.0/28"
  ]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = ["bastion"]
}


resource "google_compute_firewall" "gke_to_cloudsql" {
  name    = "allow-gke-to-cloudsql"
  network = google_compute_network.vpc.name
  project = var.project_id

  direction = "EGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  # GKE Pods + Nodes
  source_ranges = ["10.4.0.0/14"]

  # CloudSQL private IP range
  destination_ranges = ["10.146.0.0/16"]
}


# ---------------------------------------------------
# Static Global IP for the Load Balancer
# ---------------------------------------------------
resource "google_compute_global_address" "lb_ip" {
  name = "challenge-lb-ip"
}




