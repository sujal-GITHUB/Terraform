output "aws_instance_ip" {
  value = aws_instance.myserver.public_ip
}