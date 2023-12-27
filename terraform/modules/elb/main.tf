# resource "aws_lb" "cicdpo_alb" {
#   name               = "cicdpo-${var.environ}-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = var.security_groups
#   subnets            = var.subnets

#   enable_deletion_protection = true

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id
#     prefix  = "cicdpo-${var.environ}-lb"
#     enabled = true
#   }

#   tags = {
#     Name = "cicdpo-${var.environ}-lb"
#     Environment = var.environ
#   }
# }

# # Target group
# resource "aws_lb_target_group" "alb_target_group" {
#   name = "cicdpo-${var.environ}-tg"
#   target_type = "ip"
#   port = 80
#   protocol = "HTTP"
#   vpc_id = var.vpc_id

#   health_check {
#     enabled = true
#     interval = 300
#     path = "/"
#     timeout = 60
#     matcher = 200
#     healthy_threshold = 5
#     unhealthy_threshold = 5
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # create listeners on port 80 with redirect action
# resource "aws_lb_listener" "alb_http_listener" {
#   load_balancer_arn = aws_lb.alb.arn
#   port = 80
#   protocol = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port = 443
#       protocol = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }

# # create listeners on port 443 with forward action
# resource "aws_lb_listener" "alb_https_listener" {
#   load_balancer_arn = aws_lb.alb.arn
#   port = 443
#   protocol = "HTTPS"
#   ssl_policy = "ELBSecurityPolicy-2016-08"

#   default_action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.alb_target_group.arn
#   }
# }



resource "aws_lb" "alb" {
  name               = "cicdpo-${var.environ}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets
}

resource "aws_lb_target_group" "target_group" {
  name     = "cicdpo-${var.environ}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path    = "/"
    matcher = 200
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# MODULE


# module "alb" {
#   source = "terraform-aws-modules/alb/aws"
#   version = "9.3.0"

#   name    = "cicdpo-${var.environ}-alb"
#   vpc_id  = "vpc-abcde012"
#   subnets = ["subnet-abcde012", "subnet-bcde012a"]

#   # Security Group
#   security_group_ingress_rules = {
#     all_http = {
#       from_port   = 80
#       to_port     = 80
#       ip_protocol = "tcp"
#       description = "HTTP web traffic"
#       cidr_ipv4   = "0.0.0.0/0"
#     }
#     all_https = {
#       from_port   = 443
#       to_port     = 443
#       ip_protocol = "tcp"
#       description = "HTTPS web traffic"
#       cidr_ipv4   = "0.0.0.0/0"
#     }
#   }
#   security_group_egress_rules = {
#     all = {
#       ip_protocol = "-1"
#       cidr_ipv4   = "10.0.0.0/16"
#     }
#   }

#   access_logs = {
#     bucket = "my-alb-logs"
#   }

#   listeners = {
#     ex-http-https-redirect = {
#       port     = 80
#       protocol = "HTTP"
#       redirect = {
#         port        = "443"
#         protocol    = "HTTPS"
#         status_code = "HTTP_301"
#       }
#     }
#     ex-https = {
#       port            = 443
#       protocol        = "HTTPS"
#       certificate_arn = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"

#       forward = {
#         target_group_key = "ex-instance"
#       }
#     }
#   }

#   target_groups = {
#     ex-instance = {
#       name_prefix      = "h1"
#       protocol         = "HTTP"
#       port             = 80
#       target_type      = "instance"
#     }
#   }

#   tags = {
#     Name = "cicdpo-${var.environ}-alb"
#     Project = "cicdpo.io"
#     Environment = var.environ
#     Terraform = true
#   }
# }