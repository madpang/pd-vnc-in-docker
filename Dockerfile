FROM ubuntu:24.04

# === Arguments ===
ARG TIMEZONE='Asia/Tokyo'
ARG VNC_SCREEN_SIZE='1512x982'
ARG VNC_COLOR_DEPTH='24'
ARG VNC_SCREEN_DPI='96'
# Use the default non-root user on Ubuntu
ARG USERNAME='ubuntu'

# === Install packages ===
# Use bash for the image building
SHELL ["/bin/bash", "-c"]
# Set the timezone
ENV TZ=${TIMEZONE}
# Set the default locale to UTF-8
ENV LANG="C.UTF-8"
# Define an environment variable as an identifier
ENV MY_ENV='pd-vnc-in-docker'
# Install core packages
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y \
		dbus-x11 \
		xfce4 xfce4-goodies \
		tightvncserver \
		sudo

# Grant sudo privileges to the non-root user
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
	&& chmod 0440 /etc/sudoers.d/${USERNAME}

# === Runtime configuration ===
# Execute the following commands as the non-root user
USER ${USERNAME}

# --- Set environment variables
# Set the USER (required for the VNC server)
ENV USER=${USERNAME}
ENV HOME="/home/${USERNAME}"
# Set the display
ENV DISPLAY=':1'
# Pass ARG values to ENV for runtime usage
ENV PD_SCREEN_SIZE=${VNC_SCREEN_SIZE}
ENV PD_COLOR_DEPTH=${VNC_COLOR_DEPTH}
ENV PD_SCREEN_DPI=${VNC_SCREEN_DPI}

# --- Set VNC server
# Set the VNC server password
RUN mkdir -p $HOME/.vnc && \
	echo 'panda+' | vncpasswd -f > $HOME/.vnc/passwd && \
	chmod 600 $HOME/.vnc/passwd
# Generate Xauthority file
RUN touch $HOME/.Xauthority && \
	xauth add $DISPLAY MIT-MAGIC-COOKIE-1 $(mcookie)
# Create a startup script for VNC
RUN echo -e '#!/bin/bash\nvncconfig -iconic &\ndbus-launch --exit-with-session startxfce4 &' > $HOME/.vnc/xstartup && \
	chmod +x $HOME/.vnc/xstartup

# === Launchpad ===
# Expose the VNC port
EXPOSE 5901/tcp

# Set the working directory in the *container*
WORKDIR $HOME/ws

# Set the default command (to keep the container alive)
CMD vncserver $DISPLAY -geometry $PD_SCREEN_SIZE -depth $PD_COLOR_DEPTH -dpi $PD_SCREEN_DPI && tail -f $HOME/.vnc/*:1.log
