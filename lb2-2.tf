#tg-3

resource "aws_lb_target_group" "my-tg-terra" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "my-tg-terra"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.Main.id
}

resource "aws_lb_target_group_attachment" "my-alb-target-group-attachment3" {
  target_group_arn = "${aws_lb_target_group.my-tg-terra.arn}"
  target_id        = aws_instance.server-1.id
  port             = 80
}

#tg-4

resource "aws_lb_target_group" "my-tg-terra-2" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "my-tg-terra-2"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.Main.id
}

resource "aws_lb_target_group_attachment" "my-alb-target-group-attachment4" {
  target_group_arn = "${aws_lb_target_group.my-tg-terra-2.arn}"
  target_id        = aws_instance.server-2.id
  port             = 80
}

resource "aws_lb" "my-aws-alb-2" {
  name     = "my-test-alb-2"
  internal = false

  security_groups = [
    "${aws_security_group.my-alb-sg.id}",
  ]
  subnets = [
    "${aws_subnet.publicsubnets.id}",
    "${aws_subnet.publicsubnets-2.id}",
  ]

  tags = {
    Name = "my-test-alb-2"
  }

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}

resource "aws_lb_listener" "my-test-alb-listner-2" {
  load_balancer_arn = "${aws_lb.my-aws-alb-2.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.my-tg-terra.arn}"
  }
}

resource "aws_lb_listener_rule" "s3" {
  listener_arn = aws_lb_listener.my-test-alb-listner-2.arn
  #priority     = 50

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-tg-terra.arn
  }

  condition {
    path_pattern {
      values = ["/s1/*"]
    }
  }
}

resource "aws_lb_listener_rule" "s4" {
  listener_arn = aws_lb_listener.my-test-alb-listner-2.arn
 # priority     = 50

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-tg-terra-2.arn
  }

  condition {
    path_pattern {
      values = ["/s2/*"]
    }
  }
}
resource "aws_security_group" "my-alb-sg-2" {
  name   = "my-alb-sg-2"
  vpc_id = aws_vpc.Main.id
}

resource "aws_security_group_rule" "inbound_ssh-2" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.my-alb-sg-2.id}"
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound_http-2" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.my-alb-sg-2.id}"
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_all-2" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.my-alb-sg-2.id}"
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}
