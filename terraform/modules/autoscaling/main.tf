locals {
  launch_template_name = "cicd-launch-template-${var.environ}"
}

resource "aws_launch_template" "cicdpo_launch_template" {
  name = local.launch_template_name
  image_id = var.ami
  instance_type = var.instance_type
}

resource "aws_autoscaling_group" "cicdpo_asg" {
  # number of instances
  desired_capacity = var.desired_capacity
  min_size = var.min_size
  max_size = var.min_size
  
  vpc_zone_identifier = var.vpc_zone_identifier
  target_group_arns = var.target_group_arns

  launch_template {
    id = aws_launch_template.cicdpo_launch_template.id
    version = aws_launch_template.cicdpo_launch_template.latest_version
  }
}