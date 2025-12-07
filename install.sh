#!/bin/sh
# Kemu Host Installation Script
# Usage: curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash
# Or: curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash -s -- --version 0.1.5

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
REPO="kemu-io/kemu-host-releases"
BINARY_NAME="kemud"
DEFAULT_INSTALL_DIR="/usr/local/bin"

# Parse arguments
VERSION=""
INSTALL_DIR=""
FORCE=false

while [ $# -gt 0 ]; do
  case "$1" in
    --version)
      VERSION="$2"
      shift 2
      ;;
    --install-dir)
      INSTALL_DIR="$2"
      shift 2
      ;;
    --force)
      FORCE=true
      shift
      ;;
    -h|--help)
      echo "Kemu Host Installation Script"
      echo ""
      echo "Usage: curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash"
      echo ""
      echo "Options:"
      echo "  --version VERSION      Install a specific version (default: latest)"
      echo "  --install-dir DIR      Install to a specific directory (default: /usr/local/bin)"
      echo "  --force                Force reinstall even if already installed"
      echo "  -h, --help             Show this help message"
      echo ""
      echo "Examples:"
      echo "  # Install latest version"
      echo "  curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash"
      echo ""
      echo "  # Install specific version"
      echo "  curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash -s -- --version 0.1.5"
      echo ""
      echo "  # Install to custom directory"
      echo "  curl -fsSL https://raw.githubusercontent.com/kemu-io/kemu-host-releases/main/install.sh | bash -s -- --install-dir ~/.local/bin"
      exit 0
      ;;
    *)
      echo "${RED}Error: Unknown option $1${NC}" >&2
      exit 1
      ;;
  esac
done

# Set install directory with fallback
if [ -z "$INSTALL_DIR" ]; then
  INSTALL_DIR="$DEFAULT_INSTALL_DIR"
fi

# Determine platform and architecture
detect_platform() {
  local os arch
  
  # Detect OS
  case "$(uname -s)" in
    Linux*)
      os="linux"
      ;;
    Darwin*)
      os="darwin"
      ;;
    MINGW*|MSYS*|CYGWIN*)
      os="windows"
      ;;
    *)
      echo "${RED}Error: Unsupported operating system $(uname -s)${NC}" >&2
      exit 1
      ;;
  esac
  
  # Detect architecture
  case "$(uname -m)" in
    x86_64|amd64)
      arch="x64"
      ;;
    aarch64|arm64)
      arch="arm64"
      ;;
    *)
      echo "${RED}Error: Unsupported architecture $(uname -m)${NC}" >&2
      exit 1
      ;;
  esac
  
  # Set extension for Windows
  local ext=""
  if [ "$os" = "windows" ]; then
    ext=".exe"
  fi
  
  echo "kemu-host-${os}-${arch}${ext}"
}

# Get latest version from GitHub
get_latest_version() {
  local api_url="https://api.github.com/repos/${REPO}/releases/latest"
  
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$api_url" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- "$api_url" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
  else
    echo "${RED}Error: Neither curl nor wget is available${NC}" >&2
    exit 1
  fi
}

# Download file
download_file() {
  local url="$1"
  local output="$2"
  
  echo "Downloading from: $url"
  
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL --progress-bar -o "$output" "$url"
  elif command -v wget >/dev/null 2>&1; then
    wget -q --show-progress -O "$output" "$url"
  else
    echo "${RED}Error: Neither curl nor wget is available${NC}" >&2
    exit 1
  fi
}

# Main installation logic
main() {
  echo "${GREEN}Kemu Host Installer${NC}"
  echo ""
  
  # Check if already installed
  if [ "$FORCE" = false ] && command -v kemud >/dev/null 2>&1; then
    local existing_version
    existing_version=$(kemud --version 2>/dev/null || echo "unknown")
    echo "${YELLOW}kemud is already installed (version: $existing_version)${NC}"
    echo "Use --force to reinstall"
    exit 0
  fi
  
  # Detect platform
  echo "Detecting platform..."
  PLATFORM_BINARY=$(detect_platform)
  echo "Platform: $PLATFORM_BINARY"
  echo ""
  
  # Determine version to install
  if [ -z "$VERSION" ]; then
    echo "Fetching latest version..."
    VERSION=$(get_latest_version)
    if [ -z "$VERSION" ]; then
      echo "${RED}Error: Failed to fetch latest version${NC}" >&2
      exit 1
    fi
  fi
  echo "Version: v$VERSION"
  echo ""
  
  # Construct download URL
  DOWNLOAD_URL="https://github.com/${REPO}/releases/download/v${VERSION}/${PLATFORM_BINARY}"
  
  # Create temporary directory
  TMP_DIR=$(mktemp -d)
  trap 'rm -rf "$TMP_DIR"' EXIT
  
  TMP_BINARY="$TMP_DIR/$PLATFORM_BINARY"
  
  # Download binary
  echo "Downloading binary..."
  if ! download_file "$DOWNLOAD_URL" "$TMP_BINARY"; then
    echo "${RED}Error: Failed to download binary${NC}" >&2
    echo ""
    echo "Please verify:"
    echo "  1. Release v$VERSION exists on GitHub"
    echo "  2. Binary $PLATFORM_BINARY is attached to the release"
    echo "  3. You have network access to GitHub"
    echo ""
    echo "Release URL: https://github.com/${REPO}/releases/tag/v${VERSION}"
    exit 1
  fi
  echo ""
  
  # Make binary executable
  chmod +x "$TMP_BINARY"
  
  # Create install directory if it doesn't exist
  if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating install directory: $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR" 2>/dev/null || {
      echo "${RED}Error: Cannot create directory $INSTALL_DIR${NC}" >&2
      echo "Try running with sudo or choose a different directory with --install-dir"
      exit 1
    }
  fi
  
  # Install binary
  TARGET_PATH="$INSTALL_DIR/$BINARY_NAME"
  echo "Installing to: $TARGET_PATH"
  
  if ! mv "$TMP_BINARY" "$TARGET_PATH" 2>/dev/null; then
    echo "${YELLOW}Permission denied. Attempting with sudo...${NC}"
    if ! sudo mv "$TMP_BINARY" "$TARGET_PATH"; then
      echo "${RED}Error: Failed to install binary${NC}" >&2
      echo "Try running the script with sudo or choose a different directory with --install-dir"
      exit 1
    fi
    sudo chmod +x "$TARGET_PATH"
  fi
  
  echo ""
  echo "${GREEN}✓ Successfully installed kemud v$VERSION${NC}"
  echo ""
  
  # Verify installation
  if command -v kemud >/dev/null 2>&1; then
    echo "Run 'kemud --help' to get started"
  else
    echo "${YELLOW}Note: $INSTALL_DIR is not in your PATH${NC}"
    echo "Add it to your PATH by adding this line to your shell profile:"
    echo ""
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
    echo ""
    echo "Or run the binary directly: $TARGET_PATH"
  fi
}

main "$@"
