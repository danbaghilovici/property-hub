provider "aws" {
  region = "eu-central-1"
  default_tags {
    tags = {
      Environment = terraform.workspace
      Owner       = "prop-hub"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-prop-hub"
    key            = "prop-hub-application/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-prop-hub"
  }

}
