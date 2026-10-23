resource "aws_security_group" "ecs_alb" {
  name        = "${var.name}-alb"
  description = "controls access to the ${var.name} alb"
  vpc_id      = aws_vpc.ecs.id
}

resource "aws_security_group_rule" "ecs_alb_1" {
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_alb.id
}

resource "aws_security_group_rule" "ecs_alb_2" {
  type                     = "egress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_targets.id
  security_group_id        = aws_security_group.ecs_alb.id
}

resource "aws_security_group" "ecs_targets" {
  name        = "${var.name}-targets"
  description = "controls access to the ${var.name} targets"
  vpc_id      = aws_vpc.ecs.id
}

resource "aws_security_group_rule" "ecs_targets_1" {
  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_alb.id
  security_group_id        = aws_security_group.ecs_targets.id
}

resource "aws_security_group_rule" "ecs_targets_2" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_targets.id
}