+++ header
@file: pd-vnc-in-docker/README.txt
@date:
- created on 2025-05-06
- updated on 2025-05-07
@author:
- madpang
+++

VNC server inside Docker container that can be deployed on a headless remote server.

=== Usage

1. Launch the Docker container:
+++ cmd from host
docker run -p 5901:5901 -d pd-vnc-in-docker
+++

2. Connect to the VNC server using a VNC client:
    - URL: vnc://<host-ip>:1
    - Password: see Dockerfile for default password

--- Advanced Usage

docker run \
  --name qt-vnc \
  -p 5901:5901 \
  --shm-size 2g \
  --mount type=bind,source=/home/madpang/Workspace4/heap/qt6-build,target=/home/ubuntu/ws \
  -it pd-vnc-in-docker:latest /bin/bash

=== Changelog

- v1.0.0: a minimal demo. of VNC server running in a Docker container.
- v1.1.0: a more realistic GUI session with a non-root user login.

=== Notes

Possible color depth for VNC is 8, 16, 24, 32.
The first two---8 bit and 16 bit---are for legacy systems and are not recommended for modern use.
Most VNC clients do not support alpha channel, so 24 bit (true RGB) is the common choice.
