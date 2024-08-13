module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "socks-shop-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev" 
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "socks-shop-cluster"
  cluster_version = "1.30"

  cluster_endpoint_public_access  = true

  
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type                    = "AL2_x86_64"
    associate_public_ip_address = true
  }

  eks_managed_node_groups = {
    node_1 = {
    name = "first-node"
      instance_types = ["t3.medium"]
      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
    node_2 = {
    name = "second-node"
      instance_types = ["t3.medium"]
      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }

  
  enable_cluster_creator_admin_permissions = true

 
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}