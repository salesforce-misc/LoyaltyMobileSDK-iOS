#!/bin/bash

# Store the start time
START_TIME=$(date +%s)

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
OUTPUT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/build/TestRun_$TIMESTAMP"
mkdir -p "$OUTPUT_DIR"

# Check if xcpretty is installed
if command -v xcpretty &> /dev/null; then
    XCPRETTY="xcpretty"
else
    echo "xcpretty not found. Consider installing it for better test output: gem install xcpretty"
    XCPRETTY="cat"
fi

# Check if jq is installed
if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is not installed."

  # Detect the user's platform
  platform=$(uname)
  case $platform in
    Darwin*)
      echo "To install jq on macOS, run: brew install jq"
      ;;
    Linux*)
      echo "To install jq on Linux, run: sudo apt-get install jq"
      ;;
    *)
      echo "Please check the jq official website for installation instructions for your platform: https://stedolan.github.io/jq/download/"
      ;;
  esac
  echo "Please install jq before running this script."
  exit 1
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
    -enableCodeCoverage YES \
    | $XCPRETTY $( [ "$SAVE_REPORT" = true ] && echo "-o" "$OUTPUT_DIR/SDKTestReport_$TIMESTAMP.html" )

  # Locate the most recent .xcresult file for Loyalty Mobile SDK Unit Tests
  SDK_XCRESULT_FILE=$(find ~/Library/Developer/Xcode/DerivedData/ -name "*.xcresult" -type d -print0 | xargs -0 stat -f "%m %N" | sort -rn | head -n 1 | awk '{print $2}')

  # Generate code coverage report for Loyalty Mobile SDK Unit Tests
  xcrun xccov view --report --json "$SDK_XCRESULT_FILE" > "$OUTPUT_DIR/SDK_CodeCoverageReport_$TIMESTAMP.json"

  # Add a title to the code coverage report
  echo -e "= Loyalty Mobile SDK Code Coverage Summary =\n" | tee "$OUTPUT_DIR/SDK_CodeCoverageSummary_$TIMESTAMP.txt"

  # Add the parsed code coverage information into the summary file
  jq -r '
  .targets[] |
  "\(.name): \( (.lineCoverage * 100) | round )%" +
  "\n  File                                         Coverage\n  --------------------------------------------------------" +
  (
    .files |
    map(
      "\n  " + (
        .name |
        (if length < 40 then . + (" " * (40 - length)) else .[0:40] end)
      ) + ": " + (" " * (4 - (length | tostring | length))) + "\( (.lineCoverage * 100) | round )%"
    ) | join("")
  ) + "\n"
  ' "$OUTPUT_DIR/SDK_CodeCoverageReport_$TIMESTAMP.json" | tee -a "$OUTPUT_DIR/SDK_CodeCoverageSummary_$TIMESTAMP.txt"

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
    -enableCodeCoverage YES \
    | $XCPRETTY $( [ "$SAVE_REPORT" = true ] && echo "-o" "$OUTPUT_DIR/AppUnitTestReport_$TIMESTAMP.html" )

  # Locate the most recent .xcresult file for Sample App Unit Tests
  APP_UNIT_XCRESULT_FILE=$(find ~/Library/Developer/Xcode/DerivedData/ -name "*.xcresult" -type d -print0 | xargs -0 stat -f "%m %N" | sort -rn | head -n 1 | awk '{print $2}')

  # Generate code coverage report for Sample App Unit Tests
  xcrun xccov view --report --json "$APP_UNIT_XCRESULT_FILE" > "$OUTPUT_DIR/AppUnit_CodeCoverageReport_$TIMESTAMP.json"

  # Add a title to the code coverage report
  echo -e "= Sample App Unit Test Code Coverage Summary =\n" | tee "$OUTPUT_DIR/AppUnit_CodeCoverageReport_$TIMESTAMP.txt"

  # Add the parsed code coverage information into the summary file
  jq -r '
  .targets[] |
  "\(.name): \( (.lineCoverage * 100) | round )%" +
  "\n  File                                         Coverage\n  --------------------------------------------------------" +
  (
    .files |
    map(
      "\n  " + (
        .name |
        (if length < 40 then . + (" " * (40 - length)) else .[0:40] end)
      ) + ": " + (" " * (4 - (length | tostring | length))) + "\( (.lineCoverage * 100) | round )%"
    ) | join("")
  ) + "\n"
  ' "$OUTPUT_DIR/AppUnit_CodeCoverageReport_$TIMESTAMP.json" | tee -a "$OUTPUT_DIR/AppUnit_CodeCoverageReport_$TIMESTAMP.txt"

  echo "=== Sample App Unit Tests End ==="

  echo "=== Sample App UI Tests Start ==="

  # Run UI tests for MyNTORewards scheme
  xcodebuild test \
    -project "$PROJECT_NAME" \
    -scheme "$APP_SCHEME" \
    -destination "platform=iOS Simulator,name=$SIMULATOR_NAME,OS=$SIMULATOR_OS" \
    -only-testing:"$APP_UI_TEST_TARGET" \
    -enableCodeCoverage YES \
    | $XCPRETTY $( [ "$SAVE_REPORT" = true ] && echo "-o" "$OUTPUT_DIR/AppUITestReport_$TIMESTAMP.html" )

  # Locate the most recent .xcresult file for Sample App UI Tests
  APP_UI_XCRESULT_FILE=$(find ~/Library/Developer/Xcode/DerivedData/ -name "*.xcresult" -type d -print0 | xargs -0 stat -f "%m %N" | sort -rn | head -n 1 | awk '{print $2}')

  # Generate code coverage report for Sample App UI Tests
  xcrun xccov view --report --json "$APP_UI_XCRESULT_FILE" > "$OUTPUT_DIR/AppUI_CodeCoverageReport_$TIMESTAMP.json"

  # Add a title to the code coverage report
  echo -e "= Sample App UI Test Code Coverage Summary =\n" | tee "$OUTPUT_DIR/AppUI_CodeCoverageReport_$TIMESTAMP.txt"

  # Add the parsed code coverage information into the summary file
  jq -r '
  .targets[] |
  "\(.name): \( (.lineCoverage * 100) | round )%" +
  "\n  File                                         Coverage\n  --------------------------------------------------------" +
  (
    .files |
    map(
      "\n  " + (
        .name |
        (if length < 40 then . + (" " * (40 - length)) else .[0:40] end)
      ) + ": " + (" " * (4 - (length | tostring | length))) + "\( (.lineCoverage * 100) | round )%"
    ) | join("")
  ) + "\n"
  ' "$OUTPUT_DIR/AppUI_CodeCoverageReport_$TIMESTAMP.json" | tee -a "$OUTPUT_DIR/AppUI_CodeCoverageReport_$TIMESTAMP.txt"

  echo "=== Sample App UI Tests End ==="
fi

# Exit with the status code from the xcodebuild command
exit_code=${PIPESTATUS[0]}

# Store the end time
END_TIME=$(date +%s)

# Calculate the total time taken
TOTAL_TIME=$((END_TIME - START_TIME))

# Calculate minutes and seconds
TOTAL_MINUTES=$((TOTAL_TIME / 60))
TOTAL_SECONDS=$((TOTAL_TIME % 60))

# Print the total time taken
echo -e "\nTotal time taken: $TOTAL_MINUTES minutes and $TOTAL_SECONDS seconds"

exit $exit_code
