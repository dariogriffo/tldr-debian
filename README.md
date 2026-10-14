![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/dariogriffo/tldr-debian/total)
![GitHub Downloads (all assets, latest release)](https://img.shields.io/github/downloads/dariogriffo/tldr-debian/latest/total)
![GitHub Release](https://img.shields.io/github/v/release/dariogriffo/tldr-debian)
![GitHub Release Date](https://img.shields.io/github/release-date/dariogriffo/tldr-debian)

<h1>
   <p align="center">
     <a href="https://tldr.sh/tlrc"><img src="https://github.com/dariogriffo/tldr-debian/blob/main/tldr-logo.svg" alt="tldr Logo" width="128" style="margin-right: 20px"></a>
     <a href="https://www.debian.org/"><img src="https://github.com/dariogriffo/tldr-debian/blob/main/debian-logo.png" alt="Debian Logo" width="104" style="margin-left: 20px"></a>
     <br>tldr for Debian
   </p>
</h1>
<p align="center">
 tlrc, the official tldr client written in Rust: simplified, example-driven help pages for command-line tools.
</p>

# tldr for Debian

This repository contains build scripts to produce the _unofficial_ Debian packages
(.deb) for [tlrc](https://github.com/tldr-pages/tlrc/) hosted at [deb.griffo.io](https://deb.griffo.io)

The package is called `tldr` and so is the command; the upstream project is
called tlrc (the official Rust client of [tldr-pages](https://github.com/tldr-pages/tldr)).

Currently supported Debian distros are:
- Trixie (v13)
- Forky (v14)
- Sid (testing)

Bookworm is not supported: Debian 12 ships its own `tldr` package (the Haskell
client) and this package is not meant to replace it there. Ubuntu is not built
at the moment either.

Supported architectures:
- amd64 (x86_64)
- arm64 (aarch64)

Upstream only publishes Linux binaries for these two architectures, so there
are no i386, armhf, armel or riscv64 packages.

The packages include the statically linked `tldr` binary (musl build, no
runtime dependencies), the man page and shell completions for bash, fish and
zsh. The first run downloads the tldr pages cache from the internet.

The package conflicts with and replaces Debian's `tealdeer`, which installs the
same `/usr/bin/tldr`, man page and completions.

This is an unofficial community project to provide a package that's easy to
install on Debian. If you're looking for the tlrc source code, see
[tlrc](https://github.com/tldr-pages/tlrc/).

## Install/Update

📖 **Step-by-step install guide:** [Debian](https://deb.griffo.io/install-latest-tldr-in-debian.html)

### The Debian way

> ⚠️ **apt access requires a yearly subscription**
> ([deb.griffo.io](https://deb.griffo.io)). To use this tool for free, download
> the .deb from the [Releases](https://github.com/dariogriffo/tldr-debian/releases) page
> and install it manually (see below).

```sh
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://deb.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/deb.griffo.io.gpg
echo "deb [signed-by=/etc/apt/keyrings/deb.griffo.io.gpg] https://deb.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/deb.griffo.io.list
sudo apt update
sudo apt install -y tldr
```

### Manual Installation

1. Download the .deb package for your Debian version available on
   the [Releases](https://github.com/dariogriffo/tldr-debian/releases) page.
2. Install the downloaded .deb package.

```sh
sudo dpkg -i <filename>.deb
```
## Updating

To update to a new version, just follow any of the installation methods above. There's no need to uninstall the old version; it will be updated correctly.

## Building

### Build for single architecture
```sh
./build.sh <tldr_version> <build_version> <architecture>
# Example: ./build.sh 1.13.1 1 arm64
```

### Build for all architectures
```sh
./build.sh <tldr_version> <build_version> all
# Example: ./build.sh 1.13.1 1 all
```

## Roadmap

- [x] Produce a .deb package on GitHub Releases
- [x] Set up a debian mirror for easier updates
- [x] Multi-architecture support (amd64, arm64)

## Disclaimer

- This repo is not open for issues related to tlrc. This repo is only for _unofficial_ Debian packaging.
