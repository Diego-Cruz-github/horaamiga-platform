# Provider configuration. Tokens arrive via variables (terraform.tfvars or the
# TF_VAR_hcloud_token environment variable), never hardcoded here.

provider "hcloud" {
  token = var.hcloud_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
