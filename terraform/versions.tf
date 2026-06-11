# Versoes do Terraform e dos providers.
# Travar versao evita que um "terraform init" futuro puxe uma versao nova que
# quebre a sintaxe. Pratica obrigatoria em infra de producao.

terraform {
  required_version = ">= 1.6"

  required_providers {
    # Provider da Hetzner Cloud (provisiona servidor, firewall, ssh key).
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45" # ~> trava o major: aceita 1.45.x ate 1.x, nao pula pra 2.0
    }

    # Provider da Cloudflare (gerencia os registros DNS dos dominios).
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}
