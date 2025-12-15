// dev/vpc/main.tf
// Root module for vpc in dev environment.

# Fetching and storing My_IP
data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

locals {
  my_ip = coalesce(var.my_public_ip, "${chomp(data.http.myip.response_body)}/32")
}
#################################################
###################### VPC ######################
#################################################

resource "aws_vpc" "cicd_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

#################################################
###################### IGW ######################
#################################################

resource "aws_internet_gateway" "cicd_igw" {
  vpc_id = aws_vpc.cicd_vpc.id
  tags = {
    Name = var.internet_gateway_name
  }
}

########################################################
###################### Pub Subnet ######################
########################################################

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.cicd_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_name
  }
}

####################################################
###################### Pub RT ######################
####################################################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.cicd_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cicd_igw.id
  }

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = {
    Name = var.public_route_table_name
  }
}

# Associate Public Route Table
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

######################################################
###################### Pub NACL ######################
######################################################

resource "aws_network_acl" "public_nacl" {
  vpc_id     = aws_vpc.cicd_vpc.id
  subnet_ids = [aws_subnet.public_subnet.id]

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = local.my_ip
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "icmp"
    rule_no    = 200
    action     = "allow"
    cidr_block = local.my_ip
    icmp_type  = 8
    icmp_code  = 0
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = var.public_nacl_name
  }
}