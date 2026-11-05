<div align="center">

<img src="https://raw.githubusercontent.com/vhco-pro/.github/main/profile/assets/stackweaver.png" alt="Stackweaver" width="150" />

# Stackweaver Launcher

[![Release](https://github.com/vhco-pro/stackweaver-launcher/actions/workflows/release.yml/badge.svg)](https://github.com/vhco-pro/stackweaver-launcher/actions/workflows/release.yml)
[![Latest Release](https://img.shields.io/github/v/release/vhco-pro/stackweaver-launcher?sort=semver)](https://github.com/vhco-pro/stackweaver-launcher/releases/latest)
[![CodeQL](https://github.com/vhco-pro/stackweaver-launcher/actions/workflows/codeql.yml/badge.svg)](https://github.com/vhco-pro/stackweaver-launcher/actions/workflows/codeql.yml)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/vhco-pro/stackweaver-launcher/badge)](https://scorecard.dev/viewer/?uri=github.com/vhco-pro/stackweaver-launcher)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue)](LICENSE)
[![Docs](https://img.shields.io/badge/docs-stackweaver.sh-0ea5e9)](https://stackweaver.sh/docs)

The launcher for the [Stackweaver](https://stackweaver.sh) DevOps platform.

</div>

This is the public release repository for the Stackweaver Launcher. It is published from the Stackweaver source tree on every release. See the [release sync architecture](https://stackweaver.sh/docs/security/sync-architecture) for how releases are built, signed, and mirrored here.

## Overview

A launcher registers with a Stackweaver agent pool or hosted capacity, claims OpenTofu runs, Ansible jobs and sync work, and starts each one in its own job container, Kubernetes pod or, on a Linux host without Docker, a local process using the host's own OpenTofu and Ansible.

## Usage

Container image:

```bash
docker pull ghcr.io/vhco-pro/stackweaver-launcher:latest
```

Each release also attaches static Linux binaries for amd64 and arm64, a `SHA256SUMS` file and a build provenance attestation. Verify a download with:

```bash
sha256sum -c SHA256SUMS --ignore-missing
gh attestation verify stackweaver-launcher_<version>_linux_amd64 --repo vhco-pro/stackweaver-launcher
```

See the [Stackweaver documentation](https://stackweaver.sh/docs) for deployment and configuration instructions.

## License

Apache License 2.0. See [LICENSE](LICENSE) for details.
