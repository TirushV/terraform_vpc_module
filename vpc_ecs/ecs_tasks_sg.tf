resource "aws_security_group" "ecs_tasks" {
  name   = "ECS-Fargate_Tasks"
  vpc_id = aws_vpc.testing.id

  ingress {
    protocol        = "tcp"
    from_port       = var.container_port
    to_port         = var.container_port
    security_groups = [aws_lb.main.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}