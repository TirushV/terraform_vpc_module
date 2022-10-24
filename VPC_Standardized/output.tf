output "aws_vpc_id" {
  value = aws_vpc.testing.id
}

output "aws_vpc_cidr" {
  value = aws_vpc.testing.cidr_block
}

output "public_subnets" {
  value = aws_subnet.Public_subnets[*].id
}

output "private_subnets" {
  value = aws_subnet.Private_subnets[*].id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}