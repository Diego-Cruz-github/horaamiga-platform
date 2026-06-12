# AWS port (portability)

This folder is the AWS equivalent of the live Hetzner stack (`../hetzner`):
same architecture, AWS-native resources. It exists to prove the platform is
cloud-agnostic and to be provisioned on demand (provision, validate, destroy) -
it is not kept running 24/7, for cost reasons (see ADR 0001 and
`docs/architecture/multi-cloud.md`).

| Hetzner (live) | AWS (this port) |
|---|---|
| VPS | EC2 instance |
| Edge firewall | Security Group |
| SSH key resource | aws_key_pair |
| Cloudflare DNS | Cloudflare (kept) or Route 53 |

GCP and Azure follow the same pattern; the AWS port is provided as the
reference implementation.

Usage:

```
terraform init
terraform plan      # review before anything is created
terraform apply     # provisions on AWS (billable - destroy when done)
terraform destroy   # tear down to avoid cost
```
