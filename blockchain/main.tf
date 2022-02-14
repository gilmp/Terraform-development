####################################################################################
#   Account / State setup
####################################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
}
}
provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "local" {
    path = "relative/path/to/terraform.tfstate"
  }
}

