
####################
# public route table
####################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Public rt"
  }
}

resource "aws_route" "public_rtb" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_rt_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_c" {
  subnet_id      = aws_subnet.public_subnet_c.id
  route_table_id = aws_route_table.public_rt.id
}



####################
# private route table
####################

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Private rt"
  }
}
resource "aws_route" "private_rt" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

resource "aws_route_table_association" "private_rt_web_a" {

  subnet_id      = aws_subnet.private_subnet_web_a.id
  route_table_id = aws_route_table.private_rt.id
}


resource "aws_route_table_association" "private_rt_web_c" {

  subnet_id      = aws_subnet.private_subnet_web_c.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_was_a" {

  subnet_id      = aws_subnet.private_subnet_was_a.id
  route_table_id = aws_route_table.private_rt.id
}


resource "aws_route_table_association" "private_rt_was_c" {

  subnet_id      = aws_subnet.private_subnet_was_c.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_rt_db_a" {

  subnet_id      = aws_subnet.private_subnet_db_a.id
  route_table_id = aws_route_table.private_rt.id
}


resource "aws_route_table_association" "private_rt_db_c" {

  subnet_id      = aws_subnet.private_subnet_db_c.id
  route_table_id = aws_route_table.private_rt.id
}
