# GitHub Token Setup for Container Registry

## Current Issue
Your GitHub Personal Access Token doesn't have the required scopes to push to GitHub Container Registry (ghcr.io).

## Required Token Scopes
To push Docker images to `ghcr.io`, your token needs these scopes:

- ✅ `write:packages` - Required to push containers
- ✅ `read:packages` - Required to pull containers  
- ⚠️ `delete:packages` - Optional, for deleting packages

## How to Fix

### Step 1: Update Your GitHub Token
1. Go to GitHub.com → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Find your existing token or create a new one
3. Make sure these scopes are checked:
   - ✅ `write:packages`
   - ✅ `read:packages`
4. Save/Update the token
5. Copy the token value

### Step 2: Update Your Environment Variable
```bash
# Update your GHCR_PAT environment variable with the new token
export GHCR_PAT="your_new_token_here"

# Or add it to your shell profile for persistence
echo 'export GHCR_PAT="your_new_token_here"' >> ~/.bashrc
source ~/.bashrc
```

### Step 3: Login and Push Again
```bash
# Login with the updated token
echo $GHCR_PAT | sudo docker login ghcr.io -u actuarysailor --password-stdin

# Push the image
sudo docker push ghcr.io/actuarysailor/pre-commit-terraform-tools:latest
```

## Alternative: Use GitHub Actions (Recommended)
Instead of manual push, you can use the GitHub Actions workflow we created:

1. Push your code to GitHub:
   ```bash
   git add .
   git commit -m "Add Docker hooks implementation"
   git push origin feat/use-docker-pre-commit
   ```

2. The workflow in `.github/workflows/docker-tools-image.yml` will automatically:
   - Build the Docker image
   - Push it to ghcr.io/actuarysailor/pre-commit-terraform-tools:latest
   - Use GitHub's built-in GITHUB_TOKEN (no manual token needed)

## Docker Permission Fix (For Future)
To fix Docker permissions permanently (after token is fixed):

```bash
# Log out and log back in, or run:
newgrp docker

# This applies the docker group membership without restarting
```
