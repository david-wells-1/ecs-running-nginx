resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.name}"
  retention_in_days = 7
}