# Network: the Security Group mirrors the Hetzner edge firewall rule-for-rule.
# Uses the default VPC to keep the port lean (a dedicated VPC + subnets would be
# the production evolution; not needed to validate portability).

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "web" {
  name        = "horaamiga-web"
  description = "Mirror of the Hetzner edge firewall: 22 admin-only, 80/443 open"
  vpc_id      = data.aws_vpc.default.id

  # SSH restricted to the admin IP.
  ingress {
    description = "SSH (admin only)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.admin_ip}/32"]
  }

  # HTTP - redirect to HTTPS only.
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS - real application traffic.
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound open (default posture for a web server pulling packages/updates).
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
