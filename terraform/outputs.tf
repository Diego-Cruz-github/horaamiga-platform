# Saidas uteis apos o apply. O IP do servidor alimenta o inventory do Ansible
# (a etapa seguinte: Terraform cria a VM, Ansible configura por dentro).

output "server_ipv4" {
  description = "IP publico do servidor de producao"
  value       = hcloud_server.prod.ipv4_address
}

output "server_status" {
  description = "Status atual do servidor"
  value       = hcloud_server.prod.status
}
