#!/bin/bash
apt-get update -y
apt-get install nginx -y

cat <<EOT > /var/www/html/index.html

<html>
<head><title>Terraform Nginx</title></head>
<body>
<h1>Welcome to the Terraform-managed Nginx Server on Ubuntu</h1>
</body>
</html>
EOT

systemctl start nginx
systemctl enable nginx