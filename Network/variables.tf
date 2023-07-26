#VPC
variable "vpc_name" {}
variable "instance_tenancy"{}
variable "cidr" {}
variable "cluster_name" {}

#EIP
variable "nat_tag"{}

#subnet1
variable "public_subnet"{}
variable "availability_zone1" {}
variable "public_subnet_name" {}

#Subnet4
variable "public_subnet_1"{}
  
#Subnet3
variable "private_subnet" {}
variable "availability_zone2"{}
variable "private_subnet_name"{}

#subnet4
variable "private1_subnet"{}


#Internetgateway
variable "igw_name" {}
