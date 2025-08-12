# Docker Hooks Usage

This repository now supports Docker-based pre-commit hooks that don't require local tool installation.

## Quick Start

1. **Use Docker hooks in your `.pre-commit-config.yaml`:**

```yaml
repos:
- repo: https://github.com/actuarysailor/pre-commit-terraform
  rev: feat/use-docker-pre-commit
  hooks:
    - id: terraform_fmt_docker
    - id: terraform_validate_docker
    - id: terraform_docs_docker
    - id: terraform_checkov_docker
    - id: terraform_trivy_docker
```

2. **Install and run:**

```bash
pre-commit install
pre-commit run --all-files
```

## Available Docker Hooks

| Hook ID | Description | Tools Used |
|---------|-------------|------------|
| `terraform_fmt_docker` | Format Terraform files | terraform |
| `terraform_validate_docker` | Validate Terraform files | terraform |
| `terraform_docs_docker` | Generate documentation | terraform-docs |
| `terraform_tflint_docker` | Lint Terraform files | tflint |
| `terraform_checkov_docker` | Security scanning | checkov |
| `terraform_trivy_docker` | Security scanning | trivy |
| `infracost_breakdown_docker` | Cost analysis | infracost |

## Benefits

- ✅ **No local installation** required for terraform, tflint, checkov, etc.
- ✅ **Consistent versions** across team members
- ✅ **Isolated environment** prevents dependency conflicts
- ✅ **Easy setup** - just requires Docker

## Prerequisites

- Docker installed and accessible
- For non-root users: `sudo usermod -aG docker $USER` (then logout/login)

## Advanced Usage

### Mix Docker and Local Hooks

```yaml
repos:
- repo: https://github.com/actuarysailor/pre-commit-terraform
  rev: feat/use-docker-pre-commit
  hooks:
    # Use Docker for tools you don't have locally
    - id: terraform_checkov_docker
    - id: terraform_trivy_docker
    
    # Use local for tools you have installed
    - id: terraform_fmt      # requires local terraform
    - id: terraform_validate # requires local terraform
```

### Build Tools Image Locally

```bash
git clone https://github.com/actuarysailor/pre-commit-terraform.git
cd pre-commit-terraform
docker build -f Dockerfile.tools -t ghcr.io/actuarysailor/pre-commit-terraform-tools:latest .
```

## Troubleshooting

### Permission Issues
```bash
# Add user to docker group
sudo usermod -aG docker $USER
# Then logout and login again
```

### Image Not Found
```bash
# Pull the latest image
docker pull ghcr.io/actuarysailor/pre-commit-terraform-tools:latest
```

## Migration from Script Hooks

Simply change the hook IDs in your `.pre-commit-config.yaml`:

```yaml
# Before (requires local tools)
- id: terraform_fmt
- id: terraform_validate

# After (uses Docker)
- id: terraform_fmt_docker
- id: terraform_validate_docker
```
