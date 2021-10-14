############
# vpc
############

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    "Name" = "vpc"
  }
}


###################
# internet gateway
###################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "IGW"
  }
}


#################
# EIP for NAT gw
#################
resource "aws_eip" "nat" {
  vpc = true
}


###############
# NAT gateway
###############
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = { Name = "Nat-gateway" }
}


