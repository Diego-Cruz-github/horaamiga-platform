# EC2 instance - the AWS equivalent of the Hetzner VPS.

# SSH key registered on AWS and injected at boot (same flow as hcloud_ssh_key).
resource "aws_key_pair" "admin" {
  key_name   = "horaamiga-admin"
  public_key = file(var.ssh_public_key_path)
}

# Latest Ubuntu 24.04 LTS image (Canonical's official account), resolved
# dynamically so the port does not pin a stale AMI id.
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_instance" "prod" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.admin.key_name
  vpc_security_group_ids = [aws_security_group.web.id]

  root_block_device {
    volume_size = 40    # GB - mirrors the Hetzner disk
    volume_type = "gp3"
  }

  tags = {
    Name = "horaamiga-prod"
  }
}

# From here the flow is identical to Hetzner: the Ansible playbook in
# ../../ansible takes this IP and configures the server - same roles, no changes.
# That is the point of the port: only the provisioning layer changes.
