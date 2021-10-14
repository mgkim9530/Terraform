#########################
# default security group
#########################

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "default-sg" }
}


##############
# bastion-sg
##############

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "allow ssh connect"
  vpc_id      = aws_vpc.vpc.id


  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "inbound for ssh"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "bastion-sg" }
}

###############
# webserver-sg
###############

resource "aws_security_group" "webserver_sg" {
  name        = "webserver-sg"
  description = "sg for webserver"
  vpc_id      = aws_vpc.vpc.id


  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "inbound for ssh"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "inbound for http"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "outbound for http"
  }
  tags = { Name = "webserver-sg " }
}


###############
# WAS-sg
###############

resource "aws_security_group" "was_sg" {
  name        = "was-sg"
  description = "sg for was"
  vpc_id      = aws_vpc.vpc.id


  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "inbound for ssh"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24", "10.0.3.0/24"]
    description = "inbound for http"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "outbound for http"
  }
  tags = { Name = "Web-application-server-sg " }
}


##############
# database-sg
##############

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "sg for database"
  vpc_id      = aws_vpc.vpc.id


  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "inbound for ssh"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "inbound for mysql"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "outbound for mysql"
  }
  tags = { Name = "db-sg" }

}

#########
# alb sg 
#########
resource "aws_security_group" "alb_sg" {
  name        = "alb-web"
  description = "sg-alb-web"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "sg-alb-web" }
}


