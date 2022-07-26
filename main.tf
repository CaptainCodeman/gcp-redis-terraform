provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_disk" "redis_data" {
  name = "redis-data"
  size = 10
  type = "pd-balanced"
}

resource "google_compute_address" "redis" {
  address_type = "EXTERNAL"
  name         = "redis"
  network_tier = "PREMIUM"
}

resource "google_compute_instance" "redis" {
  name         = "redis"
  machine_type = "e2-micro"

  tags = ["redis"]

  attached_disk {
    device_name = "redis-data"
    source      = google_compute_disk.redis_data.name
  }

  boot_disk {
    device_name = "redis-boot"
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.redis.address
    }
  }

  metadata = {
    google-logging-enabled    = "true"
    gce-container-declaration = replace(file("./container.yaml"), "PASSWORD", var.password)
    user-data                 = file("./cloud-init.yaml")
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  scheduling {
    on_host_maintenance = "MIGRATE"
    automatic_restart   = true
  }
}

resource "google_compute_firewall" "rules" {
  name        = "redis"
  network     = "default"
  description = "Allow access to redis"

  allow {
    protocol = "tcp"
    ports    = ["6379"]
  }

  target_tags   = ["redis"]
  source_ranges = ["0.0.0.0/0"]
}