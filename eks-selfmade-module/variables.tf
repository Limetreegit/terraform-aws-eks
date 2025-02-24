variable "subnet_ids" {
    description = "the list of subnets_id"
    type = list
    # default =       ["subnet-b438defe", "subnet-c98c48b1"]
}


variable "name" {
    description = "the EKS cluster name"
    type = string 
    default = "my-cluster"
}


