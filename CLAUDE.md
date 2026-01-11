# CLAUDE.md - Project Guidelines for AI Assistants

## Project Overview

This repository is a fork of WebVM that adds OpenCog integration. It creates a browser-based Linux virtual machine running OpenCog's CogServer, AtomSpace, and related tools, allowing users to experiment with Atomese and hypergraph-based AI in their browser.

## Key Technologies

- **WebVM**: Browser-based x86 Linux VM using CheerpX virtualization
- **OpenCog**: Artificial General Intelligence framework
  - **AtomSpace**: Hypergraph knowledge representation system
  - **CogServer**: Network server for AtomSpace access
  - **CogUtil**: Utility library for OpenCog
- **Guile Scheme**: Primary language for Atomese interaction

## Repository Structure

```
cogvm/
├── .github/workflows/
│   └── deploy.yml           # GitHub Actions workflow for deployment
├── dockerfiles/
│   ├── debian_mini           # Base Debian minimal image
│   └── opencog_cogserver     # OpenCog-enabled image (main target)
├── examples/
│   └── opencog/              # OpenCog example scripts and docs
├── src/                      # WebVM source code (TypeScript)
├── config_*.js               # WebVM configuration files
└── *.md                      # Documentation files
```

## Build & Deployment

### GitHub Actions Workflow

The deploy workflow (`deploy.yml`) builds a Docker image and deploys to GitHub Pages:

1. **Trigger**: Manual dispatch via Actions tab
2. **Parameters**:
   - `DOCKERFILE_PATH`: Set to `dockerfiles/opencog_cogserver`
   - `IMAGE_SIZE`: Recommended `900M` (max `950M`)
   - `DEPLOY_TO_GITHUB_PAGES`: `true`

### Local Development

```bash
# Install dependencies
npm install

# Build for development
npm run build

# Build for GitHub Pages
WEBVM_MODE=github npm run build
```

### Docker Build (Local Testing)

```bash
docker build . --tag opencog-webvm --file dockerfiles/opencog_cogserver --platform=i386
```

## OpenCog Components Build Order

The Dockerfile builds OpenCog components in this order (dependencies matter):

1. **CogUtil** - Base utilities (must be built first)
2. **AtomSpace** - Knowledge representation (depends on CogUtil)
3. **CogServer** - Network server (depends on AtomSpace)

## Common Issues & Fixes

### Build Failures

1. **Git clone failures**: OpenCog repos use `master` branch (not `main`)
2. **Tag not found**: Always verify tags exist before pinning versions
3. **Image too large**: Must be under 950MB; strip binaries and remove docs

### Runtime Issues

1. **Missing libraries**: Run `ldconfig` after installing libraries
2. **Guile module not found**: Check load paths in `~/.guile`
3. **CogServer won't start**: Verify with `ldd /usr/local/bin/cogserver`

## Code Style

- Dockerfiles: Use multi-stage builds to minimize final image size
- Shell scripts: Use `set -e` for error handling
- JavaScript/TypeScript: Follow existing WebVM patterns

## Testing

After deployment, verify:

1. WebVM loads in browser
2. `cogserver` command starts successfully
3. Can connect via `telnet localhost 17001`
4. Scheme shell (`scm`) works
5. Basic Atomese commands execute

## External Resources

- [OpenCog Wiki](https://wiki.opencog.org/)
- [AtomSpace GitHub](https://github.com/opencog/atomspace)
- [CogServer GitHub](https://github.com/opencog/cogserver)
- [CogUtil GitHub](https://github.com/opencog/cogutil)
- [WebVM Documentation](https://cheerpx.io/docs)

## Branch Naming

Development branches should follow: `claude/<description>-<session-id>`
