# Configuracao dos providers. Os tokens chegam por variavel (terraform.tfvars
# ou variavel de ambiente TF_VAR_hcloud_token), nunca hardcoded aqui.

provider "hcloud" {
  token = var.hcloud_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
