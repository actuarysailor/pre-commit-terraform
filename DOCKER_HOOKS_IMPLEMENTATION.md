# Complete Implementation Guide for Docker-based Pre-commit Hooks

## Problem Analysis
The original Docker image (`ghcr.io/antonbabenko/pre-commit-terraform:latest`) is designed to run the entire pre-commit workflow, not individual tools. Pre-commit's `language: docker_image` expects to call individual tools directly.

## Solution: Two-Image Approach

### 1. Keep Existing Image (Current Workflow)
- `ghcr.io/antonbabenko/pre-commit-terraform:latest` - for full pre-commit execution
- Used as: `docker run ... ghcr.io/antonbabenko/pre-commit-terraform:latest run -a`

### 2. Add New Tools Image (Individual Tool Execution)
- `ghcr.io/antonbabenko/pre-commit-terraform-tools:latest` - for individual tools
- Built from `Dockerfile.tools` 
- Used by pre-commit's docker_image language

## Implementation

### A. Create Dockerfile.tools (Done)
```dockerfile
FROM ghcr.io/antonbabenko/pre-commit-terraform:latest
ENTRYPOINT []
CMD ["bash"]
COPY hooks/ /usr/local/bin/hooks/
COPY lib_getopt /usr/local/bin/
RUN chmod +x /usr/local/bin/hooks/*.sh
```

### B. Build and Publish Tools Image
```bash
docker build -f Dockerfile.tools -t ghcr.io/actuarysailor/pre-commit-terraform-tools:latest .
docker push ghcr.io/actuarysailor/pre-commit-terraform-tools:latest
```

### C. Update .pre-commit-hooks.yaml (Done)
Added Docker-based hooks that reference the tools image.

### D. User Configuration Example
```yaml
repos:
- repo: https://github.com/actuarysailor/pre-commit-terraform
  rev: feat/use-docker-pre-commit
  hooks:
    # Choose either script-based (requires local tools) or Docker-based hooks
    
    # Script-based (current, requires local terraform installation)
    - id: terraform_fmt
    - id: terraform_validate
    
    # OR Docker-based (no local tools required)
    - id: terraform_fmt_docker
    - id: terraform_validate_docker
    - id: terraform_docs_docker
```

## Benefits of This Approach

### Non-Breaking
- Existing users continue to use current hooks without changes
- Current Docker image workflow remains unchanged
- Script-based hooks work exactly as before

### Flexible Choice
- Users can choose script-based OR Docker-based hooks
- Can mix both in same configuration if needed
- Migration path available for teams

### Tool Isolation
- Docker hooks don't require local tool installation
- Consistent tool versions across team members
- No dependency conflicts

## Current Limitations

1. **Docker Permission Issues**: Pre-commit has issues with sudo Docker setups
2. **Container Startup Overhead**: Docker hooks are slightly slower
3. **Volume Mount Requirements**: Need proper file permissions setup

## Testing Status

✅ Docker image builds successfully  
✅ Individual tools work in new image  
✅ Hook configurations are correct  
❌ Pre-commit integration needs Docker permission fixes  

## Next Steps

1. **Publish Tools Image**: Build and push `pre-commit-terraform-tools` image
2. **Fix Docker Permissions**: Add user to docker group OR use Docker Desktop
3. **Documentation**: Update README with Docker hooks usage
4. **CI/CD**: Add automated builds for tools image
