# Input variables. Real values go in terraform.tfvars (never committed).

variable "aws_region" {
  description = "AWS region. eu-central-1 (Frankfurt) keeps data in the EU, mirroring the Hetzner choice (GDPR)."
  type        = string
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "EC2 instance size. t3.small (2 vCPU / 2GB) is the closest small-server equivalent."
  type        = string
  default     = "t3.small"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key that will access the instance"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "admin_ip" {
  description = "IP allowed to reach SSH (port 22) - same least-exposure rule as the Hetzner firewall"
  type        = string
}
