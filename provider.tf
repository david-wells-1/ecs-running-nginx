terraform {
  required_version = "~>1.17.0"

  backend "local" {}
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Name = var.name
    }
  }
}