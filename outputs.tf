output "ami_id" {
  description = "Ubuntu 24.04 LTS AMI ID (Canonical)"
  value       = data.aws_ami.ubuntu.id
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web_server.id
}

output "public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web_server.public_ip
}

output "private_ip" {
  description = "Private IP of the web server"
  value       = aws_instance.web_server.private_ip
}

output "public_dns" {
  description = "Public DNS of the web server"
  value       = aws_instance.web_server.public_dns
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.web_sg.id
}

output "access_url_http" {
  description = "URL to access the page via HTTP (open in browser)"
  value       = "http://${aws_instance.web_server.public_dns}"
}

output "access_url_https" {
  description = "URL to access the page via HTTPS (requires SSL certificate)"
  value       = "https://${aws_instance.web_server.public_dns}"
}