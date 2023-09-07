resource "aws_lb" "graylog_alb" {
    name     = "graylog-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb_sg.id]
    subnets = [aws_subnet.graylog_public[*].id]
  
}



resource "aws_security_group" "alb_sg" {
    name = "graylog-alb-sg"
    vpc_id = aws_vpc.graylog_vpc.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

resource "aws_lb_listener" "graylog_listener" {
    load_balancer_arn = aws_lb.graylog_alb.arn
    port = 80
    protocol = "HTTP"
    default_action {
      type = "forward"
      target_group_arn = aws_alb_target_group.graylog_tg.arn
    }

  
}

resource "aws_alb_target_group" "graylog_tg" {
    name = "graylog-tg"
    target_type = "ip"
    port = 9000
    protocol = "HTTP"
    vpc_id = aws_vpc.graylog_vpc.id

    health_check {
      interval = 120
      path = "/"
      protocol = "HTTP"
      timeout = 5
      healthy_threshold = 3
      unhealthy_threshold = 2
    }
  
}
resource "aws_lb_target_group_attachment" "graylog_tg_attach" {
   target_group_arn = aws_alb_target_group.graylog_tg.arn
   target_id = aws_instance.graylog_instance.id
   port = 9000
  
}
resource "aws_lb_listener_rule" "graylog_listener_rule" {
    listener_arn = aws_lb_listener.graylog_listener.arn
    action {
      type = "forward"
      target_group_arn = aws_alb_target_group.graylog_tg.arn
    }

    condition {
      host_header {
        values = ["logs.weguard.ai/"]
      }
    }
  
}