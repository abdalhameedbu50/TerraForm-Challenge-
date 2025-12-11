##############################################
# Private Cloud Build Worker Pool
##############################################

resource "google_cloudbuild_worker_pool" "private_pool" {
  name         = var.worker_pool_name
  location     = var.region
  project      = var.project_id
  display_name = "Challenge Private Worker Pool"

  # VMs that run your builds
  worker_config {
    machine_type   = "e2-medium"
    disk_size_gb   = 100
    # keep external IPs allowed to avoid NAT complexity
    # set to true + NAT if later you want no internet
    no_external_ip = false
  }

  # Attach worker pool to your VPC
  network_config {
    # expects: projects/PROJECT_ID/global/networks/NETWORK_NAME
    peered_network = "projects/${var.project_id}/global/networks/${var.vpc_network}"
  }
}

##############################################
# IAM for Cloud Build service account
##############################################

resource "google_project_iam_member" "cloudbuild_sa_roles" {
  for_each = toset([
    "roles/container.developer",       # use kubectl / GKE
    "roles/artifactregistry.writer",   # push images
    "roles/logging.logWriter",         # write logs
    "roles/monitoring.metricWriter",   # write metrics
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${var.cloudbuild_sa}"
}
