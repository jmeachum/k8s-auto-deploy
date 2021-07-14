resource "aws_lb" "application-lb" {
  provider           = aws.region
  name               = "k8s-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id, aws_subnet.subnet_2.id]

  tags = {
    "name" = "k8s-LB"
  }
}

resource "aws_lb_target_group" "app-lb-tg" {
  provider    = aws.region
  name        = "app-lb-tg"
  port        = var.webserver-port
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_k8s.id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = var.webserver-port
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    "Name" = "k8s-target-group"
  }

}

resource "aws_lb_listener" "k8s-listener-http" {
  provider          = aws.region
  load_balancer_arn = aws_lb.application-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "k8s-listener-https" {
  provider          = aws.region
  load_balancer_arn = aws_lb.application-lb.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.k8s-lb-https.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-lb-tg.arn
  }
}

resource "aws_lb_target_group_attachment" "k8s-nodes-attach" {
  provider         = aws.region
  target_group_arn = aws_lb_target_group.app-lb-tg.arn
  target_id        = aws_instance.k8s-nodes.id
  port             = var.webserver-port
}