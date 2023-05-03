#!/bin/bash

# Set the package name
PACKAGE_NAME="LoyaltyMobileSDK-iOS"

# Run tests using xcodebuild and enable code coverage
xcodebuild test -scheme "${PACKAGE_NAME}" -destination 'platform=iOS Simulator,name=iPhone 13,OS=latest' -enableCodeCoverage YES
