/*
 * Compute Engine instance
 */
resource "google_compute_instance" "query-runner" {
  name         = "query-runner"
  machine_type = "n1-standard-2"
  zone         = "us-central1-b"

  boot_disk {
    initialize_params {
      size  = "20"
      type  = "pd-balanced"
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.flowers-search.name
    subnetwork = google_compute_subnetwork.us-central1.name

    access_config {}
  }

  metadata_startup_script = file("./startup.sh")

  service_account {
    email  = var.svc_accnt
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_firewall" "allow-internal" {
  name          = "flower-search-allow-internal"
  network       = google_compute_network.flowers-search.name
  priority      = 65534
  source_ranges = ["10.128.0.0/9"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
}

resource "google_compute_firewall" "allow-ssh" {
  name          = "flower-search-allow-ssh"
  network       = google_compute_network.flowers-search.name
  priority      = 65534
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
