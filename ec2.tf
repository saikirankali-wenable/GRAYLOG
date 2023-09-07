resource "aws_instance" "graylog_instance" {
    ami = "ami-03f65b8614a860c29"
    instance_type = var.instance
    vpc_security_group_ids = [aws_security_group.graylog_sg.id]
    subnet_id = aws_subnet.graylog_public[*].id
    key_name = "graylog_key"
    

    root_block_device{
        volume_type = "gp3"  # additional storage required for storing logs
        volume_size = 40
        delete_on_termination = true 
    }
    user_data = <<-EOF
             apt-get install apt-transport-https openjdk-8-jre-headless uuid-runtime pwgen
             apt-get install mongodb-server
             wget -qO – https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add –
             echo “deb https://artifacts.elastic.co/packages/5.x/apt stable main” | tee -a /etc/apt/sources.list.d/elastic-5.x.list
             apt-get update && apt-get install elasticsearch
             nano /etc/elasticsearch/elasticsearch.yml > /dev/null <<EOT
             cluster.name: graylog
             action.auto_create_index: false
             EOT


             systemctl daemon-reload
             systemctl enable elasticsearch.service
             systemctl restart elasticsearch.service
             
             wget https://packages.graylog2.org/repo/packages/graylog-2.5-repository_latest.deb
             dpkg -i graylog-2.5-repository_latest.deb
             apt-get update && apt-get install graylog-server
             
      EOF


}