module "Network" {
  source             = "./Network"
  vpc_name           = var.vpc_name
  instance_tenancy   = var.instance_tenancy
  cidr               = var.cidr
  public_subnet      = var.public_subnet
  public_subnet_1    = var.public_subnet_1
  availability_zone1 = var.availability_zone1
  availability_zone2 = var.availability_zone2
  public_subnet_name = var.public_subnet_name
  private_subnet     = var.private_subnet
  private_subnet_name = var.private_subnet_name
  igw_name            = var.igw_name
  private1_subnet     = var.private1_subnet
  cluster_name        = var.cluster_name
  nat_tag             = var.nat_tag

}

module "Cluster" {
  source            = "./Cluster"
  cluster_name      = var.cluster_name
  subnetA           = module.Network.pub_sub_id
  subnetB           = module.Network.pub_sub_id_1
  cluster_role_name = var.cluster_role_name
  depends_on        = [module.Network]
}

module "Worker" {
  source          = "./Worker"
  node_group_name = var.node_group_name
  desired_size    = var.desired_size
  max_size        = var.max_size
  min_size        = var.min_size
  node_role       = var.node_role
  pvt_sub_id      = module.Network.pvt_sub_id
  pvt_sub_1_id    = module.Network.pvt_sub_id_1
  cluster_name    = var.cluster_name
  ami_type        = var.ami_type
  instance_types  = var.instance_types
  capacity_type   = var.capacity_type
  depends_on      = [module.Cluster]
}


