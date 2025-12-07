# Kemu Host - Binary Releases

This repository contains pre-compiled binaries for the **Kemu Host** daemon agent.

The Kemu Host manages recipe-runner worker processes for the Kemu platform, enabling automated deployment and execution of recipes across your infrastructure.

## Installation

> For detailed installation instructions and troubleshooting, see [INSTALLATION.md](./INSTALLATION.md)

### Quick Install (Recommended)

Install directly using curl:

```bash
curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash
```

This will download and install the latest version of `kemud` to `/usr/local/bin`.

#### Installation Options

Install a specific version:

```bash
curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash -s -- --version 0.1.5
```

Install to a custom directory:

```bash
curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash -s -- --install-dir ~/.local/bin
```

### Via Package Manager

You can also install via npm, pnpm, yarn, or bun:

```bash
# Global install
npm install -g @kemu-io/kemu-host
bun install -g @kemu-io/kemu-host

# Local install
npm install @kemu-io/kemu-host
bun install @kemu-io/kemu-host
```

**Note**: Some package managers (like bun) don't run postinstall scripts by default. If the binary isn't downloaded automatically, run the install script manually:

```bash
# After installing with bun or another package manager
npm run install-binary
# or
node postinstall.js
```

### Manual Installation

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

Rename and move it to a directory in your PATH:

```bash
mv kemu-host-* kemud
sudo mv kemud /usr/local/bin/
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
