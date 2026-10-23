variable "cpu" {
  default = 256
}

variable "memory" {
  default = 512
}

variable "name" {
  default = "ecs-running-nginx"
}

variable "pod_count" {
  default = "1"
}

variable "port" {
  default = 80
}

variable "protocol" {
  default = "HTTP"
}

variable "region" {
  default = "eu-west-2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
