resource "aws_ecs_cluster" "main" {
  name = "ECSFargateCluster"
}

resource "aws_ecs_task_definition" "main" {
  family                   = "test"
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
    "name": "nginx",
    "portMappings": [
      {
        "containerPort": 80
      }
    ]
  }
]
TASK_DEFINITION
}