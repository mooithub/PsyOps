# Define the Google Cloud Composer environment
resource "google_composer_environment" "psyops_composer_environment" {
  project = var.project_id
  name = var.namespace
  region = var.region

  config {
    software_config {
      image_version = "composer-1-airflow-2"
    }
  }
}

