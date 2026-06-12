# Provider configuration. Credentials come from the environment
# (AWS_PROFILE / AWS_ACCESS_KEY_ID), never hardcoded.

provider "aws" {
  region = var.aws_region

  # Every resource created by this stack carries these tags - the AWS way of
  # answering "what is this and who owns it" (and filtering costs in billing).
  default_tags {
    tags = {
      Project   = "horaamiga"
      ManagedBy = "terraform"
      Purpose   = "portability-port"
    }
  }
}
