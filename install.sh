#!/bin/bash

# Shinobi Mod - script for easy installation

echo "Solana Shinobi Mod Patch installer"
echo "-------------------------------------"

# Check if we are in Solana directory
if [ ! -f "Cargo.toml" ] || [ ! -d "agave" ]; then
  echo "Error: This script must be run from Solana root directory"
  echo "Please navigate to your Solana directory and run this script again"
  exit 1
fi

# Check Solana version
solana_version=$(grep -A 1 '\[package\]' Cargo.toml | grep 'version' | cut -d '"' -f2)
if [[ "$solana_version" != "2.2.12"* ]]; then
  echo "Warning: This patch is designed for Solana v2.2.12"
  echo "Your version: $solana_version"
  read -p "Do you want to continue anyway? (y/n): " continue_install
  if [[ "$continue_install" != "y" ]]; then
    echo "Installation aborted"
    exit 1
  fi
fi

# Apply patch
echo "Applying shinobi mod patch..."
if git apply --check "$(dirname "$0")/shinobi_mod_v2.2.12.patch" > /dev/null 2>&1; then
  git apply "$(dirname "$0")/shinobi_mod_v2.2.12.patch"
  echo "Patch applied successfully!"
else
  echo "Error: Patch cannot be applied cleanly"
  echo "You may need to apply it manually or check for conflicts"
  exit 1
fi

# Create sample config
echo "Creating sample configuration file..."
echo "0.45 4 0 24" > mostly_confirmed_threshold.sample
echo "Sample configuration created: mostly_confirmed_threshold.sample"
echo "To activate the mod, rename this file to 'mostly_confirmed_threshold'"

echo ""
echo "Installation complete! To activate the mod:"
echo "1. Copy 'mostly_confirmed_threshold.sample' to your validator's root directory"
echo "2. Rename it to 'mostly_confirmed_threshold'"
echo "3. Restart your validator"

echo ""
echo "Default configuration values:"
echo "- mostly_confirmed_threshold: 0.45 (percentage of stake that must vote)"
echo "- threshold_ahead_count: 4 (slots ahead to vote)"
echo "- after_skip_threshold: 0 (behavior after skipped slots)"
echo "- threshold_escape_count: 24 (slots without voting before emergency escape)"
