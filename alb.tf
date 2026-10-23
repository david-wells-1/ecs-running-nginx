resource "aws_lb" "ecs" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.ecs.*.id
  security_groups    = [aws_security_group.ecs_alb.id]
}

resource "aws_lb_target_group" "ecs" {
  depends_on  = [aws_lb.ecs]
  name        = var.name
  port        = var.port
  protocol    = var.protocol
  target_type = "ip"
  vpc_id      = aws_vpc.ecs.id

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_lb_listener" "ecs" {
  load_balancer_arn = aws_lb.ecs.id
  port              = var.port
  protocol          = var.protocol

  default_action {
    target_group_arn = aws_lb_target_group.ecs.id
    type             = "forward"
  }
}
