terraform {
  backend "gcs" {
    bucket = <your_info> # e.g., "psyops-vtx-me-tfstate"
    prefix = "tfstate"
  }
}