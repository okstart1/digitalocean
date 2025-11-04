#!/bin/bash

# Local development script for the DigitalOcean Go app

echo "🚀 Starting Go application locally..."

# Set local port (different from production port 80)
export PORT=8080

# Initialize Go module if needed
if [ ! -f "go.mod" ]; then
    echo "📦 Initializing Go module..."
    go mod init digitalocean-app
fi

# Download dependencies
echo "📥 Downloading dependencies..."
go mod tidy

# Build and run the application
echo "🔨 Building application..."
go build -o bin/hello .

echo "▶️  Starting server on http://localhost:${PORT}"
echo "   Press Ctrl+C to stop"
echo ""

# Run the application
./bin/hello