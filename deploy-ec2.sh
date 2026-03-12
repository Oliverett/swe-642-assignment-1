#!/bin/bash

# SWE642 Assignment EC2 Deployment Script
# This script deploys the website to an Amazon EC2 instance

echo "=================================="
echo "SWE642 Assignment EC2 Deployment Script"
echo "=================================="
echo ""

# Prompt for EC2 connection details
read -p "Enter your EC2 instance IP address or hostname: " EC2_HOST
read -p "Enter your EC2 username (default: ec2-user): " EC2_USER
EC2_USER=${EC2_USER:-ec2-user}
read -p "Enter path to your EC2 private key file (.pem): " EC2_KEY
read -p "Enter web server document root (default: /var/www/html): " WEB_ROOT
WEB_ROOT=${WEB_ROOT:-/var/www/html}

if [ -z "$EC2_HOST" ] || [ -z "$EC2_KEY" ]; then
    echo "Error: EC2 host and key file are required"
    exit 1
fi

if [ ! -f "$EC2_KEY" ]; then
    echo "Error: Key file not found: $EC2_KEY"
    exit 1
fi

echo ""
echo "Deployment Configuration:"
echo "  EC2 Host: $EC2_HOST"
echo "  EC2 User: $EC2_USER"
echo "  Key File: $EC2_KEY"
echo "  Web Root: $WEB_ROOT"
echo ""
read -p "Is this correct? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo "Deployment cancelled."
    exit 0
fi

echo ""
echo "Uploading files to EC2..."
echo ""

# Set proper permissions on key file
chmod 400 "$EC2_KEY"

# Create remote directory if it doesn't exist
ssh -i "$EC2_KEY" "$EC2_USER@$EC2_HOST" "sudo mkdir -p $WEB_ROOT && sudo chown $EC2_USER:$EC2_USER $WEB_ROOT"

# Upload HTML file
echo "Uploading index.html..."
scp -i "$EC2_KEY" "index.html" "$EC2_USER@$EC2_HOST:$WEB_ROOT/"

# Upload JSON file
echo "Uploading zipcodes.json..."
scp -i "$EC2_KEY" "zipcodes.json" "$EC2_USER@$EC2_HOST:$WEB_ROOT/"

# Upload profile image if exists
if [ -f "profile.jpg" ]; then
    echo "Uploading profile image..."
    scp -i "$EC2_KEY" "profile.jpg" "$EC2_USER@$EC2_HOST:$WEB_ROOT/"
fi

# Set proper file permissions
echo "Setting file permissions..."
ssh -i "$EC2_KEY" "$EC2_USER@$EC2_HOST" "sudo chmod 644 $WEB_ROOT/* && sudo chown www-data:www-data $WEB_ROOT/* 2>/dev/null || sudo chown apache:apache $WEB_ROOT/* 2>/dev/null || sudo chown nginx:nginx $WEB_ROOT/* 2>/dev/null"

echo ""
echo "✓ Deployment complete!"
echo ""
echo "=================================="
echo "Your website should be available at:"
echo "http://$EC2_HOST"
echo ""
echo "Note: Make sure your EC2 security group allows HTTP (port 80) and HTTPS (port 443) traffic."
echo "=================================="
