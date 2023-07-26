resource "aws_vpc" "main" {
  cidr_block = var.cidr
  instance_tenancy = var.instance_tenancy

  tags = tomap({
    "Name"                                      = var.vpc_name,
    "kubernetes.io/cluster/${var.cluster_name}" = "shared",
  })
}

#SUBNET1
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet
  availability_zone = var.availability_zone1
  map_public_ip_on_launch = "true"

  depends_on = [aws_vpc.main]

  tags = {
    
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_1
  availability_zone = var.availability_zone2
  map_public_ip_on_launch = "true"

  depends_on = [aws_vpc.main]

  tags = {
    
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = "1"
  }
}

#private Subnet-0
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet
  availability_zone = var.availability_zone1

  depends_on = [aws_vpc.main]
  
  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
#Private Subnet-1
resource "aws_subnet" "private-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private1_subnet
  availability_zone = var.availability_zone1
  map_public_ip_on_launch = "true"

  depends_on = [aws_vpc.main]

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
#internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  depends_on = [aws_vpc.main]

  tags = {
    Name = var.igw_name
  }
}

#ELASTIC IP 
resource "aws_eip" "nat_ip"{
  vpc      = true
  depends_on = [aws_vpc.main]
  tags = {
    Name = var.nat_tag
 }
}

#NAT 
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public.id

  depends_on = [
    aws_eip.nat_ip, 
    aws_subnet.public
    ]
}

#Private route
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw.id
  }
  depends_on = [
    aws_nat_gateway.gw, 
    aws_vpc.main
    ]
}
#Public route 
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  depends_on = [
    aws_nat_gateway.gw , 
    aws_vpc.main
    ]

}

resource "aws_route_table_association" "private_nat" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_route.id

   depends_on = [
    aws_route_table.private_route
    ]
}

resource "aws_route_table_association" "private1_nat" {
  subnet_id      = aws_subnet.private-1.id
  route_table_id = aws_route_table.private_route.id

   depends_on = [
    aws_route_table.private_route
    ]
}


resource "aws_route_table_association" "public_gw" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_route.id

  depends_on = [
    aws_route_table.public_route
    ]
}

resource "aws_route_table_association" "public1_gw" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public_route.id

  depends_on = [
    aws_route_table.public_route
    ]
}

