/*
 * Cloud Storage bucket
 *
 * for embeddings
 */

// https://cloud.google.com/storage/docs/access-control/iam-roles
resource "google_storage_bucket_iam_member" "vectorizer-objectCreator" {
  bucket = var.bucket_name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.vectorizer.email}"
}


/*
 * Updater
 */

// https://cloud.google.com/vertex-ai/docs/general/access-control?hl=ja
resource "google_project_iam_member" "updater-aiplatform-user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.updater.email}"
}


