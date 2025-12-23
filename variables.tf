variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Optional SSH key pair name (user: ubuntu)"
  type        = string
  default     = null
}

variable "ami_name_pattern" {
  description = "Ubuntu AMI name filter (latest 24.04 LTS)"
  type        = string
  default     = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
}