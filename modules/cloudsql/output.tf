output "instance_connection_name" {
  description = "Cloud SQL instance connection name"
  value       = google_sql_database_instance.mysql.connection_name
}

output "private_ip_address" {
  description = "Private IP of the Cloud SQL instance"
  value       = google_sql_database_instance.mysql.private_ip_address
}

output "db_name" {
  value = google_sql_database.appdb.name
}

output "db_user" {
  value = google_sql_user.appuser.name
}

output "db_password_secret_id" {
  description = "Secret Manager ID where DB password is stored"
  value       = google_secret_manager_secret.db_password.id
}
