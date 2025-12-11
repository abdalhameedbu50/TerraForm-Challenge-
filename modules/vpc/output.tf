output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "management_subnet" {
  value = google_compute_subnetwork.management.id
}

output "restricted_subnet" {
  value = google_compute_subnetwork.restricted.id
}

output "restricted_subnet_self_link" {
  value = google_compute_subnetwork.restricted.self_link
}


output "vpc_self_link" {
  value = google_compute_network.vpc.self_link
}

output "management_subnet_self_link" {
  value = google_compute_subnetwork.management.self_link
}


output "private_ip_range_name" {
  value = google_compute_global_address.private_ip_range.name
}

