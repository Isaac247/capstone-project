terraform {
  backend "s3" {
    bucket = var.bucket
    key    = "eks-cluster/terraform.tfstate"
    region = var.region
  }
}
