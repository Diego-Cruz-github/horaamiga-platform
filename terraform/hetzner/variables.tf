# Input variables. Real values live in terraform.tfvars (NEVER committed).
# Tokens are marked sensitive so they do not leak into plan output/logs.

variable "hcloud_token" {
  description = "Hetzner Cloud API token (Read/Write)"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token with DNS edit permission on the zone"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID for the domain"
  type        = string
}

variable "domain" {
  description = "Root domain of the platform"
  type        = string
  default     = "horaamiga.pt"
}

variable "app_subdomain" {
  description = "Application subdomain (PWA + API)"
  type        = string
  default     = "app"
}

variable "server_name" {
  description = "Server name on Hetzner"
  type        = string
  default     = "horaamiga-prod"
}

variable "server_type" {
  description = "Hetzner VM type. cx22 = 2 vCPU / 4GB. Resize as observability shows real usage (rightsizing)."
  type        = string
  default     = "cx22"
}

variable "server_location" {
  description = "Datacenter. Germany (nbg1/fsn1) to keep data in the EU (GDPR)."
  type        = string
  default     = "nbg1"
}

variable "server_image" {
  description = "Base server image"
  type        = string
  default     = "ubuntu-24.04"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key that will have access to the server"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "admin_ip" {
  description = "IP allowed to reach SSH (port 22). Restricts admin access instead of opening it to the whole internet."
  type        = string
}
