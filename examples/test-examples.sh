#!/bin/sh
# Test script to demonstrate Docker permission failures and fixes

echo "========================================="
echo "Docker Permission Failures Examples"
echo "========================================="

echo "\n1. Testing EXECUTE PERMISSION failure..."
echo "Building failing example..."
docker build -f examples/Dockerfile.no-exec-permission -t test-no-exec . -q
echo "Running (this should fail with permission denied):"
docker run --rm test-no-exec 2>&1 || echo "✓ Failed as expected with permission denied"

echo "\n2. Testing EXECUTE PERMISSION fix..."
echo "Building fixed example..."
docker build -f examples/Dockerfile.fixed-exec-permission -t test-fixed-exec . -q
echo "Running (this should work):"
docker run --rm test-fixed-exec

echo "\n3. Testing FILE OWNERSHIP failure..."
echo "Building failing example..."
docker build -f examples/Dockerfile.wrong-ownership -t test-wrong-owner . -q
echo "Running (this should fail with permission denied):"
docker run --rm test-wrong-owner 2>&1 || echo "✓ Failed as expected with permission denied"

echo "\n4. Testing FILE OWNERSHIP fix..."
echo "Building fixed example..."
docker build -f examples/Dockerfile.fixed-ownership -t test-fixed-owner . -q
echo "Running (this should work):"
docker run --rm test-fixed-owner



echo "\n========================================="
echo "All tests completed!"
echo "========================================="

# Cleanup
docker image rm -f test-no-exec test-fixed-exec test-wrong-owner test-fixed-owner 2>/dev/null || true