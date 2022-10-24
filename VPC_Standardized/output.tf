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

output "private_route_table" {
  value = aws_route_table.private-route-table[*].arn
}

output "public_route_table" {
  value = aws_route_table.public-route-table.arn
}

output "public_route_table_association" {
  value = aws_route_table_association.public-subnets[*].id
}

output "private_route_table_association" {
  value = aws_route_table_association.private-subnet-route-table-association[*].id
}

output "public_route_table_association_2" {
  value = aws_route_table_association.private-subnet-route-table-association_2[*].id
}