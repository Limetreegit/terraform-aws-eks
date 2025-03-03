module "eks_cluster" {
    # for local module code
    source = "./eks-selfmade-module"
    # source = "github.com/Limetreegit/terraform-aws-eks?ref=v1.0.0"
    # source = "github.com/your-org/your-module.git?ref=v1.0.0"
    subnet_ids = var.subnet_ids
    # here is fine, but on child module level need to specifiy it
    scaling_config = var.scaling_config
}

