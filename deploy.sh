#!/bin/bash

# SWE642 Assignment Deployment Script
# This script uploads all necessary files to AWS S3

echo "=================================="
echo "SWE642 Assignment Deployment Script"
echo "=================================="
echo ""

# Prompt for bucket name
read -p "Enter your S3 bucket name: " BUCKET_NAME

if [ -z "$BUCKET_NAME" ]; then
    echo "Error: Bucket name cannot be empty"
    exit 1
fi

echo ""
echo "Bucket: $BUCKET_NAME"
echo ""
read -p "Is this correct? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo "Deployment cancelled."
    exit 0
fi

echo ""
echo "Uploading files to S3..."
echo ""

# Upload HTML file
echo "Uploading index.html..."
aws s3 cp index.html "s3://$BUCKET_NAME/" --acl public-read

# Upload JSON file
echo "Uploading zipcodes.json..."
aws s3 cp zipcodes.json "s3://$BUCKET_NAME/" --acl public-read

# Upload image if exists
if [ -f "photo apr 25 2024, 9 05 33 pm.JPG" ]; then
    echo "Uploading profile image..."
    aws s3 cp "photo apr 25 2024, 9 05 33 pm.JPG" "s3://$BUCKET_NAME/" --acl public-read
fi

echo ""
echo "✓ Upload complete!"
echo ""
echo "=================================="
echo "Your website should be available at:"
echo "http://$BUCKET_NAME.s3-website-us-east-1.amazonaws.com"
echo ""
echo "Note: Make sure static website hosting is enabled in your S3 bucket settings."
echo "=================================="

