/*
 * Vectorizer job
 */

resource "google_service_account" "vectorizer" {
  account_id   = "vectorizer"
  display_name = "Service Account for Vectorizer job"
}


/*
 * Updater
 */

resource "google_service_account" "updater" {
  account_id   = "updater"
  display_name = "Service Account for updater service"
}

