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

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
  depends_on = [
    aws_internet_gateway.igw
  ]
  tags = {
    Name = "NAT Gateway EIP"
  }
}

# EIP for NAT Gateway HA
resource "aws_eip" "nat_eip_2" {
  count = var.enable_HA_for_NAT == true ? 1 : 0
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
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.Public_subnet_1.id

  tags = {
    Name = "NAT Gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateway for HA
resource "aws_nat_gateway" "testing2" {
  count         = var.enable_HA_for_NAT == true ? 1 : 0
  allocation_id = aws_eip.nat_eip_2[0].id
  subnet_id     = aws_subnet.Public_subnet_2.id

  tags = {
    Name = "NAT Gateway 2"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Public Subnets
resource "aws_subnet" "Public_subnet_1" {
  vpc_id                  = aws_vpc.testing.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet-1"
  }
}

resource "aws_subnet" "Public_subnet_2" {
  vpc_id                  = aws_vpc.testing.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet-2"
  }
}

resource "aws_subnet" "Public_subnet_3" {
  count                   = var.three_public_private_subnets == true ? 1 : 0
  vpc_id                  = aws_vpc.testing.id
  cidr_block              = var.public_subnet_3_cidr
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet-3"
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
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id      = aws_subnet.Public_subnet_1.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  subnet_id      = aws_subnet.Public_subnet_2.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-subnet-3-route-table-association" {
  count          = var.three_public_private_subnets == true ? 1 : 0
  subnet_id      = aws_subnet.Public_subnet_3[0].id
  route_table_id = aws_route_table.public-route-table.id
}

# Private subnets
resource "aws_subnet" "Private_subnet_1" {
  vpc_id                  = aws_vpc.testing.id
  cidr_block              = var.private_subnet_1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-subnet-1"
  }
}

resource "aws_subnet" "Private_subnet_2" {
  vpc_id                  = aws_vpc.testing.id
  cidr_block              = var.private_subnet_2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-subnet-2"
  }
}

resource "aws_subnet" "Private_subnet_3" {
  count                   = var.three_public_private_subnets == true ? 1 : 0
  vpc_id                  = aws_vpc.testing.id
  cidr_block              = var.private_subnet_3_cidr
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-subnet-3"
  }
}

# Private Route table
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.testing.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.testing.id
  }

  tags = {
    Name = "Private-Route-Table"
  }
}

resource "aws_route_table" "private-route-table_2" {
  count  = var.enable_HA_for_NAT == true ? 1 : 0
  vpc_id = aws_vpc.testing.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.testing2[0].id
  }

  tags = {
    Name = "Private-Route-Table 2"
  }
}

# Private Route Table assocation 
resource "aws_route_table_association" "private-subnet-1-route-table-association" {
  subnet_id      = aws_subnet.Private_subnet_1.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "private-subnet-2-route-table-association" {
  subnet_id      = aws_subnet.Private_subnet_2.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "private-subnet-3-route-table-association" {
  count          = var.three_public_private_subnets == true ? 1 : 0
  subnet_id      = aws_subnet.Private_subnet_3[0].id
  route_table_id = aws_route_table.private-route-table.id
}

# HA NAT Route Tables
resource "aws_route_table_association" "private-subnet-1-route-table-association_2" {
  count          = var.enable_HA_for_NAT == true ? 1 : 0
  subnet_id      = aws_subnet.Private_subnet_1.id
  route_table_id = aws_route_table.private-route-table_2[0].id
}

resource "aws_route_table_association" "private-subnet-2-route-table-association_2" {
  count          = var.enable_HA_for_NAT == true ? 1 : 0
  subnet_id      = aws_subnet.Private_subnet_2.id
  route_table_id = aws_route_table.private-route-table_2[0].id
}

resource "aws_route_table_association" "private-subnet-3-route-table-association_2" {
  count          = var.three_public_private_subnets && var.enable_HA_for_NAT == true ? 1 : 0
  subnet_id      = aws_subnet.Private_subnet_3[0].id
  route_table_id = aws_route_table.private-route-table_2[0].id
}