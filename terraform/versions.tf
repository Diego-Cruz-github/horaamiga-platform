# Terraform and provider versions.
# Pinning versions prevents a future "terraform init" from pulling a newer
# release that breaks syntax. Mandatory practice for production infrastructure.

terraform {
  required_version = ">= 1.6"

  required_providers {
    # Hetzner Cloud provider (provisions server, firewall, ssh key).
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45" # ~> pins the major: accepts 1.45.x..1.x, never jumps to 2.0
    }

    # Cloudflare provider (manages the DNS records for the domains).
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}
