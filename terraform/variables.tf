# Variaveis de entrada. Os valores reais ficam em terraform.tfvars (NUNCA versionado).
# Tokens sao marcados como sensitive pra nao vazarem no output/log do plan.

variable "hcloud_token" {
  description = "Token da API da Hetzner Cloud (Read/Write)"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_token" {
  description = "Token da API da Cloudflare com permissao de editar DNS da zona"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "ID da zona Cloudflare do dominio"
  type        = string
}

variable "domain" {
  description = "Dominio raiz da plataforma"
  type        = string
  default     = "horaamiga.pt"
}

variable "app_subdomain" {
  description = "Subdominio da aplicacao (PWA + API)"
  type        = string
  default     = "app"
}

variable "server_name" {
  description = "Nome do servidor na Hetzner"
  type        = string
  default     = "horaamiga-prod"
}

variable "server_type" {
  description = "Tipo da VM Hetzner. cx22 = 2 vCPU / 4GB. Redimensionar conforme a observabilidade mostrar uso real (rightsizing)."
  type        = string
  default     = "cx22"
}

variable "server_location" {
  description = "Datacenter. Alemanha (nbg1/fsn1) para manter os dados na UE (GDPR)."
  type        = string
  default     = "nbg1"
}

variable "server_image" {
  description = "Imagem base do servidor"
  type        = string
  default     = "ubuntu-24.04"
}

variable "ssh_public_key_path" {
  description = "Caminho da chave SSH publica que tera acesso ao servidor"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "admin_ip" {
  description = "IP autorizado a acessar SSH (porta 22). Restringe o acesso administrativo em vez de abrir pra internet inteira."
  type        = string
}
