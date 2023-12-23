locals {
  launch_template_name = "cicd-launch-template-${var.environ}"
}

module "autoscaling" {
  source = "terraform-aws-modules/autoscaling/aws"
  version = "7.3.1"

  name = "cicdpo-${var.environ}-asg"

  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity
  wait_for_capacity_timeout = 0
  vpc_zone_identifier = var.vpc_zone_identifier

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Launch template
  launch_template_name = local.launch_template_name
  launch_template_description = "${var.environ} environment launch template"
  update_default_version = true

  image_id = var.ami
  instance_type = var.instance_type
  ebs_optimized = true
  enable_monitoring = true

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp2"
      }
    }, {
      device_name = "/dev/sda1"
      no_device   = 1
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 30
        volume_type           = "gp2"
      }
    }
  ]
}