output "project" {
    value = google_composer_environment.psyops_composer_environment.project
}

output "gke_cluster" {
    value = google_composer_environment.psyops_composer_environment.config.0.gke_cluster
}

output "dag_gcs_prefix" {
    value = google_composer_environment.psyops_composer_environment.config.0.dag_gcs_prefix
}

output "airflow_uri" {
    value = google_composer_environment.psyops_composer_environment.config.0.airflow_uri
}

output "svc_accnt" {
    value = google_composer_environment.psyops_composer_environment.config.0.node_config.0.service_account
}