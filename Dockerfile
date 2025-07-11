# Start from a specific, pinned version of Ubuntu for reproducibility.
FROM ubuntu:noble@sha256:440dcf6a5640b2ae5c77724e68787a906afb8ddee98bf86db94eea8528c2c076

# Set non-interactive frontend to avoid prompts during apt-get install.
ARG DEBIAN_FRONTEND=noninteractive

# Set up locale to support UTF-8.
# This prevents character encoding issues with tools and applications.
RUN apt-get update                                     && \
    apt-get install -y --no-install-recommends locales && \
    locale-gen en_US.UTF-8                             && \
    apt-get clean                                      && \
    rm -rf /var/lib/apt/lists/*
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install all common development tools in a single RUN layer to optimize image size.
RUN apt-get update                             && \
    apt-get install -y --no-install-recommends    \
    # --- Core Build Toolchain ---                \
    build-essential                               \
    cmake                                         \
    pkg-config                                    \
    # --- Version Control ---                     \
    git                                           \
    # --- Network & File Utilities ---            \
    curl                                          \
    wget                                          \
    unzip                                         \
    zip                                           \
    tar                                           \
    ca-certificates                               \
    software-properties-common                    \
    # --- Text Editing & Debugging ---            \
    vim                                           \
    sudo                                          \
    && apt-get clean                              \
    && rm -rf /var/lib/apt/lists/*

# --- Configure the built-in 'ubuntu' user for sudo access ---
# The official ubuntu:24.04 image includes a non-root user 'ubuntu' (uid=1000).
# We add this user to the sudo group to grant admin privileges.
RUN usermod -aG sudo ubuntu

# Configure sudo to allow the user to run commands without a password for convenience.
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu-nopasswd

# Set a default working directory.
WORKDIR /work

# Switch to the non-root 'ubuntu' user.
# All subsequent commands in this Dockerfile and the running container will use this user.
USER ubuntu
