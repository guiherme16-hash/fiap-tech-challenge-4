provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile != "" ? var.aws_profile : null

  allowed_account_ids = length(var.allowed_account_ids) > 0 ? var.allowed_account_ids : null
}

# Descobre o cluster EKS já provisionado.
data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = concat(
      ["eks", "get-token", "--cluster-name", var.cluster_name, "--region", var.aws_region],
      var.aws_profile != "" ? ["--profile", var.aws_profile] : []
    )
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = concat(
      ["eks", "get-token", "--cluster-name", var.cluster_name, "--region", var.aws_region],
      var.aws_profile != "" ? ["--profile", var.aws_profile] : []
    )
    }
  }
}
