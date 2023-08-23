/*
 * Cloud Storage bucket
 *
 * for embeddings
 */

resource "google_storage_bucket" "flowers" {
  name                        = "${var.bucket_name}"
  location                    = "us-central1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

