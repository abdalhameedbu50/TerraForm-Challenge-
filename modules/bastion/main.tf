##############################################
# Bastion Host – No Public IP, IAP Only SSH
##############################################


data "google_compute_image" "bastion_image" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}

# ----------------------------------------------------------
# Bastion Compute Instance
# ----------------------------------------------------------
resource "google_compute_instance" "bastion" {
  name         = var.bastion_name
  machine_type = "e2-medium"
  zone         = var.zone
  project      = var.project_id

  

   allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = data.google_compute_image.bastion_image.self_link
    }
  }

  # Internal-only NIC — no public IP
  network_interface {
    subnetwork = var.subnet
   
  }

  # Enable OS Login for secure access
  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    email  = "default"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

# ----------------------------------------------------------
# Firewall Rule – Allow SSH ONLY through IAP
# ----------------------------------------------------------
resource "google_compute_firewall" "allow_iap" {
  name    = "allow-iap-ssh"
  network = var.network
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Google IAP Proxy IP Range official Google range
  source_ranges = ["35.235.240.0/20"]
}