########
# RDS
########

resource "aws_db_instance" "rds" {
  identifier        = "mydb"
  allocated_storage = 10
  engine            = "mysql"
  engine_version    = "8.0.20"
  instance_class    = "db.t2.micro"
  name              = "mgkdb"
  username          = var.mysqluser
  password          = var.mysqlpassword
 
  #parameter_group_name = aws_db_parameter.rds_sub_group.name
  db_subnet_group_name = aws_db_subnet_group.rds_sub_group.name

  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = true

}

resource "aws_db_subnet_group" "rds_sub_group" {
  name       = "rds_sub_group"
  subnet_ids = [aws_subnet.private_subnet_db_a.id, aws_subnet.private_subnet_db_c.id]

  tags = {
    Name = "rds_sub_group"
  }
}
