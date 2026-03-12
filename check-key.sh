#!/bin/bash

# Quick check for EC2 key pair (e.g. swe645.pem)
# Usage: ./check-key.sh [path-to-key.pem]

KEY="${1:-swe645.pem}"

echo "Checking key file: $KEY"
echo ""

if [ ! -f "$KEY" ]; then
    echo "❌ File not found: $KEY"
    echo "   Use full path, e.g.: ./check-key.sh $HOME/Downloads/swe645.pem"
    exit 1
fi

PERMS=$(ls -l "$KEY" | awk '{print $1}')
if [ "$PERMS" = "-r--------" ] || [ "$PERMS" = "-rw-------" ]; then
    echo "✓ Permissions OK ($PERMS)"
else
    echo "⚠️  Permissions are $PERMS (should be -r-------- or -rw-------). Run: chmod 400 \"$KEY\""
fi

if head -1 "$KEY" | grep -q "BEGIN.*PRIVATE KEY"; then
    echo "✓ File looks like a private key"
else
    echo "❌ File does not look like a PEM private key (first line should contain BEGIN ... PRIVATE KEY)"
fi

if grep -q $'\r' "$KEY" 2>/dev/null; then
    echo "⚠️  File has Windows line endings (CRLF). Run: sed -i '' 's/\\r\$//' \"$KEY\""
else
    echo "✓ No Windows line endings detected"
fi

echo ""
echo "Test SSH (replace EC2_IP and USER with your values):"
echo "  ssh -i \"$KEY\" ec2-user@EC2_IP   # Amazon Linux"
echo "  ssh -i \"$KEY\" ubuntu@EC2_IP     # Ubuntu"
echo ""
