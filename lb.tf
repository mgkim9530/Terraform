###########################
# Application load balancer
###########################

# create ALB

resource "aws_lb" "alb_web" {
  name               = "alb-web"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_c.id]
  tags               = { Name = "alb-web" }
}


# create listener

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb_web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {

      target_group {
        arn    = aws_lb_target_group.tg_web_a.arn
        weight = 50
      }

      target_group {
        arn    = aws_lb_target_group.tg_web_c.arn
        weight = 50
      }
      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}





#############
#targetgroup
#############

resource "aws_lb_target_group" "tg_web_a" {
  name        = "atg-web-a"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
  tags        = { Name = "tg-web-a" }
}

resource "aws_lb_target_group" "tg_web_c" {
  name        = "atg-web-c"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
  tags        = { Name = "tg-web-c" }
}



# web-server attachment

resource "aws_lb_target_group_attachment" "att_web_a" {
  target_group_arn = aws_lb_target_group.tg_web_a.arn
  target_id        = aws_instance.web_a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "att_web_c" {
  target_group_arn = aws_lb_target_group.tg_web_c.arn
  target_id        = aws_instance.web_c.id
  port             = 80
}



########################
# Network Load Balancer
########################

# create NLB

resource "aws_lb" "nlb_was" {
  name               = "nlb-was"
  internal           = true
  load_balancer_type = "network"
  ### Network Load balancer of Internel does not have Security group ###
  subnets = [aws_subnet.private_subnet_web_a.id, aws_subnet.private_subnet_web_c.id]
  tags    = { Name = "nlb-web" }
}


# create listener

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb_was.arn
  port              = "8080"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_was.arn
  }
}


#############
#targetgroup
#############

resource "aws_lb_target_group" "tg_was" {
  name        = "ntg-was"
  port        = "8080"
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
  tags        = { Name = "ntg-was" }
}


# was-server attachment

resource "aws_lb_target_group_attachment" "att_was_a" {
  target_group_arn = aws_lb_target_group.tg_was.arn
  target_id        = aws_instance.was_a.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "att_was_c" {
  target_group_arn = aws_lb_target_group.tg_was.arn
  target_id        = aws_instance.was_c.id
  port             = 8080
}

