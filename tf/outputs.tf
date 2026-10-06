output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "github_ecr_role_arn" {
  value = aws_iam_role.github_ecr.arn
}

output "argocd_url" {
  value = data.kubernetes_service.argocd.status[0].load_balancer[0].ingress[0].hostname
}
