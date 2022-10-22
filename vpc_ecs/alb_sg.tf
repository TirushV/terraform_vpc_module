resource "aws_security_group" "alb" {
  name   = "ECS_Fargate_ALB"
  vpc_id = aws_vpc.testing.id

  ingress {
    protocol         = "tcp"
    from_port        = var.http_port
    to_port          = var.http_port
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = var.https_port
    to_port          = var.https_port
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}