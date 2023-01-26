terraform {
  backend "gcs" {
    bucket = <your_input> # e.g., "psyops-tfstate"
    prefix = "tfstate"
  }
}