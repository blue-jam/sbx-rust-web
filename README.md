# sbx-rust-web

Docker Sandboxes templates for Rust + cargo + nvm/Node.js LTS.

## Images

This repository builds three Docker Sandboxes templates:

| Tag | Base variant | Agent |
| --- | --- | --- |
| `bluejamkmy/sbx-rust-web:codex` | `docker/sandbox-templates:codex-docker` | Codex |
| `bluejamkmy/sbx-rust-web:claude-code` | `docker/sandbox-templates:claude-code-docker` | Claude Code |
| `bluejamkmy/sbx-rust-web:antigravity` | `docker/sandbox-templates:shell-docker` | Antigravity CLI via kit |

The `-docker` base variants include Docker Engine inside the sandbox VM.

## Build

```bash
scripts/build.sh
```

Override defaults when needed:

```bash
IMAGE_NAMESPACE=your-dockerhub-user PLATFORM=linux/amd64 scripts/build.sh
```

## Publish

Log in to Docker Hub first:

```bash
docker login
scripts/push.sh
```

For Docker Sandboxes, include the full Docker Hub domain in template references:

```bash
sbx run --template docker.io/bluejamkmy/sbx-rust-web:codex codex
sbx run --template docker.io/bluejamkmy/sbx-rust-web:claude-code claude
```

Antigravity CLI is not a built-in Docker Sandboxes agent variant, so this repo
ships it as an experimental sandbox kit. The image contains a placeholder `agy`
command unless you provide the official installer URL at build time:

```bash
ANTIGRAVITY_INSTALL_URL=https://antigravity.google/cli/install.sh scripts/build.sh
```

Run the kit after publishing an image that actually includes Antigravity CLI:

```bash
sbx run antigravity --kit ./kits/antigravity
sbx run antigravity --kit "git+https://github.com/blue-jam/sbx-rust-web.git#ref=main&dir=kits/antigravity"
```

Validate:

```bash
sbx kit validate ./kits/antigravity
```

## Included Tools

- Rust stable via rustup
- cargo
- rustfmt
- clippy
- nvm
- Node.js LTS
- npm
- Docker-in-sandbox support through the selected Docker Sandboxes base variants
