# Servidor de producao + firewall na borda da Hetzner.
# Isto codifica a infra que hoje existe na Hetzner, tornando-a reproduzivel:
# em vez de configurar na mao, "terraform apply" recria o servidor do zero.

# Chave SSH cadastrada na conta Hetzner e injetada no servidor no boot.
resource "hcloud_ssh_key" "admin" {
  name       = "horaamiga-admin"
  public_key = file(var.ssh_public_key_path)
}

# Firewall aplicado na borda (antes do trafego chegar na VM).
# Principio: abrir o minimo. 80/443 pro mundo (site/app), 22 so pro admin.
resource "hcloud_firewall" "web" {
  name = "horaamiga-fw"

  # SSH restrito ao IP do admin (nao expor 22 pra internet inteira).
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["${var.admin_ip}/32"]
  }

  # HTTP - so existe pra redirecionar pra HTTPS (Nginx faz o 301).
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  # HTTPS - o trafego real da aplicacao.
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

# A VM em si.
resource "hcloud_server" "prod" {
  name        = var.server_name
  server_type = var.server_type
  location    = var.server_location
  image       = var.server_image

  ssh_keys     = [hcloud_ssh_key.admin.id]
  firewall_ids = [hcloud_firewall.web.id]

  # Backups automaticos da Hetzner (snapshot da VM inteira).
  # Complementa o backup logico de dados feito por cron no servidor.
  backups = true

  labels = {
    project     = "horaamiga"
    environment = "production"
    managed_by  = "terraform"
  }
}
