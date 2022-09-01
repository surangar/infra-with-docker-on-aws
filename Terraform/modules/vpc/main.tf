############################
# VPC
############################
resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = merge(
    {
      "Name" = "${var.name}-VPC"
    }
  )
}

############################
# Public subnet 1
############################
resource "aws_subnet" "public-subnet01" {
  vpc_id = aws_vpc.this[0].id
  cidr_block = var.public_subnet_cidr01
  map_public_ip_on_launch = "true"
  availability_zone = var.azs[0]

  tags = merge(
    {
      "Name" = "Public Subnet 01"
    }
  )
}

############################
# Public subnet 2
############################
resource "aws_subnet" "public-subnet02" {
  vpc_id = aws_vpc.this[0].id
  cidr_block = var.public_subnet_cidr02
  map_public_ip_on_launch = "true"
  availability_zone = var.azs[1]

  tags = merge(
    {
      "Name" = "Public Subnet 02"
    }
  )
}

############################
# Private subnet 1
############################
resource "aws_subnet" "private-subnet01" {
  vpc_id = aws_vpc.this[0].id
  cidr_block = var.private_subnet_cidr01
  availability_zone = var.azs[0]

  tags = merge(
    {
      "Name" = "Private Subnet 01"
    }
  )
}

############################
# Private subnet 2
############################
resource "aws_subnet" "private-subnet02" {
  vpc_id = aws_vpc.this[0].id
  cidr_block = var.private_subnet_cidr02
  availability_zone = var.azs[1]

  tags = merge(
    {
      "Name" = "Private Subnet 02"
    }
  )
}

############################
# Internet Gateway
############################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this[0].id

  tags = merge(
    {
      "Name" = "${var.name}-IG"
    }
  )
}

############################
# Public Routing Table
############################
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.this[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    {
      "Name" = "Public RTB"
    }
  )
}

############################
# Public Routing Table Association - Public subnets
############################
resource "aws_route_table_association" "rtb-association-pubsub01" {
  subnet_id = aws_subnet.public-subnet01.id
  route_table_id = aws_route_table.public-rtb.id
}

resource "aws_route_table_association" "rtb-association-pubsub02" {
  subnet_id = aws_subnet.public-subnet02.id
  route_table_id = aws_route_table.public-rtb.id
}

############################
# Private Routing Table
############################
resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.this[0].id
  
  tags = merge(
    {
      "Name" = "Private RTB"
    }
  )
}

############################
# Private Routing Table Association - Private subnets
############################
resource "aws_route_table_association" "rtb-association-prisub01" {
  subnet_id = aws_subnet.private-subnet01.id
  route_table_id = aws_route_table.private-rtb.id
}

resource "aws_route_table_association" "rtb-association-prisub02" {
  subnet_id = aws_subnet.private-subnet02.id
  route_table_id = aws_route_table.private-rtb.id
}

