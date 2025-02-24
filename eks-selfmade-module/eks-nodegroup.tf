provider "aws" {
    region = "us-west-2"
    # shared_credentials_file = "$HOME/.aws/credentials"
    profile = "default"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# EKS Cluster
resource "aws_eks_cluster" "eks" {
    name = var.name
    role_arn = aws_iam_role.eks_cluster_role.arn

    vpc_config {
        subnet_ids = var.subnet_ids
    }
}

# EKS Node Group
resource "aws_eks_node_group" "eks_nodes" {
    cluster_name = aws_eks_cluster.eks.name
    node_group_name = "eks-node-group"
    node_role_arn = aws_iam_role.eks_node_role.arn
    subnet_ids = var.subnet_ids
    scaling_config {
        desired_size = 1
        max_size = 2
        min_size = 1
    }
}
