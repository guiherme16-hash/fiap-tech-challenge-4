# Instala o ArgoCD via Helm no cluster EKS.
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_chart_version
  namespace        = var.argocd_namespace
  create_namespace = true

  # Aguarda os componentes ficarem prontos antes de concluir o apply.
  wait    = true
  timeout = 900

  # Valores mínimos; o servidor fica como ClusterIP (acesse via port-forward).
  values = [
    yamlencode({
      configs = {
        params = {
          # Deixe true apenas se for expor via port-forward em http.
          "server.insecure" = true
        }
      }
    })
  ]
}
