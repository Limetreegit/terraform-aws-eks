module "eks_cluster" {
    source = "./eks-selfmade-module"
    subnet_ids = var.subnet_ids
    name = var.name
}


