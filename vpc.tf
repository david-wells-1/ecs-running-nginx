resource "aws_vpc" "ecs" {
  cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "ecs" {
  vpc_id = aws_vpc.ecs.id
}

resource "aws_subnet" "ecs" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.ecs.id
  cidr_block              = "10.0.${10 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
}

resource "aws_default_route_table" "ecs" {
  default_route_table_id = aws_vpc.ecs.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs.id
  }
}

resource "aws_route_table_association" "ecs" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = aws_subnet.ecs.*.id[count.index]
  route_table_id = aws_default_route_table.ecs.id
}