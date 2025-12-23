output "ami_id" {
  description = "Ubuntu 24.04 LTS AMI ID (Canonical)"
  value       = data.aws_ami.ubuntu.id
}

output "public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web_server.public_ip
}

output "public_dns" {
  description = "Public DNS of the web server"
  value       = aws_instance.web_server.public_dns
}

output "access_url" {
  description = "URL to access the page (open in browser)"
  value       = "http://${aws_instance.web_server.public_dns}"
}