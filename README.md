# Cloutertech Terraform AWS EC2 Setup

A production-ready Terraform configuration for provisioning an Ubuntu 24.04 LTS web server on AWS EC2 with security best practices.

## Features

✅ **Security Hardening**
- IMDSv2 enforcement (Instance Metadata Service v2 required)
- EBS volume encryption
- Restricted security group rules (configurable CIDR blocks)
- Proper SSH, HTTP, and HTTPS port management
- Firewall (UFW) configuration

✅ **Infrastructure Best Practices**
- Modular configuration with clear separation of concerns
- Comprehensive tagging strategy
- Detailed CloudWatch monitoring support
- EBS volume optimization (gp3 with encryption)
- Cloud-init with proper logging

✅ **Ease of Use**
- Example terraform.tfvars file
- Multiple output values for easy access
- Template-based user data script
- Environment-aware configuration

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- AWS account with EC2 permissions
- (Optional) SSH key pair created in your AWS region

## Quick Start

### 1. Clone and Setup

```bash
cd cloutertech-terraform
cp terraform.tfvars.example terraform.tfvars
```

### 2. Configure Variables

Edit `terraform.tfvars`:

```hcl
region              = "eu-central-1"
environment         = "dev"
application_name    = "cloutertech"
instance_type       = "t3.micro"
key_name            = "your-ssh-key-pair"  # Optional

# Restrict SSH access to your IP
allowed_ssh_cidr    = ["YOUR_IP/32"]  # e.g., ["203.0.113.42/32"]
```

### 3. Initialize and Deploy

```bash
terraform init
terraform plan
terraform apply
```

### 4. Access Your Server

After deployment, outputs will show:
- `access_url_http` - HTTP endpoint
- `public_ip` - Instance IP address
- `public_dns` - DNS name

```bash
# Get outputs
terraform output

# Example output
access_url_http = "http://ec2-1-2-3-4.eu-central-1.compute.amazonaws.com"
public_ip = "1.2.3.4"
```

## Architecture

```
┌─────────────────────────────────┐
│      AWS EC2 Instance           │
│  (Ubuntu 24.04 LTS t3.micro)    │
├─────────────────────────────────┤
│  • Nginx Web Server             │
│  • EBS gp3 Volume (encrypted)   │
│  • CloudWatch Monitoring        │
│  • UFW Firewall                 │
└─────────────────────────────────┘
         │
         ├── Security Group
         │   ├── HTTP (80)
         │   ├── HTTPS (443)
         │   └── SSH (22)
         │
         └── Public IP Assignment
```

## Configuration Options

### Key Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `region` | string | `eu-central-1` | AWS region |
| `environment` | string | `dev` | Environment name (dev/staging/prod) |
| `instance_type` | string | `t3.micro` | EC2 instance type |
| `root_volume_size` | number | `20` | Root volume size in GiB |
| `allowed_http_cidr` | list(string) | `["0.0.0.0/0"]` | Allowed CIDR for HTTP |
| `allowed_https_cidr` | list(string) | `["0.0.0.0/0"]` | Allowed CIDR for HTTPS |
| `allowed_ssh_cidr` | list(string) | `[]` | Allowed CIDR for SSH |
| `enable_detailed_monitoring` | bool | `false` | Enable CloudWatch detailed monitoring |

### Security Group Defaults

- **HTTP (80)**: Open to world (configurable)
- **HTTPS (443)**: Open to world (configurable)
- **SSH (22)**: Closed by default - set `allowed_ssh_cidr` to enable
- **Egress**: All outbound traffic allowed

## Outputs

- `ami_id` - Ubuntu AMI ID used
- `instance_id` - EC2 Instance ID
- `public_ip` - Public IP address
- `private_ip` - Private IP address
- `public_dns` - Public DNS name
- `security_group_id` - Security Group ID
- `access_url_http` - HTTP access URL
- `access_url_https` - HTTPS access URL (requires SSL)

## Security Best Practices Implemented

1. **IMDSv2 Enforcement** - Instance metadata service v2 only (prevents SSRF attacks)
2. **EBS Encryption** - All volumes encrypted by default
3. **Security Groups** - Least privilege access rules
4. **No Public SSH by Default** - SSH access must be explicitly enabled
5. **Firewall** - UFW enabled on instance
6. **Resource Tagging** - All resources properly tagged for cost tracking
7. **Monitoring Ready** - CloudWatch monitoring can be enabled

## Cost Optimization

- **t3.micro** - Free tier eligible (if within first 12 months)
- **gp3 volumes** - Better price-to-performance than gp2
- **Stopped instances** - EBS costs only ~$0.11/month per volume
- **Data transfer** - Minimized by using within same region

**Estimated monthly cost (non-free tier)**:
- EC2 t3.micro: ~$7/month
- EBS 20GB gp3: ~$1.70/month
- Data transfer: Minimal
- **Total: ~$8.70/month**

## Maintenance & Updates

### Update Terraform Version

```bash
terraform version
# Update to latest provider versions
terraform init -upgrade
```

### Apply Updates

```bash
# Plan changes without applying
terraform plan

# Apply updates
terraform apply
```

### Destroy Resources

```bash
# Destroy all resources
terraform destroy
```

## Troubleshooting

### SSH Connection Issues

```bash
# Check security group allows your IP
terraform output security_group_id

# Test connection
ssh -i your-key.pem ubuntu@<public_ip>
```

### Instance Status Checks

```bash
# View instance details
aws ec2 describe-instances \
  --instance-ids $(terraform output -raw instance_id) \
  --region $(terraform output -raw region | tail -1)
```

### User Data Logs

```bash
# SSH into instance and check logs
sudo tail -f /var/log/user_data.log
```

## File Structure

```
.
├── main.tf              # EC2 and security group resources
├── variables.tf         # Input variables with validation
├── outputs.tf          # Output values
├── providers.tf        # AWS provider configuration
├── locals.tf           # Local values and naming conventions
├── user_data.sh        # EC2 startup script
├── terraform.tfvars.example  # Example configuration
├── .gitignore          # Git ignore rules
└── README.md           # This file
```

## Contributing & Support

For issues or improvements:
1. Test changes locally with `terraform plan`
2. Ensure all security best practices are maintained
3. Update documentation accordingly
4. Test in a non-production environment first

## License

This configuration is provided as-is for use with AWS infrastructure.

## Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS EC2 Security Best Practices](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security.html)
- [Ubuntu on AWS](https://ubuntu.com/aws)
- [Terraform Best Practices](https://www.terraform.io/docs/language/settings/index.html)
