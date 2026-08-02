# Agent Instructions

This repository builds Docker Sandboxes templates for Rust and web development.

## Scope

- Keep template changes focused on Docker Sandboxes images and kits.
- Prefer pinned installer versions where practical.
- Install system packages as `root`, then switch back to `agent` for user-level tools such as rustup and nvm.
- Do not bake secrets, API keys, or login tokens into images or kit files.

## Verification

- Run `docker buildx build --build-arg BASE_VARIANT=codex-docker -f Dockerfile -t sbx-rust-web:codex --load .` after changing shared setup.
- Run the matching Dockerfile build when changing a single agent variant.
- For Sandboxes usage, image references should include `docker.io/` when used with `sbx --template`.

## Publish

- Use `scripts/push.sh` after `docker login`.
- Override `IMAGE_NAMESPACE`, `IMAGE_NAME`, or `PLATFORM` when publishing to another Docker Hub namespace or architecture.
