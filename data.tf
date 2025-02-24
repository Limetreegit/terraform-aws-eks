# Get AWS Account Information
data "aws_caller_identity" "current" {}

output "caller_arn" {
    value = data.aws_caller_identity.current
}

data "aws_vpc" "selected" {
    id = "vpc-fe6a0186"
}

output "vpc_info" {
    value = data.aws_vpc.selected
}

data "aws_subnets" "this" {
    filter {
        # as of subnets api output
        name = "vpc-id"
        values = [data.aws_vpc.selected.id]
    }
}

# don't use it because there are four subnets instead of two used by EKS
output "vpc_subnets_chosen" {
    description = "aws subnets of the vpc"
    value = data.aws_subnets.this
}

# matching subnets from the same vpc-id
#   "ids" = tolist([
#     "subnet-b438defe",
#     "subnet-c98c48b1",
#     "subnet-d7cc1b8a",
#     "subnet-9eb4fbb5",
#   ])