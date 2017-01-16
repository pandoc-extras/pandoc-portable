# Description

This repository provides a mirror of [pandoc's binaries](https://github.com/jgm/pandoc/releases), as well as alternative *portable* distributions in *zip* container. (Linux's distribution is also available in `.tar.gz`)

# Versioning

In the [releases page](https://github.com/pandoc-extras/pandoc-portable/releases), the version is identical to the pandoc versions in [pandoc's release page](https://github.com/jgm/pandoc/releases).

The versions of the script and travis setup in this repository will be in this `README.md` file. Current version: 0.1

# Security Concern

The nice thing about this setup is nothing is done privately. e.g. none of the binaries goes through my computer. The main scripts are `.travis.yml` and `pandocDownload2zip.sh`, which is open source. The builds happened on Travis, where all build history is in the open. Feel free to audit (and contribute).

# License

The original license from pandoc is copied here, which is in GPLv2+.
