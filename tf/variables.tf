variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "zorin"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "node_instance_types" {
  description = "EKS node instance types"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_count" {
  description = "Number of EKS nodes"
  type        = number
  default     = 1
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "github_org" {
  description = "GitHub organization"
  type        = string
  default     = "vishnuvardhan1170"
}

variable "github_repo" {
  description = "GitHub repository"
  type        = string
  default     = "test"
}

variable "github_oidc_provider_arn" {
  type        = string
  description = "ARN of the GitHub OIDC provider"
}
