/*
 * Vectorizer job
 */

resource "google_artifact_registry_repository" "vectorizer" {
  location      = "us-central1"
  repository_id = "vectorizer"
  format        = "DOCKER"

}



/*
 * Updater
 */

resource "google_artifact_registry_repository" "updater" {
  location      = "us-central1"
  repository_id = "updater"
  format        = "DOCKER"

}

