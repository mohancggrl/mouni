# Create an VPC with the CIDR Range
resource "aws_vpc" "vpc_id" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    {
      Name        = var.name,
      Environment = var.environment
    }
  )
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "gw_id" {
  vpc_id = aws_vpc.vpc_id.id
  tags = merge(
    {
      Name        = "${var.name}-IGW",
      Environment = var.environment
    }
  )
}

# Create a external facing subnets in AZ
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr_blocks)
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones_public[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    {
      Name                                = "${var.name}-PublicSubnet-${count.index + 1}",
      Environment                         = var.environment
    }
  )
}

# Create a Internal facing subnets in AZ
resource "aws_subnet" "dmz" {
  count             = length(var.dmz_subnet_cidr_blocks)
  vpc_id            = var.vpc_id
  cidr_block        = var.dmz_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones_dmz[count.index]
  tags = merge(
    {
      Name                                = "${var.name}-DmzSubnet-${count.index + 1}",
      Environment                         = var.environment
    }
  )
}

resource "aws_subnet" "int" {
  count             = length(var.int_subnet_cidr_blocks)
  vpc_id            = var.vpc_id
  cidr_block        = var.int_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones_int[count.index]
  tags = merge(
    {
      Name                                = "${var.name}-IntSubnet-${count.index + 1}",
      Environment                         = var.environment
    }
  )
}

# Create an NAT gateway to give our private subnet access the outside world 
resource "aws_eip" "nat" {
  vpc = true
}
resource "aws_nat_gateway" "ngw_id" {
  depends_on    = [aws_internet_gateway.gw_id]
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags = merge(
    {
      Name        = "${var.name}-NATGW",
      Environment = var.environment
    }
  )
}

# Create new routing table without internet access for instances
data "aws_availability_zones" "available" {}

locals {
  network_count = length(data.aws_availability_zones.available.names)
}
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags = merge(
    {
      Name        = "${var.name}-PUB-RT",
      Environment = var.environment
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id

}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw_id.id
  depends_on             = [aws_route_table_association.public]
}

resource "aws_route_table" "dmz" {
  vpc_id = var.vpc_id
  tags = merge(
    {
      Name        = "${var.name}-dmz-RT",
      Environment = var.environment
    }
  )
}

resource "aws_route_table_association" "dmz" {
  count          = length(var.dmz_subnet_cidr_blocks)
  subnet_id      = aws_subnet.dmz[count.index].id
  route_table_id = aws_route_table.dmz.id
}

resource "aws_route" "dmz" {
  route_table_id         = aws_route_table.dmz.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw_id.id
  depends_on             = [aws_route_table_association.dmz]
}

resource "aws_route_table" "int" {
  vpc_id = var.vpc_id
  tags = merge(
    {
      Name        = "${var.name}-int-RT",
      Environment = var.environment
    }
  )
}

resource "aws_route_table_association" "int" {
  count          = length(var.int_subnet_cidr_blocks)
  subnet_id      = aws_subnet.int[count.index].id
  route_table_id = aws_route_table.int.id
}