#!/bin/bash

# Variables
PACKAGE_NAME="LoyaltyMobileSDK-iOS"
APP_NAME="MyNTORewards"
PROJECT_NAME="MyNTORewards.xcodeproj"
APP_SCHEME="MyNTORewards"
APP_UNIT_TEST_TARGET="MyNTORewardsTests"
APP_UI_TEST_TARGET="MyNTORewardsUITests"
SIMULATOR_NAME="iPhone 14"
SIMULATOR_OS="latest"

# Get the current timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Set the project directory
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/SampleApps/$APP_NAME"

# Check if xcpretty is installed
if command -v xcpretty &> /dev/null; then
    XCPRETTY="xcpretty"
else
    echo "xcpretty not found. Consider installing it for better test output: gem install xcpretty"
    XCPRETTY="cat"
fi

# Set optional flags
SAVE_LOG=false
SAVE_REPORT=false
TESTS_TO_RUN=""

for arg in "$@"
do
  if [ "$arg" = "-log" ]; then
    SAVE_LOG=true
  elif [ "$arg" = "-report" ]; then
    SAVE_REPORT=true
    XCPRETTY="$XCPRETTY --report html"
  elif [ "$arg" = "-full" ] || [ "$arg" = "-sdkOnly" ] || [ "$arg" = "-appOnly" ]; then
    TESTS_TO_RUN="$arg"
  fi
done

# Set the default value for TESTS_TO_RUN if not specified
if [ -z "$TESTS_TO_RUN" ]; then
  TESTS_TO_RUN="-sdkOnly"
fi

# Create the output directory if -log or -report is passed
if [ "$SAVE_LOG" = true ] || [ "$SAVE_REPORT" = true ]; then
  OUTPUT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/build/TestRun_$TIMESTAMP"
  mkdir -p "$OUTPUT_DIR"
fi

# Redirect all output to a log file if the -log argument is passed
if [ "$SAVE_LOG" = true ]; then
  exec > >(tee "$OUTPUT_DIR/TestRun_$TIMESTAMP.log") 2>&1
fi

if [ "$TESTS_TO_RUN" = "-full" ] || [ "$TESTS_TO_RUN" = "-sdkOnly" ]; then
  echo "=== Loyalty Mobile SDK Unit Tests Start ==="

  # Run tests for PACKAGE_NAME scheme
  xcodebuild test \
  -scheme "$PACKAGE_NAME" \
  -destination "platform=iOS Simulator,name=$SIMULATOR_NAME,OS=$SIMULATOR_OS" \
  | $XCPRETTY $( [ "$SAVE_REPORT" = true ] && echo "-o" "$OUTPUT_DIR/SDKTestReport_$TIMESTAMP.html" )

  echo "=== Loyalty Mobile SDK Unit Tests End ==="
fi

if [ "$TESTS_TO_RUN" = "-full" ] || [ "$TESTS_TO_RUN" = "-appOnly" ]; then
  # Navigate to the project directory
  cd "$PROJECT_DIR"

  echo "=== Sample App Unit Tests Start ==="

  # Run unit tests for MyNTORewards scheme
  xcodebuild test \
    -project "$PROJECT_NAME" \
    -scheme "$APP_SCHEME" \
    -destination "platform=iOS Simulator,name=$SIMULATOR_NAME,OS=$SIMULATOR_OS" \
    -only-testing:"$APP_UNIT_TEST_TARGET" \
    -destination-timeout 30s \
    | $XCPRETTY $( [ "$SAVE_REPORT" = true ] && echo "-o" "$OUTPUT_DIR/AppUnitTestReport_$TIMESTAMP.html" )

  echo "=== Sample App Unit Tests End ==="

  echo "=== Sample App UI Tests Start ==="

  # Run UI tests for MyNTORewards scheme
  xcodebuild test \
    -project "$PROJECT_NAME" \
    -scheme "$APP_SCHEME" \
    -destination "platform=iOS Simulator,name=$SIMULATOR_NAME,OS=$SIMULATOR_OS" \
    -only-testing:"$APP_UI_TEST_TARGET" \
    | $XCPRETTY $( [ "$SAVE_REPORT" = true ] && echo "-o" "$OUTPUT_DIR/AppUITestReport_$TIMESTAMP.html" )

  echo "=== Sample App UI Tests End ==="
fi

# Exit with the status code from the xcodebuild command
exit ${PIPESTATUS[0]}
