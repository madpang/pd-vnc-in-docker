FROM ubuntu:24.04

# === Arguments ===
ARG USERNAME="root"
ARG TIMEZONE="Asia/Tokyo"

# === Environment Variables ===
# Define an environment variable as an identifier
ENV MY_ENV="pd-vnc-in-docker"

# Set the user
ENV USER=${USERNAME}

# Set the timezone
ENV TZ=${TIMEZONE}

# === Install packages ===
# Install core packages
RUN apt-get update && apt-get install -y \
    xfce4 \
    tightvncserver

# @todo: need to configure the VNC server
# @note: for the current being, user needs to configure the VNC server manually by logging into interactive shell

# === Launchpad ===

# Expose the VNC port
EXPOSE 5901/tcp

# Set the default command (to keep the container alive)
CMD ["tail", "-f", "/dev/null"]

# === Usage ===

# 1. login to the container in interactive mode, `docker run -p 5901:5901 -it <image_name> bash`
# 2. install `dbus-x11` package, `apt-get install -y dbus-x11`
# 3. configure the VNC server to set password---just need to run `vncserver :1` and follow the instructions
# 4. kill the initial VNC server, and configure `/root/.vnc/xstartup` file to start the XFCE desktop environment.
# 5. start the VNC server, `vncserver :1`

# @note:
# step 2 is necessary, otherwise upon your login to the VNC server, you will get an error message like:
# +++ quote
# Unable to contact settings server
# Failed to execute child process "dbus-launch" (No such file or directory)"
# +++

# @note:
# the content of `xtartup` file should be like:
# +++ quote
# #!/bin/sh
# startxfce4 &
# +++
