##############################################
# Cloud SQL – MySQL with Private IP Only
##############################################

# Generate a strong random password for the DB user
resource "random_password" "db_password" {
  length  = 20
  special = true
}

# Store DB password in Secret Manager (best practice)
resource "google_secret_manager_secret" "db_password" {
  project   = var.project_id
  secret_id = "mysql-db-password"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db_password.result
}

# Cloud SQL instance (MySQL, private IP only)
resource "google_sql_database_instance" "mysql" {
  name             = var.instance_name
  project          = var.project_id
  region           = var.region
  database_version = "MYSQL_8_0"

  deletion_protection = false  # easier for labs/sandbox

  settings {
    tier = "db-f1-micro"       # small & cheap; adjust if needed

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_self_link
    }

    backup_configuration {
      enabled = true
    }
  }
}

# Application database
resource "google_sql_database" "appdb" {
  name     = var.db_name
  instance = google_sql_database_instance.mysql.name
}

# Application DB user
resource "google_sql_user" "appuser" {
  name     = var.db_user
  instance = google_sql_database_instance.mysql.name
  password = random_password.db_password.result
}
