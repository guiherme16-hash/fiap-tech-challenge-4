output "argocd_namespace" {
  description = "Namespace do ArgoCD."
  value       = helm_release.argocd.namespace
}

output "get_admin_password" {
  description = "Comando para obter a senha inicial do admin do ArgoCD."
  value       = "kubectl -n ${var.argocd_namespace} get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"
}

output "port_forward" {
  description = "Comando para acessar a UI do ArgoCD em https://localhost:8080."
  value       = "kubectl -n ${var.argocd_namespace} port-forward svc/argocd-server 8080:443"
}
