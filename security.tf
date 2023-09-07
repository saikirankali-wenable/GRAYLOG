resource "aws_security_group" "graylog_sg" {
    vpc_id = aws_vpc.graylog_vpc.id
    name = "graylog_sg"
    description = "setting up security group for graylog server"
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "to ssh into ec2"
    }
    ingress {
        from_port = 9000
        to_port = 9000
        protocol = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
        description = "to access graylog web interface"

    }
    
    
    ingress {
        from_port = 12201
        to_port = 12201
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "sending logs to graylog"
    }
    ingress {
        from_port = 9200
        to_port = 9200
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "graylog to elasticSearch"
    }
    ingress {
        from_port = 27017
        to_port = 27017 
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Graylog to MongoDB "
    }
   

}
