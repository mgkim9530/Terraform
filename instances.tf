##################
# bastion-instance
##################

resource "aws_instance" "bastion_a" {
  ami                    = "ami-0e4a9ad2eb120e054"
  instance_type          = "t2.micro"
  availability_zone      = "ap-northeast-2a"
  subnet_id              = aws_subnet.public_subnet_a.id
  key_name               = "SeoulKey"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  tags                   = { Name = "bastion-a" }
}


###############
# web-instance
###############

resource "aws_instance" "web_a" {
  ami                    = "ami-0e4a9ad2eb120e054"
  instance_type          = "t2.micro"
  availability_zone      = "ap-northeast-2a"
  subnet_id              = aws_subnet.private_subnet_web_a.id
  key_name               = "SeoulKey"
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]


  user_data = <<-EOF
              #!/bin/bash
	      sudo -s
              yum -y update
	      amazon-linux-extras install nginx1
	      systemctl restart nginx
              EOF

  tags = { Name = "web-a" }








}


resource "aws_instance" "web_c" {
  ami                    = "ami-0e4a9ad2eb120e054"
  instance_type          = "t2.micro"
  availability_zone      = "ap-northeast-2c"
  subnet_id              = aws_subnet.private_subnet_web_c.id
  key_name               = "SeoulKey"
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]


  user_data = <<-EOF
              #!/bin/bash
	      sudo -s
              yum -y update
	      amazon-linux-extras install nginx1
	      systemctl restart nginx
              EOF

  tags = { Name = "web-c" }
}


###############
# was-instance
###############

resource "aws_instance" "was_a" {
  ami                    = "ami-0e4a9ad2eb120e054"
  instance_type          = "t2.micro"
  availability_zone      = "ap-northeast-2a"
  subnet_id              = aws_subnet.private_subnet_was_a.id
  key_name               = "SeoulKey"
  vpc_security_group_ids = [aws_security_group.was_sg.id]

  user_data = <<-EOF
#!/bin/bash 
sudo -s
yum -y update
yum -y install tomcat
yum -y install java-1.8.0-openjdk-devel.x86_64

systemctl restart tomcat
EOF

  tags = { Name = "was-a" }
}


resource "aws_instance" "was_c" {
  ami                    = "ami-0e4a9ad2eb120e054"
  instance_type          = "t2.micro"
  availability_zone      = "ap-northeast-2c"
  subnet_id              = aws_subnet.private_subnet_was_c.id
  key_name               = "SeoulKey"
  vpc_security_group_ids = [aws_security_group.was_sg.id]


  user_data = <<-EOF
#!/bin/bash
 sudo -s
yum -y update
yum -y install tomcat
yum -y install java-1.8.0-openjdk-devel.x86_64

systemctl restart tomcat
EOF

  tags = { Name = "was-c" }
}
