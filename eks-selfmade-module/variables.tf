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

variable "scaling_config" {
    description = "Map of EKS node group autoscaling configuration"
    type = map(object({
        desired_size    = number
        max_size        = number
        min_size        = number
    }))
    default = {
        "default" = {
            desired_size = 1
            max_size = 2
            min_size = 1  
        }

    }
}

