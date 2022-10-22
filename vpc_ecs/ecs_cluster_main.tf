resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-${var.name}"
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${var.environment}-${var.name}-cluster"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  #task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = <<TASK_DEFINITION
[
  {
    "essential": true,
    "image": "${var.container_image}:latest",
    "memory": 128,
    "name": "${var.container_name}",
    "portMappings": [
      {
        "containerPort": ${var.container_port}
      }
    ]
  }
]
TASK_DEFINITION
}