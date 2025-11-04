#!/bin/bash

# Test script for IP validation functionality

echo "🧪 Testing IP validation functionality..."
echo "Make sure the server is running on localhost:8080"
echo ""

PORT=${PORT:-8080}
BASE_URL="http://localhost:${PORT}"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to test endpoint
test_endpoint() {
    local host="$1"
    local expected_status="$2"
    local description="$3"

    echo -e "${BLUE}Testing:${NC} $description"
    echo "Host header: $host"

    if [ -z "$host" ]; then
        response=$(curl -s -w "%{http_code}" "$BASE_URL/" -o /tmp/response.txt)
    else
        response=$(curl -s -w "%{http_code}" -H "Host: $host" "$BASE_URL/" -o /tmp/response.txt)
    fi

    status_code=$response
    body=$(cat /tmp/response.txt)

    if [ "$status_code" = "$expected_status" ]; then
        echo -e "${GREEN}✅ PASS${NC} - Status: $status_code"
    else
        echo -e "${RED}❌ FAIL${NC} - Expected: $expected_status, Got: $status_code"
    fi

    echo "Response: $body"
    echo ""
}

# Test cases
echo "🔍 Running test cases..."
echo ""

# Test 1: Valid domain name (should work)
test_endpoint "myapp.com" "200" "Valid domain name access"

# Test 2: Direct IP access (should be blocked)
test_endpoint "127.0.0.1:8080" "403" "Direct IP access (should be blocked)"

# Test 3: IPv4 without port (should be blocked)
test_endpoint "192.168.1.1" "403" "IPv4 access without port (should be blocked)"

# Test 4: IPv6 access (should be blocked)
test_endpoint "[::1]:8080" "403" "IPv6 access (should be blocked)"

# Test 5: localhost (should be blocked as it resolves to IP)
test_endpoint "localhost" "403" "localhost access (should be blocked)"

# Test 6: Empty host header (should return 400)
test_endpoint "" "400" "Empty host header (should return 400)"

# Test 7: Another valid domain
test_endpoint "example.com" "200" "Another valid domain"

echo "🏁 Test completed!"
echo ""
echo "Expected results:"
echo "- Domain names (myapp.com, example.com): ✅ 200 OK"
echo "- IP addresses (127.0.0.1, 192.168.1.1, ::1): ❌ 403 Forbidden"
echo "- localhost: ❌ 403 Forbidden"
echo "- Empty host: ❌ 400 Bad Request"

# Cleanup
rm -f /tmp/response.txt