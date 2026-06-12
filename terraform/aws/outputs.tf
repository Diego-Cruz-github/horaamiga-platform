# Outputs - the instance IP feeds the same Ansible inventory used for Hetzner.

output "server_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.prod.public_ip
}

output "ami_used" {
  description = "Ubuntu AMI resolved for this region"
  value       = data.aws_ami.ubuntu.id
}
