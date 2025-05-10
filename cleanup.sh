#!/bin/bash

# Remove example usage file
rm -f example_usage.dart

# Remove unused build artifacts
rm -rf .dart_tool/
rm -rf .flutter-plugins
rm -rf .flutter-plugins-dependencies
rm -rf build/

# Remove platform-specific files that aren't needed for your current development
# Uncomment the lines for platforms you're not targeting

# iOS (uncomment if not developing for iOS)
# rm -rf ios/

# macOS (uncomment if not developing for macOS)
# rm -rf macos/

# Linux (uncomment if not developing for Linux)
# rm -rf linux/

# Windows (uncomment if not developing for Windows)
# rm -rf windows/

# Remove temporary files
find . -name "*.log" -type f -delete
find . -name ".DS_Store" -type f -delete
find . -name "*.swp" -type f -delete

# Remove any empty directories
find . -type d -empty -delete

echo "Cleanup complete. Unused files and directories have been removed."