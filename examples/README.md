# Docker Permission Failures Examples

This directory contains practical examples of common Docker permission failures and their fixes.

## Overview

Docker containers run with specific user permissions, and many common failures are related to:
- Missing execute permissions on scripts
- Wrong file ownership
- Missing directories or incorrect working directory permissions

## Examples

### Example 1: Missing Execute Permissions

**Problem**: Script files copied to containers don't have execute permissions by default.

```bash
# This will fail
docker build -f examples/Dockerfile.no-exec-permission -t test-no-exec .
docker run --rm test-no-exec
# Error: exec /app/script.sh: permission denied
```

**Solution**: Add execute permissions with `chmod` or `--chmod` flag.

```bash
# This works
docker build -f examples/Dockerfile.fixed-exec-permission -t test-fixed-exec .
docker run --rm test-fixed-exec
```

### Example 2: Wrong File Ownership

**Problem**: Files owned by root can't be read by non-root users.

```bash
# This will fail
docker build -f examples/Dockerfile.wrong-ownership -t test-wrong-owner .
docker run --rm test-wrong-owner
# Error: cat: /app/config.txt: Permission denied
```

**Solution**: Use `--chown` flag in COPY command or `chown` after copying.

```bash
# This works
docker build -f examples/Dockerfile.fixed-ownership -t test-fixed-owner .
docker run --rm test-fixed-owner
```



## Common Permission Patterns

### 1. Script Permissions
```dockerfile
# Wrong - no execute permission
COPY script.sh /app/
ENTRYPOINT ["/app/script.sh"]

# Right - add execute permission
COPY script.sh /app/
RUN chmod +x /app/script.sh
ENTRYPOINT ["/app/script.sh"]

# Alternative - set permission during copy (newer Docker versions)
COPY --chmod=755 script.sh /app/
ENTRYPOINT ["/app/script.sh"]
```

### 2. File Ownership
```dockerfile
# Wrong - files owned by root, user can't access
COPY config.txt /app/
USER appuser
CMD ["cat", "/app/config.txt"]

# Right - set correct ownership
COPY --chown=appuser:appuser config.txt /app/
USER appuser
CMD ["cat", "/app/config.txt"]
```

### 3. Directory Permissions
```dockerfile
# Wrong - user can't write to root-owned directory
WORKDIR /app
COPY . .
USER appuser
RUN echo "test" > newfile.txt

# Right - ensure user owns the directory
WORKDIR /app
COPY --chown=appuser:appuser . .
USER appuser
RUN echo "test" > newfile.txt
```

### 4. User Creation Best Practices
```dockerfile
# Create user with home directory and proper UID
RUN adduser -D -u 1000 appuser

# Or for systems that use useradd
RUN useradd -r -u 1000 -d /home/appuser -m appuser

# Ensure user has access to needed directories
RUN mkdir -p /app/data && chown -R appuser:appuser /app
USER appuser
```

## Testing Commands

You can test all examples with these commands:

```bash
# Test failing examples (these should fail)
docker build -f examples/Dockerfile.no-exec-permission -t fail-exec . && docker run --rm fail-exec
docker build -f examples/Dockerfile.wrong-ownership -t fail-owner . && docker run --rm fail-owner

# Test fixed examples (these should work)
docker build -f examples/Dockerfile.fixed-exec-permission -t fixed-exec . && docker run --rm fixed-exec
docker build -f examples/Dockerfile.fixed-ownership -t fixed-owner . && docker run --rm fixed-owner
```

## Security Best Practices

1. **Always use non-root users** in production containers
2. **Use minimal file permissions** (644 for files, 755 for executables)
3. **Set explicit user IDs** to avoid conflicts with host systems
4. **Minimize attack surface** by only installing necessary packages
5. **Use multi-stage builds** to avoid including build tools in final image

## Volume Mount Permissions

When using volumes, ensure the container user ID matches the host user or use proper permission handling:

```dockerfile
# Use consistent UID that matches host user
RUN adduser -D -u 1000 appuser
USER 1000

# Or handle permissions in entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
```

Example entrypoint.sh:
```bash
#!/bin/sh
# Fix permissions for mounted volumes
if [ -d "/data" ]; then
    chown -R $(id -u):$(id -g) /data 2>/dev/null || true
fi
exec "$@"
```