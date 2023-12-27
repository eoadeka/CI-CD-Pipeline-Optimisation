locals {
  launch_template_name = "cicd-launch-template-${var.environ}"
}

resource "aws_launch_template" "launch_template" {
  name          = local.launch_template_name
  image_id      = var.ami
  instance_type = var.instance_type

  network_interfaces {
    device_index    = 0
    security_groups = var.security_groups
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "cicdpo-${var.environ}-web"
    }
  }

 user_data = filebase64("${path.module}/userdata.sh")
}

resource "aws_autoscaling_group" "auto_scaling_group" {
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.vpc_zone_identifier
  target_group_arns   = var.target_group_arns
  # target_group_arns   = [aws_lb_target_group.target_group.arn]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = aws_launch_template.launch_template.latest_version
  }
}