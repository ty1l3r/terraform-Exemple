resource "aws_key_pair" "myec2key" {
  key_name   = "keypair-wp"
  public_key = file("/home/ubuntu/project/key_rsa.pub")
}

resource "aws_lb" "lb_app" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [
    var.public_subnet_a_id,
    var.public_subnet_b_id
  ]
  enable_deletion_protection = false

  tags = {
    Name = var.alb_name
  }
}

resource "aws_lb_target_group" "app_vms" {
  name     = "tf-app-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags = {
    Name = "WT-lb_target_groupe-apps_vms"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb_app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_vms.arn
  }
}

resource "aws_lb_listener" "https" {
  count             = var.enable_https ? 1 : 0
  load_balancer_arn = aws_lb.lb_app.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_vms.arn
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment_a" {
  target_group_arn = aws_lb_target_group.app_vms.arn
  target_id        = var.ec2_app_a_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg_attachment_b" {
  target_group_arn = aws_lb_target_group.app_vms.arn
  target_id        = var.ec2_app_b_id
  port             = 80
}
