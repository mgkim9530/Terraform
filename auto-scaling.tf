
##################
# Launch Template
##################

resource "aws_launch_template" "launch_temp" {
  name = "auto-Scaling"

  image_id = "ami-0e4a9ad2eb120e054"

  instance_type = "t2.micro"

  key_name = "SeoulKey"


  monitoring {
    enabled = false
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "launch-template"

    }
  }

  user_data = filebase64("web1.sh")

}


######################
# Auto Scaling Groups
######################

resource "aws_autoscaling_group" "as_group" {
  name                      = "as_group"
  max_size                  = 4
  min_size                  = 0
  health_check_grace_period = 180
  health_check_type         = "ELB"
  desired_capacity          = 0
  force_delete              = true
  launch_template {
    id      = aws_launch_template.launch_temp.id
    version = "$Latest"
  }

  vpc_zone_identifier = [aws_subnet.private_subnet_web_a.id, aws_subnet.private_subnet_web_c.id]

  target_group_arns = [aws_lb_target_group.tg_web_a.arn]

  tag {
    key                 = "Name"
    value               = "AS-Web"
    propagate_at_launch = true
  }

}


############################
# AS Target Tracking Policy 
############################

resource "aws_autoscaling_policy" "as_policy" {
  name = "as-tagettracking-policy"


  policy_type = "TargetTrackingScaling"

  autoscaling_group_name = aws_autoscaling_group.as_group.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0

  }

}



