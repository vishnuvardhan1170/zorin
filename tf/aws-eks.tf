module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.19"

  cluster_name                    = var.cluster_name
  cluster_version                 = "1.30"
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  eks_managed_node_group_defaults = {
    disk_size = 50
  }

  eks_managed_node_groups = {
    nodes = {
      min_size       = var.node_count
      max_size       = var.node_count
      desired_size   = var.node_count
      instance_types = var.node_instance_types
    }
  }

  tags = {
    Environment = var.environment
    Project     = "zorin"
  }
}
