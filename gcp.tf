data "google_compute_zones" "available" {
  region = var.cloud_location[var.location].gcp
  status = "UP"
}

resource "google_compute_instance" "vm" {
  count        = local.gcp ? 1 : 0
  name         = var.name
  machine_type = local.instance_type[var.instance_size][local.cloud]
  zone         = data.google_compute_zones.available.names[0]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  network_interface {
    network    = var.vpc_id
    subnetwork = var.subnet_id
    access_config {
      // Ephemeral IP
    }
  }
  metadata = {
    user-data = local.user_data
  }
}

resource "google_compute_firewall" "vm" {
  count   = local.gcp ? 1 : 0
  name    = format("%s-%s", var.name, var.environment)
  network = var.vpc_id
  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
  source_ranges = ["0.0.0.0/0"]
}
