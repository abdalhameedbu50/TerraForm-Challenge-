resource "google_container_cluster" "primary" {
  name     = "challenge-gke"
  location = var.region
  project  = var.project_id

  network    = var.network
  subnetwork = var.subnet

  remove_default_node_pool = true
  deletion_protection      = false
  networking_mode          = "VPC_NATIVE"

  # Initial node pool (will be removed immediately)
  initial_node_count = 1

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods-range"
    services_secondary_range_name = "services-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  # Try this format instead
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.bastion_cidr
      display_name = "bastion-mgmt-subnet"
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "challenge-gke-np"
  project  = var.project_id
  location = var.region
  cluster  = google_container_cluster.primary.name

  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    metadata = {
      "disable-legacy-endpoints" = "true"
    }
    tags = ["gke-nodes", "restricted-subnet"]
  }
}