# @brief: Build an Ubuntu 24.04 based with VNC server
FROM ubuntu:24.04

# === Arguments ===
ARG TIMEZONE='Asia/Tokyo'
# Use the default non-root user on Ubuntu
ARG USERNAME='ubuntu'
ARG USER_UID='1000'
ARG USER_GID=${USER_UID}
# VNC Port fixed to 5901
# The VNC server will be started on display :1
# noVNC port is set to 6901
ARG NOVNC_PORT='6901'

# === Install packages ===
# Use bash for the image building
SHELL ["/bin/bash", "-c"]
# Set the timezone
ENV TZ=${TIMEZONE}
# Set the default locale to UTF-8
ENV LANG='C.UTF-8'
# Define an environment variable as an identifier
ENV MY_ENV='pd-vnc-in-docker'
# Create necessary directories
RUN mkdir -m 0755 /run/user
# Install core packages
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y \
		dbus-x11 \
		xfce4 xfce4-goodies \
		tightvncserver novnc \
		sudo \
		openssh-client gnupg \
		git wget \
		nano

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
# Set the X Desktop Group runtime directory since no login manager is used
ENV XDG_RUNTIME_DIR="/run/user/${USER_UID}"
# Set the VNC server port
ENV PD_VNC_PORT='5901'
# Set the noVNC port
ENV PD_NOVNC_PORT=${NOVNC_PORT}

# --- Set the GPG directory
# Create the necessary directory structure for gpg socket
RUN sudo mkdir -m 0700 /run/user/${USER_UID} \
	&& sudo chown ${USER_UID}:${USER_GID} /run/user/${USER_UID}

# --- Set VNC server
RUN mkdir $HOME/.vnc
# Copy the VNC server configuration files
COPY --chmod=0755 ./copy/src/install/xstartup $HOME/.vnc/xstartup
# Set the VNC server password
RUN echo 'panda+' | vncpasswd -f > $HOME/.vnc/passwd && \
	chmod 600 $HOME/.vnc/passwd
# Generate Xauthority file
RUN touch $HOME/.Xauthority && \
	xauth add $DISPLAY MIT-MAGIC-COOKIE-1 $(mcookie)

# --- Deploy the service scripts
RUN mkdir $HOME/service
COPY --chmod=0755 ./copy/src/service/start_vnc_server $HOME/service/start_vnc_server

# --- Add the service directory to the PATH
ENV PATH="$HOME/service:$PATH"

# === Launchpad ===
# Expose the VNC port
EXPOSE "$PD_VNC_PORT/tcp" "$PD_NOVNC_PORT/tcp"

# Set the working directory in the *container*
WORKDIR "$HOME/ws"

# Set the default command (to keep the container alive)
CMD echo "PLEASE LOGIN TO THE CONTAINER AND RUN THE SERVICE MANUALLY" && \
	echo "@host: docker run -p <host-port>:5901 -it <image-name> bash" && \
	echo "@container: start_vnc_server"
