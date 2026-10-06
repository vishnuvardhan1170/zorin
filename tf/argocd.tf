# Deploy ArgoCD using Helm
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.5.16"
  namespace        = "argocd"
  create_namespace = true

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "configs.params.server.insecure"
    value = "true"
  }

  depends_on = [module.eks]
}

# Create a namespace for zorin application
resource "kubernetes_namespace" "zorin" {
  metadata {
    name = "zorin"
    labels = {
      "app.kubernetes.io/name"       = "zorin"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  depends_on = [module.eks]
}

# Create a secret for GitHub repo access in ArgoCD
resource "kubernetes_secret" "argocd_github" {
  metadata {
    name      = "zorin-repo"
    namespace = "argocd"
  }

  data = {
    type = "git"
    url  = "https://github.com/${var.github_org}/${var.github_repo}.git"
  }

  type = "Opaque"

  depends_on = [helm_release.argocd]
}

data "kubernetes_service" "argocd" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }
  depends_on = [helm_release.argocd]
}
