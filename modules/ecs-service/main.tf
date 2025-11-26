resource "aws_ecs_service" "this" {
  name            = "noortask5-service"
  cluster         = var.cluster_name
  task_definition = var.task_definition_arn

  launch_type = "FARGATE"
  desired_count = 1

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "nginx"
    container_port   = 80
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  depends_on = [var.target_group_arn]

  tags = var.tags
}
