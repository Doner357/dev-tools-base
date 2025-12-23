# Foundational Development Tools Base Image

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub last commit](https://img.shields.io/github/last-commit/Doner357/dev-tools-base.svg)](https://github.com/Doner357/dev-tools-base/tree/main)

A foundational container image based on **Ubuntu 24.04**, equipped with a comprehensive set of common development tools. This image serves as a stable and secure "Layer 0" for building various language-specific development environments (C++, Python, Rust, etc.).

## Features

* **Reproducible Builds:** Base images are pinned via `sha256` digest for absolute build consistency.
* **Principle of Least Privilege:** Runs as a dedicated, non-root user by default to prevent accidental system modifications and enhance security.
* **Convenient Administration:** Provides passwordless `sudo` access to the default user, allowing them to perform administrative tasks (like installing new packages) intentionally and without friction.
* **UTF-8 Ready:** The default locale is set to `en_US.UTF-8` to prevent character encoding issues.

## Included Tools

This image includes a curated list of essential tools grouped by category:

#### Core Build Toolchain
* `build-essential` (provides `make`, `g++`, etc.)
* `cmake`
* `pkg-config`

#### Version Control
* `git`

#### Network & File Utilities
* `curl`, `wget`
* `unzip`, `zip`, `tar`
* `ca-certificates`
* `software-properties-common`

#### Text Editing & System
* `vim`
* `sudo`

## Tagging and Versioning

This image follows Semantic Versioning (`MAJOR.MINOR.PATCH`) and provides three types of tags:

1.  **Immutable Tag (Source of Truth):**
    * **Format:** `[M].[m].[p]-[OS]`
    * **Example:** `1.0.3-noble`

2.  **Minor Floating Tag:**
    * **Format:** `[M].[m]-[OS]` (Points to the latest patch in a minor series)
    * **Example:** `1.0-noble`

3.  **Latest Floating Tag:**
    * **Format:** `latest-[OS]` (Points to the latest stable release)
    * **Example:** `latest-noble`

## Image Specifics

This table provides the specific details for each supported base image variant.

| Base OS | Version/Codename      | Image Tag Codename | Default Non-Root User |
| :------ | :-------------------- | :----------------- | :-------------------- |
| Ubuntu  | 24.04 (Noble Numbat)  | `noble`            | `ubuntu`              |
| _(Future)_ | _(e.g., Fedora 42)_   | _(e.g., `f42`)_    | _(e.g., `fedora`)_     |


## Usage

This image is not typically used directly, but rather as a base in another `Dockerfile`.

**Example (`Dockerfile` for a C++ image):**
```dockerfile
# Start from our trusted foundational image
FROM doner357/dev-tools-base:1.0.3-noble

# Install C++ specific tools
RUN sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends \
    clang-18 \
    && sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*
```

To run the image directly for inspection:

```bash
docker run -it --rm doner357/dev-tools-base:latest-noble
```

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.
