#!/bin/bash

# Install nginx
apt-get update
apt-get install -y nginx

# Create simple HTML page
cat > /var/www/html/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Cloutertech Server</title>
    <style>
        body { font-family: Arial; text-align: center; padding: 50px; }
        h1 { color: #333; }
        .info { background: #f0f0f0; padding: 20px; margin: 20px; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>Welcome to Cloutertech</h1>
    <p>Your web server is running!</p>
    <div class="info">
        <p><strong>Server:</strong> Ubuntu 24.04 LTS</p>
        <p><strong>Provisioned with:</strong> Terraform on AWS EC2 by Dolapo Fashina</p>
    </div>
</body>
</html>
EOF

# Start nginx
systemctl start nginx
systemctl enable nginx