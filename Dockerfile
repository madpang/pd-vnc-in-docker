FROM ubuntu:24.04

# === Arguments ===
ARG USERNAME='root'
ARG TIMEZONE='Asia/Tokyo'
ARG VNC_SCREEN_SIZE='1512x982'
ARG VNC_COLOR_DEPTH='24'
ARG VNC_SCREEN_DPI='96'

# === Shell for image building ===
# Set the shell to bash
SHELL ["/bin/bash", "-c"]

# === Environment Variables ===
# Define an environment variable as an identifier
ENV MY_ENV='pd-vnc-in-docker'

# Set the user
ENV USER=${USERNAME}

# Set the timezone
ENV TZ=${TIMEZONE}

# Set the display
ENV DISPLAY=':1'

# Pass ARG values to ENV for runtime usage
ENV PD_SCREEN_SIZE=${VNC_SCREEN_SIZE}
ENV PD_COLOR_DEPTH=${VNC_COLOR_DEPTH}
ENV PD_SCREEN_DPI=${VNC_SCREEN_DPI}

# === Install packages ===
# Install core packages
RUN apt-get update && \
    apt-get install -y \
        dbus-x11 \
        xfce4 \
        tightvncserver

# --- Set VNC server
# Set the VNC server password
RUN mkdir -p /root/.vnc && \
    echo 'panda+' | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Generate Xauthority file
RUN touch /root/.Xauthority && \
    xauth add $DISPLAY MIT-MAGIC-COOKIE-1 $(mcookie)

# Create a startup script for VNC
RUN echo -e '#!/bin/bash\nstartxfce4 &' > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

# === Launchpad ===
# Expose the VNC port
EXPOSE 5901/tcp

# Set the default command (to keep the container alive)
CMD vncserver $DISPLAY -geometry $PD_SCREEN_SIZE -depth $PD_COLOR_DEPTH -dpi $PD_SCREEN_DPI && tail -f /dev/null
