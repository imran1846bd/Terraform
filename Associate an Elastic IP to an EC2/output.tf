output "elastic_ip" {
  value = aws_eip.lb.public_ip
}
output "aws_instance_id" {
  value = aws_instance.web-server.id
}