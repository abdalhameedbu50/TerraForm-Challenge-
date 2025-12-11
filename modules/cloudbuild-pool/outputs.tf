output "worker_pool_name" {
  value = google_cloudbuild_worker_pool.private_pool.name
}

output "worker_pool_location" {
  value = var.region
}
