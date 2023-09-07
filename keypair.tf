resource "aws_key_pair" "graylog_keypair" {
    key_name = "graylog_key"
    public_key = tls_private_key.rsa.public_key_openssh 

}
resource "tls_private_key" "rsa" {
    algorithm = "RSA"
    rsa_bits = 4096
  
}
resource "local_file" "graylog_local" {
  filename = "graylog"
  file_permission = "0400"
  content = tls_private_key.rsa.private_key_pem
}