resource "aws_vpc" "graylog_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
  
}
resource "aws_subnet" "graylog_public" {
    count =2
    vpc_id = aws_vpc.graylog_vpc.id
    cidr_block = "10.0.${count.index}/24"
    tags = {
      Name = "Graylog_public_subnet"
    }
  
}
resource "aws_internet_gateway" "graylog_IGW" {
  vpc_id = aws_vpc.graylog_vpc.id
  tags ={
     Name = "Graylog-IGW"
  }
}
resource "aws_route_table" "graylog_routetable" {
    vpc_id = aws_vpc.graylog_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.graylog_IGW.id
    }
  
}


resource "aws_route_table_association" "graylog_assosciation" {
    count = 2
    subnet_id = aws_subnet.graylog_public[count.index].id
    route_table_id = aws_route_table.graylog_routetable.id
  
}