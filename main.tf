data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (official Ubuntu)

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "web_sg" {
  name_prefix = "ubuntu-web-server-sg-"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ubuntu-web-server-sg"
  }
}

resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    # Wait for cloud-init (Ubuntu best practice)
    cloud-init status --wait

    # Update and install nginx
    apt-get update -y
    apt-get upgrade -y
    apt-get install -y nginx

    # Start and enable nginx
    systemctl start nginx
    systemctl enable nginx

    # Allow HTTP/SSH in UFW (Ubuntu firewall)
    ufw --force enable
    ufw allow 80/tcp
    ufw allow 22/tcp

    # Custom HTML page
    cat <<EOT > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Welcome from Ubuntu</title>
  <style>
    body { font-family: Arial, sans-serif; text-align: center; margin-top: 100px; background-color: #f4f4f4; }
    h1 { color: #007bff; }
  </style>
</head>
<body>
  <h1>Dolapo FashinaI</h1>
  <p>This web server runs on Ubuntu 24.04 LTS, provisioned with Terraform on AWS EC2.</p>
  <p>Public IP: <span id="ip"></span></p>
  <script>document.getElementById('ip').textContent = location.hostname;</script>
</body>
</html>
    EOT

    # Set proper ownership/permissions
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
  EOF

  tags = {
    Name = "cloutertech-ubuntu-web-server"
  }
}