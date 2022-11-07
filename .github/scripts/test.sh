#!/bin/bash

set -o pipefail

# Case statements for different platforms
case $1 in
    "macos")
        echo "Testing for macOS (x86_64)"
        PLATFORM="platform=macos,arch=x86_64"
        ;;
    "ios")
        echo "Testing for iOS (iPhone 13, iOS 16.1)"
        PLATFORM="platform=iOS Simulator,name=iPhone 13,OS=16.1"
        ;;
    "watchos")
        echo "Testing for watchOS"
        PLATFORM="platform=watchOS Simulator,name=Apple Watch Series 8 (41mm),OS=9.1"
        ;;
    "tvos")
        echo "Testing for tvOS"
        PLATFORM="platform=tvOS Simulator,name=Apple TV 4K (at 1080p),OS=16.1"
        ;;
    *)
        echo "Error: Unknown platform. Please provide one of the following: macos, ios, watchos, tvos"
        exit 1
        ;;
esac

SCHEME="LPKit"

# Run the tests

xcodebuild  \
    -scheme "$SCHEME" \
    -destination "$PLATFORM" \
    -skipPackagePluginValidation \
    clean test | xcpretty