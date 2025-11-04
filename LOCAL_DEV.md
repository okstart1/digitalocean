# Local Development Guide

## Quick Start

1. **Install Go** (if not already installed):
   - macOS: `brew install go`
   - Ubuntu: `sudo apt install golang-go`
   - Windows: Download from https://golang.org/dl/

2. **Run the application**:
   ```bash
   # Make script executable (first time only)
   chmod +x run-local.sh

   # Run the app
   ./run-local.sh
   ```

3. **Access the application**:
   - ✅ Working: http://localhost:8080
   - ❌ Blocked: http://127.0.0.1:8080 (will show IP access error)

## Manual Commands

If you prefer to run commands manually:

```bash
# Set local port
export PORT=8080

# Initialize Go module (first time only)
go mod init digitalocean-app

# Download dependencies
go mod tidy

# Run directly without building
go run main.go

# Or build and run
go build -o bin/hello .
./bin/hello
```

## Testing the IP Validation

The app now blocks direct IP access. Test this behavior:

1. **Allowed access** (domain-like):
   ```bash
   curl -H "Host: myapp.com" http://localhost:8080/
   # Should work: "Hello! you've requested /"
   ```

2. **Blocked access** (direct IP):
   ```bash
   curl -H "Host: 127.0.0.1:8080" http://localhost:8080/
   # Should return: "Direct IP access not allowed. Please use the domain name."
   ```

3. **Missing Host header**:
   ```bash
   curl -H "Host:" http://localhost:8080/
   # Should return: "Bad Request: Missing Host header"
   ```

## Development Tips

- The app runs on port 8080 locally (instead of port 80 in production)
- Use `Ctrl+C` to stop the server
- Changes require restarting the server (no hot reload)
- Check logs in the terminal for debugging

## Production vs Local

| Environment | Port | Access Method |
|-------------|------|---------------|
| Local | 8080 | http://localhost:8080 |
| Production | 80/443 | https://your-domain.com |

## Troubleshooting

- **"go: command not found"**: Install Go first
- **"permission denied"**: Run `chmod +x run-local.sh`
- **Port already in use**: Change PORT in the script or kill the process using the port