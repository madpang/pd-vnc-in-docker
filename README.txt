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

To use this Docker image as a dev container in VS Code:
1. `cd` into your <project-folder>
2. `git submodule add --branch main https://github.com/madpang/pd-imagine.git .devcontainer`
3. Open the workspace folder in VS Code, via `code .`
4. Use VS Code command "Dev Containers: Reopen in Container" to start the container
@see: [Developing inside a Container](https://code.visualstudio.com/docs/devcontainers/containers).
If you do not want to embed this project as a submodule, you can also create a `.devcontainer` symbolic link to the `pd-imagine` folder.

5. Launch the VNC server
+++ console@container
: start_vnc_server
+++

6. Connect to the VNC server using a VNC client:
    - URL: vnc://<host-ip>:1
    - Password: see Dockerfile for default password

NOTE, currently, if using "open folder in dev container" feature in VS Code, the container will NOT automatically stop when you close the connection.
You need to manually stop the container by executing `docker stop <container-id>` on the host machine.

=== Changelog

- v1.0.0: a minimal demo. of VNC server running in a Docker container.
- v1.1.0: a more realistic GUI session with a non-root user login.

=== Notes

Possible color depth for VNC is 8, 16, 24, 32.
The first two---8 bit and 16 bit---are for legacy systems and are not recommended for modern use.
Most VNC clients do not support alpha channel, so 24 bit (true RGB) is the common choice.
