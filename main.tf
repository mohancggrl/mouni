provider "aws" {
  access_key = ""
  secret_key = ""
  region    = "us-east-1"
}

/*
terraform {
  backend "s3" {
    bucket  = "telioev-store"
    key     = "telioev/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = "true"
  }
}
*/

module "eks" {
  source           = "C:\\Users\\admin\\Desktop\\terraform\\mahii\\modules\\eks"
  cluster_name     = var.cluster_name
  subnet_ids       = var.subnet_ids
  ami_type         = var.ami_type
  worker_name      = var.worker_name
  desired_size     = var.desired_size
  min_size         = var.min_size
  max_size         = var.max_size
  instance_types   = var.instance_types
  aws_vpc          = "vpc-0614ed009b4d1734f"
}