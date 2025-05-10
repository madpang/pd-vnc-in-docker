#!/bin/bash

# @brief: Setup the environment to build Qt6 from source
# @details: Consult the official Qt doc for the required packages
# @see: https://doc.qt.io/qt-6/linux-building.html
# @see: https://doc.qt.io/qt-6/linux-requirements.html
# @note: This script needs root privileges to run 

apt-get update && \
apt-get install -y \
	git \
	build-essential \
	cmake \
	ninja-build \
	python3 \
	libfontconfig1-dev \
	libfreetype-dev \
	libgtk-3-dev \
	libx11-dev \
	libx11-xcb-dev \
	libxcb-cursor-dev \
	libxcb-glx0-dev \
	libxcb-icccm4-dev \
	libxcb-image0-dev \
	libxcb-keysyms1-dev \
	libxcb-randr0-dev \
	libxcb-render-util0-dev \
	libxcb-shape0-dev \
	libxcb-shm0-dev \
	libxcb-sync-dev \
	libxcb-util-dev \
	libxcb-xfixes0-dev \
	libxcb-xkb-dev \
	libxcb1-dev \
	libxext-dev \
	libxfixes-dev \
	libxi-dev \
	libxkbcommon-dev \
	libxkbcommon-x11-dev \
	libxrender-dev
