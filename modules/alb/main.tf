
# Application Load Balancer


resource "aws_lb" "this" {
  name               = "noortask5-alb"
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  tags = merge(
    var.tags,
    { Name = "noortask5-alb" }
  )
}


# Target Group


resource "aws_lb_target_group" "this" {
  name        = "noortask5-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"              # Required for Fargate
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }

  tags = merge(
    var.tags,
    { Name = "noortask5-tg" }
  )
}


# Listener (HTTP:80)


resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
