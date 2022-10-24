data "aws_availability_zones" "available" {
  state = "available"
}

# VPC
resource "aws_vpc" "testing" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "DevOps"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.testing.id

  tags = {
    Name = "DevOps IGW"
  }
}

# EIP for NAT Gateway HA
resource "aws_eip" "nat_eip" {
  count = var.enable_HA_for_NAT == true ? 2 : 1
  vpc   = true
  depends_on = [
    aws_internet_gateway.igw
  ]
  tags = {
    Name = "NAT Gateway EIP 2"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "testing" {
  count         = var.enable_HA_for_NAT == true ? 2 : 1
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.Public_subnets[count.index].id

  tags = {
    Name = "NAT Gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Public Subnets
resource "aws_subnet" "Public_subnets" {
  count                   = var.public_private_subnets
  vpc_id                  = aws_vpc.testing.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet-${count.index}"
  }
}

# Public Route table
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.testing.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

# Public Route Table assocation 
resource "aws_route_table_association" "public-subnets" {
  count          = var.public_private_subnets
  subnet_id      = aws_subnet.Public_subnets[count.index].id
  route_table_id = aws_route_table.public-route-table.id
}

# Private Subnets
resource "aws_subnet" "Private_subnets" {
  count                   = var.public_private_subnets
  vpc_id                  = aws_vpc.testing.id
  cidr_block              = var.private_subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Private-subnet-${count.index}"
  }
}

# Private Route table
resource "aws_route_table" "private-route-table" {
  count  = var.enable_HA_for_NAT == true ? 2 : 1
  vpc_id = aws_vpc.testing.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.testing[count.index].id
  }

  tags = {
    Name = "Private-Route-Table-${count.index}"
  }
}

# Private Route Table assocation 
resource "aws_route_table_association" "private-subnet-route-table-association" {
  count          = var.public_private_subnets
  subnet_id      = aws_subnet.Private_subnets[count.index].id
  route_table_id = aws_route_table.private-route-table[0].id
  depends_on = [
    aws_route_table.private-route-table
  ]
}

resource "aws_route_table_association" "private-subnet-route-table-association_2" {
  count          = var.public_private_subnets == 3 && var.enable_HA_for_NAT == true ? var.public_private_subnets : 0
  subnet_id      = aws_subnet.Private_subnets[count.index].id
  route_table_id = aws_route_table.private-route-table[1].id
  depends_on = [
    aws_route_table.private-route-table
  ]
}