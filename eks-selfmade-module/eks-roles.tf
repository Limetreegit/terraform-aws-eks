# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
    name = "eksClusterRole"
    assume_role_policy = jsonencode({
        Version = "2012-10-17", 
        Statement = [{
            Effect = "Allow",
            Principal = { Service = "eks.amazonaws.com"},
            Action = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks_cluster_role.name
}

# IAM Role for EKS Nodes
resource "aws_iam_role" "eks_node_role" {
    name = "eksNodeRole"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Effect = "Allow",
            Principal = { Service = "ec2.amazonaws.com"},
            Action = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.eks_node_role.name
}

# IAM Role for AWS Console GUI Access
resource "aws_iam_role" "eks_console_access" {
    name = "eksConsoleAccessRole"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Effect = "Allow",
            Principal = { AWS = "arn:aws:iam::562364260873:root"}, 
            Action = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_role_policy_attachment" "eks_console_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"          
    role = aws_iam_role.eks_console_access.name
}

/*
# Kubernetes ConfigMap for AWS Auth
resource "null_resource" "aws_auth_configmap" {
    provisioner "local-exec" {
        command = <<EOT
            aws eks update-kubeconfig --region us-west-2 --name ${aws_eks_cluster.eks.name}
            kubectl apply -f - <<EOF
            apiVersion: v1
            kind: ConfigMap
            metadata:
                name: aws-auth
                namespace: kube-system
            data:
                mapRoles: |
                 -  rolearn: ${aws_iam_role.eks_node_role.arn}
                    # userarn: arn:aws:iam::562364260873:user/system/sre
                    username: system:node:{{EC2PrivateDNSName}}
                    group:
                     -  system:bootstrappers
                     -  system:nodes
        EOF
        EOT          
    }
    depends_on = [aws_eks_cluster.eks]
}
*/