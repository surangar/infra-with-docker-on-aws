provider "aws" {
  default_tags {
    tags = {
      ManageBy = "Terraform"
    }
  }
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}