/*
 * Network
 */

resource "google_compute_network" "flowers-search" {
  name                    = "flowers-search"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"

}

// https://cloud.google.com/vpc/docs/subnets#ip-ranges
resource "google_compute_subnetwork" "us-central1" {
  name          = "us-central1"
  ip_cidr_range = "10.128.0.0/20"
  region        = "us-central1"
  network       = google_compute_network.flowers-search.id
}

resource "google_compute_global_address" "psa-alloc" {
  name          = "psa-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.flowers-search.id
}

resource "google_service_networking_connection" "psa" {
  network                 = google_compute_network.flowers-search.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.psa-alloc.name]

}

