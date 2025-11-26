
# IAM ROLE: Task Execution Role

resource "aws_iam_role" "task_execution_role" {
  name = "${var.task_family}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

# Attach AWS managed policy for ECR + CloudWatch logs
resource "aws_iam_role_policy_attachment" "execution_policy" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# CloudWatch Logs

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${var.task_family}"
  retention_in_days = 7
}


# ECS Task Definition

resource "aws_ecs_task_definition" "this" {
  family                   = var.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = var.ecs_task_role_arn != null ? var.ecs_task_role_arn : aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = var.ecr_image_url
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }

     mountPoints = [
  {
    sourceVolume  = "nginx-efs"
    containerPath = "/mnt/efs"

    readOnly      = false
  }
]


    }
  ])

  volume {
  name = "nginx-efs"

  efs_volume_configuration {
    file_system_id = var.efs_file_system_id
    transit_encryption = "ENABLED"

    authorization_config {
      access_point_id = var.efs_access_point_id
      iam             = "ENABLED"
    }
  }
}




  tags = var.tags
}
