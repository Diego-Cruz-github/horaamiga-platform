# Production server + edge firewall on Hetzner.
# This codifies the infrastructure that exists today, making it reproducible:
# instead of hand-configuring, "terraform apply" recreates the server from scratch.

# SSH key registered on the Hetzner account and injected into the server at boot.
resource "hcloud_ssh_key" "admin" {
  name       = "horaamiga-admin"
  public_key = file(var.ssh_public_key_path)
}

# Firewall applied at the edge (before traffic reaches the VM).
# Principle: open the minimum. 80/443 to the world (site/app), 22 admin-only.
resource "hcloud_firewall" "web" {
  name = "horaamiga-fw"

  # SSH restricted to the admin IP (do not expose 22 to the whole internet).
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["${var.admin_ip}/32"]
  }

  # HTTP - exists only to redirect to HTTPS (Nginx does the 301).
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # HTTPS - the application's real traffic.
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

# The VM itself.
resource "hcloud_server" "prod" {
  name        = var.server_name
  server_type = var.server_type
  location    = var.server_location
  image       = var.server_image

  ssh_keys     = [hcloud_ssh_key.admin.id]
  firewall_ids = [hcloud_firewall.web.id]

  # Hetzner automated backups (full VM snapshots).
  # Complements the logical data backup done by cron on the server.
  backups = true

  labels = {
    project     = "horaamiga"
    environment = "production"
    managed_by  = "terraform"
  }
}
