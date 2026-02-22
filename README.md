# Wayland Libraries Builder

This is a container for building wayland-client, wayland-cursor, wayland-egl,
and wayland-server static and dynamic libraries.

## Usage
Run the included compose file or Dockerfile directly using your favorite
container runtime. Here `podman` is used.

`$ podman-compose run --rm wayland-builder`

Libraries with their headers will be in `data/wayland-NAME-VERSION/` directory.
All these directories are packed into `data/wayland-libs-VERSION.tar.gz`.
