output "aws_vpc_id" {
  value = aws_vpc.testing.id
}

output "aws_vpc_cidr" {
  value = aws_vpc.testing.cidr_block
}

output "public_subnet1" {
  value = aws_subnet.Public_subnet_1.id
}

output "public_subnet2" {
  value = aws_subnet.Public_subnet_2.id
}

output "public_subnet3" {
  value = aws_subnet.Public_subnet_3.id
}

output "private_subnet1" {
  value = aws_subnet.Private_subnet_1.id
}

output "private_subnet2" {
  value = aws_subnet.Private_subnet_2.id
}

output "private_subnet3" {
  value = aws_subnet.Private_subnet_3.id
}