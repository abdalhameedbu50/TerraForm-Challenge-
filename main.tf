module "vpc" {
  source = "./modules/vpc"

  project_id = var.project_id
  region     = var.region
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = module.vpc.vpc_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [module.vpc.private_ip_range_name]
}



module "bastion" {
  source = "./modules/bastion"

  project_id       = var.project_id
  region           = var.region
  zone             = var.zone
  network          = module.vpc.vpc_self_link
  subnet           = module.vpc.management_subnet_self_link
  bastion_iam_user = var.bastion_iam_user
}





resource "google_project_iam_member" "bastion_iap" {
  project = var.project_id
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "user:${var.bastion_iam_user}"
}

resource "google_project_iam_member" "bastion_oslogin" {
  project = var.project_id
  role    = "roles/compute.osLogin"
  member  = "user:${var.bastion_iam_user}"
}



module "cloudsql" {
  source = "./modules/cloudsql"

  project_id    = var.project_id
  region        = var.region
  vpc_self_link = module.vpc.vpc_self_link



   depends_on = [
    google_service_networking_connection.private_vpc_connection
  ]

  
}


module "gke" {
  source     = "./modules/gke"
  project_id = var.project_id
  region     = var.region   

  network = module.vpc.vpc_self_link
  subnet  = module.vpc.restricted_subnet_self_link

  bastion_cidr = "10.0.1.0/24"
}




module "cloudbuild_pool" {
  source = "./modules/cloudbuild-pool"

  project_id    = var.project_id
  vpc_network   = "challenge-vpc"  # this is the VPC NAME
  cloudbuild_sa = "cloudbuild-sa@${var.project_id}.iam.gserviceaccount.com"
}


