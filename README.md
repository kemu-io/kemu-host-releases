# Kemu Host - Binary Releases

This repository contains pre-compiled binaries for the **Kemu Host** daemon agent.

The Kemu Host manages recipe-runner worker processes for the Kemu platform, enabling automated deployment and execution of recipes across your infrastructure.

## Installation

### Via npm (Recommended)

Install globally using npm:

```bash
npm install -g @kemu-io/kemu-host
```

After installation, the `kemud` binary will be available in your PATH.

### Direct Binary Download

Download the appropriate binary for your platform from the [Releases](https://github.com/kemu-io/kemu-host-releases/releases) page:

- **Linux x64**: `kemu-host-linux-x64`
- **Linux ARM64**: `kemu-host-linux-arm64`
- **macOS x64**: `kemu-host-darwin-x64`
- **macOS ARM64 (Apple Silicon)**: `kemu-host-darwin-arm64`
- **Windows x64**: `kemu-host-windows-x64.exe`

Make the binary executable (Unix-like systems):

```bash
chmod +x kemu-host-*
```

Move it to a directory in your PATH:

```bash
sudo mv kemu-host-* /usr/local/bin/kemud
```

## Quick Start

1. Set required environment variables:
   ```bash
   export ENVIRONMENT_ID="env_xxxxxxx"
   export KEMU_API_KEY="secret_xxx"
   ```

2. Run the host daemon:
   ```bash
   kemud
   ```

## License

Proprietary software copyright (c) Kemu Platform. All rights reserved.
