# Cloudflare DNS records pointing the domains at the server.
# proxied = true routes traffic through Cloudflare (CDN + WAF + hides the
# origin IP). This is what puts the protection in front of the application.

# Root domain -> server (institutional website).
resource "cloudflare_record" "root" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "A"
  content = hcloud_server.prod.ipv4_address
  proxied = true
  comment = "Institutional website - managed by Terraform"
}

# www -> server.
resource "cloudflare_record" "www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  type    = "A"
  content = hcloud_server.prod.ipv4_address
  proxied = true
}

# Application subdomain (PWA + API).
resource "cloudflare_record" "app" {
  zone_id = var.cloudflare_zone_id
  name    = var.app_subdomain
  type    = "A"
  content = hcloud_server.prod.ipv4_address
  proxied = true
  comment = "PWA + API - managed by Terraform"
}
