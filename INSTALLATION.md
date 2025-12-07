# Kemu Host Installation Guide

This guide covers different ways to install Kemu Host (`kemud`) depending on your needs and preferences.

## Quick Install (Recommended for Most Users)

The fastest way to get started is using the installation script:

```bash
curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash
```

This method:
- Downloads the correct binary for your platform automatically
- Installs to `/usr/local/bin` by default
- Works on Linux, macOS, and Windows (Git Bash/WSL)
- Does not require Node.js, npm, or any JavaScript runtime
- Handles permissions automatically (may prompt for sudo if needed)

### Installation Script Options

**Install a specific version:**

```bash
curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash -s -- --version 0.1.5
```

**Install to a custom directory:**

```bash
curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash -s -- --install-dir ~/.local/bin
```

**Force reinstall (overwrite existing installation):**

```bash
curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash -s -- --force
```

**Combine multiple options:**

```bash
curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash -s -- --version 0.1.5 --install-dir ~/.local/bin --force
```

**View help:**

```bash
curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash -s -- --help
```

## Install via Package Manager

If you prefer using package managers (npm, yarn, pnpm, bun), you can install Kemu Host as an npm package:

### NPM

```bash
# Global installation
npm install -g @kemu-io/kemu-host

# Local installation (in a project)
npm install @kemu-io/kemu-host
```

### Bun

**Important for Bun users:** Bun does not run postinstall scripts by default. The postinstall script is required to download the correct binary for your platform. Before installing, add the package to `trustedDependencies` in your `package.json`:

**Option 1: Add to package.json (recommended for local installations)**

```json
{
  "trustedDependencies": ["@kemu-io/kemu-host"]
}
```

Then install:

```bash
# Global installation
bun install -g @kemu-io/kemu-host

# Local installation
bun install @kemu-io/kemu-host
```

### Yarn

```bash
# Global installation
yarn global add @kemu-io/kemu-host

# Local installation
yarn add @kemu-io/kemu-host
```

### PNPM

```bash
# Global installation
pnpm add -g @kemu-io/kemu-host

# Local installation
pnpm add @kemu-io/kemu-host
```

## Manual Installation

If you want to manually download and install the binary:

1. Go to the [releases page](https://github.com/kemu-io/kemu-host-releases/releases)
2. Download the appropriate binary for your platform:
   - Linux x64: `kemu-host-linux-x64`
   - Linux ARM64: `kemu-host-linux-arm64`
   - macOS x64 (Intel): `kemu-host-darwin-x64`
   - macOS ARM64 (Apple Silicon): `kemu-host-darwin-arm64`
   - Windows x64: `kemu-host-windows-x64.exe`
   - Windows ARM64: `kemu-host-windows-arm64.exe`
3. Rename the binary to `kemud` (or `kemud.exe` on Windows)
4. Make it executable: `chmod +x kemud` (Unix-like systems)
5. Move it to a directory in your PATH (e.g., `/usr/local/bin`)

Example for macOS ARM64:

```bash
# Download the binary
curl -fsSL -O https://github.com/kemu-io/kemu-host-releases/releases/download/v0.1.5/kemu-host-darwin-arm64

# Rename and make executable
mv kemu-host-darwin-arm64 kemud
chmod +x kemud

# Move to PATH
sudo mv kemud /usr/local/bin/
```

## Verifying Installation

After installation, verify that `kemud` is available:

```bash
kemud --version
```

If the command is not found, ensure the installation directory is in your PATH.

## Troubleshooting

### Binary not found after installation

If you installed to a custom directory that's not in your PATH, add it:

```bash
# For bash/zsh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc  # or ~/.zshrc
source ~/.bashrc  # or ~/.zshrc
```

### Permission denied errors

If you get permission errors during installation:

1. Use sudo with the install script
2. Or install to a directory you own:

```bash
curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash -s -- --install-dir ~/.local/bin
```

### Bun doesn't download the binary

Bun doesn't run postinstall scripts by default. The postinstall script is required to download the correct binary for your platform. 

**Preferred solution:** Add the package to `trustedDependencies` before installing (see the Bun installation section above).

**Alternative:** Use the curl installation method instead:
```bash
curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash
```

## Updating

### Curl Installation

To update, simply run the install script again with `--force`:

```bash
curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash -s -- --force
```

### Package Manager

Update using your package manager:

```bash
npm update -g @kemu-io/kemu-host  # npm
bun update -g @kemu-io/kemu-host  # bun
yarn global upgrade @kemu-io/kemu-host  # yarn
pnpm update -g @kemu-io/kemu-host  # pnpm
```

## Uninstallation

### Curl Installation

Remove the binary:

```bash
sudo rm /usr/local/bin/kemud
# Or if you installed to a custom location:
rm ~/.local/bin/kemud
```

### Package Manager

```bash
npm uninstall -g @kemu-io/kemu-host  # npm
bun remove -g @kemu-io/kemu-host  # bun
yarn global remove @kemu-io/kemu-host  # yarn
pnpm remove -g @kemu-io/kemu-host  # pnpm
```
