# Useful outputs after apply. The server IP feeds the Ansible inventory
# (next step: Terraform creates the VM, Ansible configures the inside).

output "server_ipv4" {
  description = "Public IP of the production server"
  value       = hcloud_server.prod.ipv4_address
}

output "server_status" {
  description = "Current server status"
  value       = hcloud_server.prod.status
}
