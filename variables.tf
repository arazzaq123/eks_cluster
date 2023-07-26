#VPC
variable "vpc_name" {}
variable "instance_tenancy" {}
variable "cidr" {}

#subnet1
variable "public_subnet" {}

variable "public_subnet_name" {}

#Subnet3
variable "public_subnet_1" {}

#Subnet2
variable "private_subnet" {}
variable "private_subnet_name" {}

#Internetgateway
variable "igw_name" {}

#NATGateway 
variable "nat_tag" {}

#cluster
variable "cluster_name" {}

#nodegroup
variable "node_group_name" {}
variable "desired_size" {
  type        = number
  description = "Initial desired number of worker nodes (external changes ignored)"
}

variable "max_size" {
  type        = number
  description = "Maximum number of worker nodes"
}

variable "min_size" {
  type        = number
  description = "Minimum number of worker nodes"
}
#noderole
variable "node_role" {}
#clusterrole
variable "cluster_role_name" {}
# variable "public1_subnet" {}
variable "private1_subnet" {}
variable "availability_zone2" {}
variable "availability_zone1" {}

variable "ami_type" {
  type        = string
  description = <<-EOT
    Type of Amazon Machine Image (AMI) associated with the EKS Node Group.
    Defaults to `AL2_x86_64`. Valid values: `AL2_x86_64`, `AL2_x86_64_GPU`, `AL2_ARM_64`, `BOTTLEROCKET_x86_64`, and `BOTTLEROCKET_ARM_64`.
    EOT
  default     = "AL2_x86_64"
  validation {
    condition = (
      contains(["AL2_x86_64", "AL2_x86_64_GPU", "AL2_ARM_64", "BOTTLEROCKET_x86_64", "BOTTLEROCKET_ARM_64", "CUSTOM"], var.ami_type)
    )
    error_message = "Var ami_type must be one of \"AL2_x86_64\", \"AL2_x86_64_GPU\", \"AL2_ARM_64\", \"BOTTLEROCKET_x86_64\", \"BOTTLEROCKET_ARM_64\", or \"CUSTOM\"."
  }
}

variable "instance_types" {
  type        = list(string)
  default     = ["t3.medium"]
  description = <<-EOT
    Instance types to use for this node group (up to 20). Defaults to ["t3.medium"].
    Must be empty if the launch template configured by `launch_template_id` specifies an instance type.
    EOT
  validation {
    condition = (
      length(var.instance_types) <= 20
    )
    error_message = "Per the EKS API, no more than 20 instance types may be specified."
  }
}

variable "capacity_type" {
  type        = string
  default     = null
  description = <<-EOT
    Type of capacity associated with the EKS Node Group. Valid values: "ON_DEMAND", "SPOT", or `null`.
    Terraform will only perform drift detection if a configuration value is provided.
    EOT
  validation {
    condition     = var.capacity_type == null ? true : contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "Capacity type must be either `null`, \"ON_DEMAND\", or \"SPOT\"."
  }
}