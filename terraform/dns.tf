# Registros DNS na Cloudflare apontando os dominios pro servidor.
# proxied = true faz o trafego passar pela Cloudflare (CDN + WAF + esconde o IP
# de origem). E o que coloca a protecao na frente da aplicacao.

# Dominio raiz -> servidor (site institucional).
resource "cloudflare_record" "root" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "A"
  content = hcloud_server.prod.ipv4_address
  proxied = true
  comment = "Site institucional - gerenciado por Terraform"
}

# www -> servidor.
resource "cloudflare_record" "www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  type    = "A"
  content = hcloud_server.prod.ipv4_address
  proxied = true
}

# Subdominio da aplicacao (PWA + API).
resource "cloudflare_record" "app" {
  zone_id = var.cloudflare_zone_id
  name    = var.app_subdomain
  type    = "A"
  content = hcloud_server.prod.ipv4_address
  proxied = true
  comment = "PWA + API - gerenciado por Terraform"
}
