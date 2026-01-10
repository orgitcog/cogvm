# OpenCog WebVM Development Guide

## Building and Testing Locally

### Prerequisites
- Docker installed
- At least 2GB of free disk space
- i386 platform support (buildx or qemu-user-static)

### Building the Image

```bash
# From the root of the repository
docker build . --tag opencog-webvm --file dockerfiles/opencog_cogserver --platform=i386
```

### Checking Image Size

```bash
docker images opencog-webvm
```

The image should be under 950M (preferably under 800M to account for compression overhead).

### Testing the Image

```bash
# Run the container
docker run -it --rm opencog-webvm

# Inside the container, test OpenCog
cogserver
```

In another terminal:
```bash
# Get the container ID
docker ps

# Connect to the running container
docker exec -it <container-id> bash

# Connect to cogserver
telnet localhost 17001

# Type 'scm' to enter Scheme shell
# Test basic commands:
(use-modules (opencog))
(ConceptNode "test")
```

### Size Optimization Tips

If the image exceeds 950M:

1. **Remove unnecessary Boost libraries**: Only keep the ones we need
2. **Strip binaries more aggressively**: `strip --strip-all` where possible
3. **Remove documentation and man pages**: Add to the cleanup steps
4. **Consider using Alpine base**: Though this may require more work
5. **Minimize guile installation**: Only install core guile without extras

### Debugging Build Issues

Common issues:

1. **Build failures on i386**: Ensure you have buildx or qemu-user-static
2. **Missing dependencies**: Check the Debian package names for bookworm
3. **Runtime errors**: Use `ldd /usr/local/bin/cogserver` to check for missing libraries

### Testing with WebVM

After building:

1. Export the image as tar
2. Convert to ext2 filesystem
3. Deploy to GitHub Pages following the main README
4. Test the Claude AI integration with OpenCog

### Performance Considerations

- WebVM runs significantly slower than native
- CogServer startup may take 10-30 seconds
- Complex queries may take longer to execute
- The virtualization overhead is compensated in the Claude AI system prompt

## Development Workflow

1. Modify Dockerfile
2. Test build locally
3. Check image size
4. Test functionality
5. Commit and push
6. Trigger GitHub Actions workflow
7. Deploy to GitHub Pages
8. Test in browser

## Troubleshooting

### Build takes too long
- Use fewer CPU cores: `make -j2` instead of `make -j$(nproc)`
- Consider caching build artifacts

### Image too large
- Check what's taking space: `docker history opencog-webvm`
- Remove unnecessary files in the final stage
- Use `--no-install-recommends` for apt-get

### Runtime errors
- Check logs: `docker logs <container-id>`
- Verify all libraries are copied: `ldd /usr/local/bin/cogserver`
- Ensure guile modules are in the right path

## Contributing

When contributing OpenCog improvements:

1. Keep changes minimal and focused
2. Test locally before pushing
3. Verify size constraints
4. Update documentation
5. Add examples if adding new features

## Future Enhancements

Potential improvements:

1. Add more OpenCog modules (PLN, attention allocation, etc.)
2. Create more example scripts
3. Improve Claude AI integration with better Atomese translation
4. Add persistent AtomSpace storage
5. Include visualization tools
