terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
 backend "s3" {
    bucket = "12358974opi"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }


}



provider "aws" {
  region = "ap-south-1"
  access_key = "AKIA5XGPLQYQAQTQSO4O"
  secret_key = "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"
}


  # backend "s3" {
  #   bucket                  = "jay2"
  #   key                     = "terraform.tfstate"
  #   region                  = "ap-south-1"
  #   encrypt                 = false
  #   dynamodb_table          = "terraform-state-lock"
  #  //shared_credentials_file = "./configs/aws/credentials"
  #   profile                 = "terraform"
  # }



