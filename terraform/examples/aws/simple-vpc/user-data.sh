#!/bin/bash

# User data script for web servers
# This script will be executed when the EC2 instance starts

# Update system packages
yum update -y

# Install Apache web server
yum install -y httpd

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create a simple HTML page
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hybrid Cloud Playbook - ${project_name}</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .info {
            background-color: #e8f4f8;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .success {
            color: #28a745;
            font-weight: bold;
        }
        .code {
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 5px;
            font-family: monospace;
            border-left: 4px solid #007bff;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Hybrid Cloud Playbook</h1>
        <div class="info">
            <h2>Welcome to ${project_name}</h2>
            <p class="success">✅ Your web server is running successfully!</p>
            <p>This is a demonstration of the Hybrid Cloud Playbook AWS example.</p>
        </div>
        
        <h3>Server Information</h3>
        <div class="code">
            <strong>Instance ID:</strong> <span id="instance-id">Loading...</span><br>
            <strong>Availability Zone:</strong> <span id="az">Loading...</span><br>
            <strong>Instance Type:</strong> <span id="instance-type">Loading...</span><br>
            <strong>Local IP:</strong> <span id="local-ip">Loading...</span><br>
            <strong>Public IP:</strong> <span id="public-ip">Loading...</span>
        </div>
        
        <h3>Architecture Features</h3>
        <ul>
            <li>Multi-AZ deployment for high availability</li>
            <li>Auto Scaling Group for elasticity</li>
            <li>Application Load Balancer for distribution</li>
            <li>Public and private subnets</li>
            <li>NAT Gateway for private subnet internet access</li>
        </ul>
        
        <h3>Health Check</h3>
        <div class="info">
            <p>Status: <span class="success">Healthy</span></p>
            <p>Load Balancer: Active</p>
            <p>Last Updated: <span id="timestamp"></span></p>
        </div>
        
        <footer style="margin-top: 30px; text-align: center; color: #666;">
            <p>Hybrid Cloud Playbook - AWS Simple VPC Example</p>
        </footer>
    </div>
    
    <script>
        // Fetch instance metadata
        async function fetchMetadata() {
            try {
                const token = await fetch('http://169.254.169.254/latest/api/token', {
                    method: 'PUT',
                    headers: {
                        'X-aws-ec2-metadata-token-ttl-seconds': '21600'
                    }
                }).then(response => response.text());
                
                const headers = {
                    'X-aws-ec2-metadata-token': token
                };
                
                const instanceId = await fetch('http://169.254.169.254/latest/meta-data/instance-id', {headers})
                    .then(response => response.text());
                const az = await fetch('http://169.254.169.254/latest/meta-data/placement/availability-zone', {headers})
                    .then(response => response.text());
                const instanceType = await fetch('http://169.254.169.254/latest/meta-data/instance-type', {headers})
                    .then(response => response.text());
                const localIp = await fetch('http://169.254.169.254/latest/meta-data/local-ipv4', {headers})
                    .then(response => response.text());
                const publicIp = await fetch('http://169.254.169.254/latest/meta-data/public-ipv4', {headers})
                    .then(response => response.text()).catch(() => 'N/A');
                
                document.getElementById('instance-id').textContent = instanceId;
                document.getElementById('az').textContent = az;
                document.getElementById('instance-type').textContent = instanceType;
                document.getElementById('local-ip').textContent = localIp;
                document.getElementById('public-ip').textContent = publicIp;
            } catch (error) {
                console.error('Error fetching metadata:', error);
            }
        }
        
        // Update timestamp
        function updateTimestamp() {
            document.getElementById('timestamp').textContent = new Date().toLocaleString();
        }
        
        // Initialize
        fetchMetadata();
        updateTimestamp();
        
        // Update timestamp every minute
        setInterval(updateTimestamp, 60000);
    </script>
</body>
</html>
EOF

# Create a health check endpoint
cat > /var/www/html/health << EOF
OK
EOF

# Set proper permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Configure Apache to start on boot
systemctl enable httpd

# Create a simple API endpoint for health checks
cat > /var/www/html/api.php << EOF
<?php
header('Content-Type: application/json');
echo json_encode([
    'status' => 'healthy',
    'timestamp' => date('c'),
    'server' => gethostname(),
    'load_average' => sys_getloadavg()[0]
]);
?>
EOF

# Install PHP if needed
yum install -y php

# Restart Apache to load PHP
systemctl restart httpd

# Configure log rotation
cat > /etc/logrotate.d/httpd << EOF
/var/log/httpd/*log {
    daily
    rotate 52
    compress
    delaycompress
    missingok
    notifempty
    create 640 apache apache
    postrotate
        /bin/systemctl reload httpd.service > /dev/null 2>/dev/null || true
    endscript
}
EOF

# Create a startup script for monitoring
cat > /usr/local/bin/web-server-monitor.sh << EOF
#!/bin/bash
# Simple monitoring script

LOG_FILE="/var/log/web-server-monitor.log"
DATE=\$(date '+%Y-%m-%d %H:%M:%S')

# Check if Apache is running
if systemctl is-active --quiet httpd; then
    echo "[\$DATE] Apache is running" >> \$LOG_FILE
else
    echo "[\$DATE] Apache is not running, attempting to start..." >> \$LOG_FILE
    systemctl start httpd
fi

# Check disk usage
DISK_USAGE=\$(df -h / | awk 'NR==2 {print \$5}' | sed 's/%//')
if [ \$DISK_USAGE -gt 85 ]; then
    echo "[\$DATE] WARNING: Disk usage is at \$DISK_USAGE%" >> \$LOG_FILE
fi

# Check memory usage
MEM_USAGE=\$(free | grep Mem | awk '{printf "%.2f", \$3/\$2 * 100.0}')
if [ \$(echo "\$MEM_USAGE > 90" | bc) -eq 1 ]; then
    echo "[\$DATE] WARNING: Memory usage is at \$MEM_USAGE%" >> \$LOG_FILE
fi
EOF

chmod +x /usr/local/bin/web-server-monitor.sh

# Add monitoring script to cron
echo "*/5 * * * * /usr/local/bin/web-server-monitor.sh" | crontab -

# Send completion signal
echo "User data script completed successfully" > /var/log/user-data.log
date >> /var/log/user-data.log