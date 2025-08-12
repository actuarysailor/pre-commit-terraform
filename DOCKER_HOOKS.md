# Docker-based Hooks Documentation

## Overview

This repository now supports Docker-based hooks alongside the traditional script-based hooks. Docker-based hooks provide several advantages:

### Advantages
- **No local tool installation required**: All tools (terraform, tflint, checkov, etc.) are included in the Docker image
- **Consistent tool versions**: Everyone on the team uses the same tool versions
- **Isolated environment**: No conflicts with your local tool installations
- **Easy setup**: Only requires Docker to be installed

### Disadvantages
- **Docker dependency**: Requires Docker to be installed and running
- **Slightly slower**: Container startup adds some overhead
- **More complex debugging**: Issues happen inside containers

## Available Docker Hooks

All Docker-based hooks have the `_docker` suffix to distinguish them from their script-based counterparts:

| Docker Hook ID | Description | Equivalent Script Hook |
|---|---|---|
| `terraform_fmt_docker` | Format Terraform files | `terraform_fmt` |
| `terraform_validate_docker` | Validate Terraform files | `terraform_validate` |
| `terraform_docs_docker` | Generate documentation | `terraform_docs` |
| `terraform_tflint_docker` | Lint with TFLint | `terraform_tflint` |
| `terraform_checkov_docker` | Security scanning with Checkov | `terraform_checkov` |
| `terraform_trivy_docker` | Security scanning with Trivy | `terraform_trivy` |
| `terraform_providers_lock_docker` | Lock provider versions | `terraform_providers_lock` |
| `terragrunt_fmt_docker` | Format Terragrunt files | `terragrunt_fmt` |
| `terragrunt_validate_docker` | Validate Terragrunt files | `terragrunt_validate` |
| `infracost_breakdown_docker` | Cost analysis with Infracost | `infracost_breakdown` |

## Usage

### Basic Configuration

```yaml
repos:
- repo: https://github.com/antonbabenko/pre-commit-terraform
  rev: v1.93.0  # Use the latest version
  hooks:
    - id: terraform_fmt_docker
    - id: terraform_validate_docker
    - id: terraform_docs_docker
```

### Mixed Configuration

You can mix Docker-based and script-based hooks in the same configuration:

```yaml
repos:
- repo: https://github.com/antonbabenko/pre-commit-terraform
  rev: v1.93.0
  hooks:
    # Use Docker for tools you don't have installed
    - id: terraform_checkov_docker
    - id: terraform_trivy_docker
    
    # Use local tools for faster execution
    - id: terraform_fmt        # Requires local terraform
    - id: terraform_validate   # Requires local terraform
```

### Arguments and Configuration

Docker-based hooks support the same arguments as their script-based counterparts:

```yaml
- id: terraform_tflint_docker
  args:
    - --args=--config=.tflint.hcl
    - --args=--call-module-type=all

- id: terraform_docs_docker
  args:
    - --hook-config=--path-to-file=README.md
    - --hook-config=--add-to-existing-file=true
```

## Requirements

1. **Docker**: Install Docker on your system
   ```bash
   # Ubuntu/Debian
   sudo apt-get install docker.io
   
   # macOS
   brew install docker
   
   # Or download from https://docs.docker.com/get-docker/
   ```

2. **Docker permissions**: Ensure your user can run Docker commands
   ```bash
   sudo usermod -a -G docker $USER
   # Log out and back in for changes to take effect
   ```

## Docker Image Customization

If you want to use a specific version of tools or a custom Docker image:

```yaml
- id: terraform_fmt_docker
  # Use a specific tag for reproducibility
  docker_image: ghcr.io/antonbabenko/pre-commit-terraform:v1.93.0
  
- id: terraform_validate_docker
  # Use your custom image
  docker_image: my-registry.com/my-custom-pre-commit-terraform:latest
```

## Building Your Own Docker Image

To build a custom Docker image with specific tool versions:

```bash
git clone https://github.com/antonbabenko/pre-commit-terraform.git
cd pre-commit-terraform

# Build with all tools
docker build -t my-pre-commit-terraform --build-arg INSTALL_ALL=true .

# Build with specific tool versions
docker build -t my-pre-commit-terraform \
  --build-arg TERRAFORM_VERSION=1.5.7 \
  --build-arg CHECKOV_VERSION=2.4.0 \
  --build-arg TFLINT_VERSION=0.47.0 \
  .
```

## Troubleshooting

### Permission Issues
If you encounter permission issues:
```bash
# Make sure your user is in the docker group
sudo usermod -a -G docker $USER
# Log out and back in

# Or run with sudo (not recommended for regular use)
sudo pre-commit run -a
```

### Slow Performance
Docker hooks are slower due to container startup. To improve performance:
- Use local hooks for tools you use frequently
- Use Docker hooks for tools that are hard to install or maintain
- Consider running hooks only on changed files instead of all files

### Custom Tool Configurations
If you need to pass configuration files to the tools:
```yaml
- id: terraform_tflint_docker
  args:
    - --args=--config=${PWD}/.tflint.hcl  # Use absolute path
```
