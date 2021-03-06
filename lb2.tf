#tg-1

resource "aws_lb_target_group" "my-target-group" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "my-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.Main.id
}

resource "aws_lb_target_group_attachment" "my-alb-target-group-attachment1" {
  target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
  target_id        = aws_instance.web-1.id
  port             = 80
}

#tg-2

resource "aws_lb_target_group" "my-target-group-2" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "my-target-group-2"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.Main.id
}


resource "aws_lb_target_group_attachment" "my-alb-target-group-attachment2" {
  target_group_arn = "${aws_lb_target_group.my-target-group-2.arn}"
  target_id        = aws_instance.web-2.id
  port             = 80
}

resource "aws_lb" "my-aws-alb" {
  name     = "my-test-alb"
  internal = false

  security_groups = [
    "${aws_security_group.my-alb-sg.id}",
  ]
  subnets = [
    "${aws_subnet.publicsubnets.id}",
    "${aws_subnet.publicsubnets-2.id}",
  ]

  tags = {
    Name = "my-test-alb"
  }

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}

resource "aws_lb_listener" "my-test-alb-listner" {
  load_balancer_arn = "${aws_lb.my-aws-alb.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
  }
}

resource "aws_lb_listener_rule" "s1" {
  listener_arn = aws_lb_listener.my-test-alb-listner.arn
  #priority     = 50

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-target-group.arn
  }

  condition {
    path_pattern {
      values = ["/s1/*"]
    }
  }
}

resource "aws_lb_listener_rule" "s2" {
  listener_arn = aws_lb_listener.my-test-alb-listner.arn
 # priority     = 50

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-target-group-2.arn
  }

  condition {
    path_pattern {
      values = ["/s2/*"]
    }
  }
}
resource "aws_security_group" "my-alb-sg" {
  name   = "my-alb-sg"
  vpc_id = aws_vpc.Main.id
}

resource "aws_security_group_rule" "inbound_ssh" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.my-alb-sg.id}"
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound_http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.my-alb-sg.id}"
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_all" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.my-alb-sg.id}"
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}
